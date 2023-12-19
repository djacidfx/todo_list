import 'package:flutter/material.dart';

class LabelText extends StatelessWidget {
  LabelText({this.label, this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Color(0xff303054),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            '$value',
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            '$label',
            style: TextStyle(
              fontSize: 10,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}
