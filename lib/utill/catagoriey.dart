// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class CatagorieyCard extends StatelessWidget {
  const CatagorieyCard({
    Key? key,
    required this.catagorieyName,
    required this.catagorieyEmoji,
  }) : super(key: key);
  final String catagorieyName;
  final String catagorieyEmoji;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 20),
      padding: EdgeInsets.all(12),
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.grey,
        ),
      ),
      child: Column(
        children: [
          Text(catagorieyEmoji,
              style: TextStyle(
                fontSize: 30,
              )),
          SizedBox(
            height: 10,
          ),
          Text(
            catagorieyName,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
