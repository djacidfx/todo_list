import 'package:flutter/material.dart';

class ActionDialog extends StatelessWidget {
  final String title;
  final String dialogContent;
  final String firstButtonText;
  final String secondButtonText;
  final Function firstButtonFunction;
  final Function secondButtonFunction;
  final IconData firstIconData;
  final double textSize;
  ActionDialog(
      {this.title,
      this.dialogContent,
      this.firstButtonText,
      this.secondButtonText,
      this.firstButtonFunction,
      this.secondButtonFunction,
      this.firstIconData,
      this.textSize});

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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: firstButtonFunction,
                      child: Row(
                        children: [
                          Icon(
                            firstIconData,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            firstButtonText,
                            style: TextStyle(
                                fontSize: textSize, color: Colors.white),
                          ),
                        ],
                      ),
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.all(8),
                        backgroundColor: Color(0xff5D51FF),
                      ),
                    ),
                    TextButton(
                      onPressed: secondButtonFunction,
                      child: Text(
                        secondButtonText,
                        style: TextStyle(
                            fontSize: textSize, color: Color(0xff5D51FF)),
                        overflow: TextOverflow.clip,
                      ),
                      // style: TextButton.styleFrom(
                      //   shape: RoundedRectangleBorder(
                      //     borderRadius: BorderRadius.circular(10),
                      //   ),
                      //   padding: const EdgeInsets.all(16),
                      //   backgroundColor: Colors.blueGrey,
                      // ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
