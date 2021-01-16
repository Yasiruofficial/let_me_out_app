import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {
  final String text;
  final double vertical;
  CustomDivider({this.text, this.vertical = 10});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: vertical),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: (text != null) ? 10 : 0),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          Text((text != null) ? "$text" : ""),
          Expanded(
            child: Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: (text != null) ? 10 : 0),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
