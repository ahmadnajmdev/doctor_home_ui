#!/bin/sh
#
# guard-payload.sh — detect injected obfuscated stagers and auto-run droppers.
#
# Single source of truth for BOTH the local pre-commit hook (.githooks/pre-commit)
# and CI (.github/workflows/payload-guard.yml).
#
# Usage:
#   bin/guard-payload.sh [file ...]   # scan given files (hook passes staged paths)
#   bin/guard-payload.sh              # scan every tracked file
#
# Exit 0 = clean, 1 = something found.
#
# ---------------------------------------------------------------------------
# History. v1 was written after an obfuscated Node dropper was appended to
# vite.config.js. On 2026-08-25 a sweep found three implant types across 77
# repositories; v1 caught only the first of them:
#
#   vite.config.js dropper .... caught (by the long-line rule)
#   fake .woff2 dropper ....... MISSED — extension was never scanned
#   .vscode folderOpen task ... MISSED — JSON is exempt from the long-line rule
#
# v2 adds rules C-F below. Rule C is the important one: it keys on the delivery
# trick itself (content pushed past a long run of leading spaces) rather than on
# a filename or an extension, so a rename does not evade it.
#
# v3 (2026-09-23) after the third mass force-push. The campaign is PolinRider
# (DPRK / Lazarus, Contagious Interview cluster); see apache/superset#39299.
# That round slipped past two rules and was caught only by rule F:
#
#   fa-solid-500.woff2 ........ rule E knew 400, not 500  -> E generalised
#   padded with TABs .......... rule C tested spaces only  -> C takes 0x09 too
#
# Relying on a single surviving rule is how the next variant gets through, so
# v3 widens both, adds the published PolinRider signatures to rule A, and adds
# rule G for the cover-tracks tooling that does the force-pushing.
# ---------------------------------------------------------------------------
set -eu

# Rule A — known stager signatures.
#   global['!']= / global[x]=require  hijacking require() at load
#   global.i="A8-...                  the 2026-08 wave, dot notation (v1 missed this)
#   String.fromCharCode(127)          DEL-char scrambler construction
#   var _$_xx=(function / )(LQI       the original scrambler
#   rmcej%otb% / Cot%3t=shtP          PolinRider string literals (both variants)
#   function MDy( / _$_1e42           PolinRider decoder names (new / original)
SIG='String\.fromCharCode\(127\)|global\[[^]]*\] *= *(require|function)|global\[.[^]].\] *=|global\.[A-Za-z_$][A-Za-z0-9_$]* *= *"A8-|var _\$_[0-9a-f]{2,} *= *\(function|\)\(LQI|rmcej%otb%|Cot%3t=shtP|function MDy *\(|_\$_1e42'

is_source() {
    case "$1" in
        *.js|*.cjs|*.mjs|*.jsx|*.ts|*.tsx|*.json) return 0 ;;
        *) return 1 ;;
    esac
}

if [ "$#" -gt 0 ]; then
    files="$*"
else
    files=$(git ls-files | grep -vE 'node_modules/|vendor/|public/build/|/dist/' || true)
fi

