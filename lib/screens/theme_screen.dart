import 'package:flutter/material.dart';
import 'package:todo_list/screens/purchases.dart';

class ThemeScreen extends StatelessWidget {
  final int proThemeNumber;
  ThemeScreen({this.proThemeNumber});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffEFF0D1),
      appBar: AppBar(
        backgroundColor: Color(0xffA50010),
        title: Text('Pro Themes'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => Purchases()));
            },
            child: Text(
              'Apply',
              style: TextStyle(color: Colors.white),
            ),
            style: TextButton.styleFrom(
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.all(8),
              backgroundColor: Colors.blueAccent,
            ),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            //TODO new theme
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Container(
                child: Center(
                  child: Image(
                    image: proThemeNumber == 1
                        ? AssetImage('images/crypto1.png')
                        : proThemeNumber == 3
                            ? AssetImage('images/energy.png')
                            : proThemeNumber == 4
                                ? AssetImage('images/choc.png')
                                : AssetImage('images/nft.png'),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
