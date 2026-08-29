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
# ---------------------------------------------------------------------------
set -eu

# Rule A — known stager signatures.
#   global['!']= / global[x]=require  hijacking require() at load
#   global.i="A8-...                  the 2026-08 wave, dot notation (v1 missed this)
#   String.fromCharCode(127)          DEL-char scrambler construction
#   var _$_xx=(function / )(LQI       the original scrambler
SIG='String\.fromCharCode\(127\)|global\[[^]]*\] *= *(require|function)|global\[.[^]].\] *=|global\.[A-Za-z_$][A-Za-z0-9_$]* *= *"A8-|var _\$_[0-9a-f]{2,} *= *\(function|\)\(LQI'

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

    # --- Rule C: content hidden behind a run of leading spaces -------------
    # The disguised "font" was 31,303 bytes that began with hundreds of spaces.
    # Compared as hex so binary files are handled safely (BSD tr mangles them).
    if [ -s "$file" ]; then
        head16=$(dd if="$file" bs=1 count=16 2>/dev/null | od -An -v -tx1 | tr -d ' \n')
        if [ "$head16" = "20202020202020202020202020202020" ]; then
            flag "$file — begins with 16+ space bytes (dropper hidden behind whitespace)"
            continue
        fi
    fi

    # --- Rule E: fabricated FontAwesome filename --------------------------
    # FontAwesome ships fa-solid-900, fa-regular-400 and fa-brands-400.
    # There is no fa-solid-400 in any release; the name is attacker-invented.
    case "$file" in
        *fa-solid-400.woff2|*fa-solid-400.woff|*fa-solid-400.ttf)
            flag "$file — fa-solid-400 is not a real FontAwesome file"
            continue ;;
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