flagged=""
flag() { flagged="$flagged
  $1"; }

for file in $files; do
    [ -f "$file" ] || continue
    case "$file" in node_modules/*|vendor/*|public/build/*|*/dist/*) continue ;; esac

    # --- Rule C: content hidden behind a run of leading whitespace ---------
    # The 2026-08 "font" began with hundreds of spaces; the 2026-09-23 one used
    # TABs instead and walked straight past a space-only test. Accept any mix of
    # 0x20 and 0x09 so the next padding byte choice does not need a new rule.
    # Compared as hex so binary files are handled safely (BSD tr mangles them).
    if [ -s "$file" ]; then
        head16=$(dd if="$file" bs=1 count=16 2>/dev/null | od -An -v -tx1 | tr -d ' \n')
        if printf '%s' "$head16" | grep -Eq '^(20|09){16}$'; then
            flag "$file — begins with 16+ whitespace bytes (dropper hidden behind padding)"
            continue
        fi
    fi

    # --- Rule E: fabricated FontAwesome filename --------------------------
    # FontAwesome ships exactly three face files: fa-solid-900, fa-regular-400
    # and fa-brands-400. Any other weight is attacker-invented. Pinning the bad
    # names (400) was the v2 mistake — fa-solid-500 walked past it — so v3 pins
    # the three GOOD names and flags every other fa-* face instead.
    base=${file##*/}
    case "$base" in
        fa-solid-900.*|fa-regular-400.*|fa-brands-400.*|fa-v4compatibility.*) : ;;
        fa-solid-*|fa-regular-*|fa-brands-*)
            flag "$file — $base is not a FontAwesome release filename"
            continue ;;
    esac

    # --- Rule G: cover-tracks / propagation tooling -----------------------
    # PolinRider stage 4 rewrites the last commit keeping its original
    # timestamp, skips the hooks and force-pushes — which is why the forged
    # commits carry a committer date identical to the real one they replace.
    # The 2026-09-19 round added these names to .gitignore to hide them.
    case "$base" in
        temp_auto_push.bat|temp_interactive_push.bat|branch_structure.json)
            flag "$file — PolinRider propagation/cover-tracks tool"
            continue ;;
    esac
    case "$file" in
        *.bat)
            if grep -q 'LAST_COMMIT_DATE' "$file" 2>/dev/null; then
                flag "$file — .bat referencing LAST_COMMIT_DATE (commit-date forgery)"
                continue
            fi ;;
    esac

    # --- Rule F: font extension whose magic number disagrees --------------
    case "$file" in
        *.woff2|*.woff|*.otf)
            magic=$(dd if="$file" bs=1 count=4 2>/dev/null | od -An -tx1 | tr -d ' \n')
            case "$file:$magic" in
                *.woff2:774f4632) : ;;
                *.woff:774f4646)  : ;;
                *.otf:4f54544f)   : ;;
                *) flag "$file — not a font: magic 0x$magic" ; continue ;;
            esac ;;
    esac

    # --- Rule D: editor auto-run triggers and enablers ---------------------
    # tasks.json ran the dropper on folderOpen; settings.json carried
    # task.allowAutomaticTasks, which suppresses VS Code's confirm prompt.
    case "$file" in
        *.vscode/tasks.json|*.vscode/settings.json|*tasks.json)
            if grep -q 'folderOpen' "$file" 2>/dev/null; then
                flag "$file — editor task set to run on folderOpen"
                continue
            fi
            if grep -q 'allowAutomaticTasks' "$file" 2>/dev/null; then
                flag "$file — task.allowAutomaticTasks suppresses the auto-run prompt"
                continue
            fi ;;
    esac

    is_source "$file" || continue

    # --- Rule A: signature match ------------------------------------------
    if grep -EIq "$SIG" "$file" 2>/dev/null; then
        flag "$file — stager signature"
        continue
    fi

    # --- Rule B: one absurdly long line among otherwise normal source -----
    # The injected payloads were a single 5KB-31KB line appended to a file that
    # was otherwise ordinary. A minified bundle is ALL long lines and only one
    # or two lines total, so requiring >5 lines separates the two cleanly.
    # Published vendor assets are skipped outright.
    case "$file" in
        *.json|*.min.js|*.min.ts) continue ;;
        public/js/*|public/css/*|public/vendor/*|*/public/js/*|*/public/css/*|*/public/vendor/*) continue ;;
    esac
    lines=$(wc -l < "$file" 2>/dev/null | tr -d ' ')
    if [ "${lines:-0}" -gt 5 ] && ! awk 'length > 800 { exit 1 }' "$file" 2>/dev/null; then
        flag "$file — single line over 800 characters in otherwise normal source"
    fi
done

if [ -n "$flagged" ]; then
    printf '\n\033[31mPayload guard: refusing this tree.\033[0m\n%s\n\n' "$flagged"
    printf 'If one of these is a genuine false positive, fix the rule in\n'
    printf 'bin/guard-payload.sh rather than bypassing the hook with --no-verify.\n\n'
    exit 1
fi

exit 0
