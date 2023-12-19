import 'package:flutter/material.dart';

class InformationDialog extends StatelessWidget {
  final String title;
  final String dialogContent;
  InformationDialog({this.title, this.dialogContent});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(left: 20, top: 65, right: 20, bottom: 20),
            margin: EdgeInsets.only(top: 45),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  offset: Offset(0, 10),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  dialogContent,
                  style: TextStyle(
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 22,
                ),
                Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Got it',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(16),
                      backgroundColor: Color(0xff5D51FF),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
