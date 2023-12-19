import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/constants.dart';
import 'package:todo_list/menu_layout/tab_page.dart';
import 'package:todo_list/screens/theme_screen.dart';

import '../task_data.dart';

class ThemeSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskData>(context);
    return Scaffold(
      backgroundColor: Color(0xffEFF0D1),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xffA50010),
        title: Text(
          'Theme',
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding:
                  EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 20),
              margin: EdgeInsets.only(top: 20),
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                //TODO new theme 1
                gradient: provider.themeStyle == 'dark'
                    ? LinearGradient(
                        colors: [
                          Color(0xff0B1846),
                          Color(0xff0B1846),
                          Color(0xff0B1846),
                        ],
                      )
                    : provider.themeStyle == 'crypto'
                        ? LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xff201E1C),
                              Color(0xff242627),
                              Color(0xff736744),
                              Color(0xff382316),
                              Color(0xff11120F),
                              Color(0xff372F2B)
                            ],
                          )
                        : provider.themeStyle == 'nft'
                            ? LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(0xff281B41),
                                  Color(0xff34295A),
                                  Color(0xff554F9E),
                                  Color(0xff63429D),
                                  Color(0xff11120F),
                                  Color(0xff833A74)
                                ],
                              )
                            : provider.themeStyle == 'greenArea'
                                ? LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Color(0xff144240),
                                      Color(0xff0C312D),
                                      Color(0xff0C0C0C),
                                      Color(0xff0C0E1B),
                                      Color(0xff0D3C37),
                                      Color(0xff144442)
                                    ],
                                  )
                                : provider.themeStyle == 'swallow'
                                    ? LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Color(0xff4B4842),
                                          Color(0xff4B4842),
                                          Color(0xff2F2D29),
                                          Color(0xff292824),
                                          Color(0xff272521),
                                          Color(0xff262420),
                                        ],
                                      )
                                    : LinearGradient(
                                        colors: [
                                          Color(0xffF2F5FA),
                                          Color(0xffF2F5FA),
                                          Color(0xffF2F5FA),
                                        ],
                                      ),
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
                    'Basic',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: provider.themeStyle == 'crypto' ||
                              provider.themeStyle == 'dark' ||
                              provider.themeStyle == 'nft' ||
                              provider.themeStyle == 'greenArea'
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          provider.toggleTheme('dark');
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8.0),
                          padding: const EdgeInsets.all(16.0),
                          width: 100,
                          decoration: BoxDecoration(
                              color: Color(0xff0B1846),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              border: provider.themeStyle == 'dark'
                                  ? Border.all(color: Colors.red, width: 3)
                                  : Border.all()),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: Icon(
                                  Icons.gradient_outlined,
                                  color: kAllTasksColor,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text('Default Theme',
                                    style: TextStyle(
                                        color: kInProgressColor,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold)),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text('Sub Zero',
                                    style: TextStyle(
                                      color: kCompleteColor,
                                      fontSize: 10.0,
                                    )),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          provider.toggleTheme('light');
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8.0),
                          padding: const EdgeInsets.all(16.0),
                          width: 100,
                          decoration: BoxDecoration(
                            color: Color(0xffF2F5FA),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            border: provider.themeStyle == 'light'
                                ? Border.all(color: Colors.red, width: 3)
                                : Border.all(),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: Icon(Icons.light_mode_outlined),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text('Light Theme',
                                    style: TextStyle(
                                        color: Color(0xff11253B),
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold)),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text('Kitana',
                                    style: TextStyle(
                                      color: Color(0xff6F7C89),
                                      fontSize: 10.0,
                                    )),
                              ),
                            ],
                          ),
                        ),
                      ),
                      //TODO New theme 1 add gesture detector
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Pro',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: provider.themeStyle == 'crypto' ||
                                  provider.themeStyle == 'dark' ||
                                  provider.themeStyle == 'nft' ||
                                  provider.themeStyle == 'greenArea'
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(
                        MdiIcons.crown,
                        color: Colors.orangeAccent,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (provider.isPurchased) {
                            provider.toggleTheme('crypto');
                          } else {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => ThemeScreen(
                                      proThemeNumber: 1,
                                    )));
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8.0),
                          padding: const EdgeInsets.all(16.0),
                          width: 100,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(0xff201E1C),
                                Color(0xff242627),
                                Color(0xff736744),
                                Color(0xff382316),
                                Color(0xff11120F),
                                Color(0xff372F2B)
                              ],
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            //TODO new theme 3 change border string
                            border: provider.themeStyle == 'crypto'
                                ? Border.all(color: Colors.red, width: 3)
                                : Border.all(),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                //TODO new theme 4 change icon
                                child: Icon(
                                  MdiIcons.currencyBtc,
                                  color: Color(0xffEBD6AB),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                //TODO new theme 5 change name
                                child: Text('Crypto',
                                    style: TextStyle(
                                        color: Color(0xffFFFFFF),
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (provider.isPurchased) {
                            provider.toggleTheme('nft');
                          } else {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => ThemeScreen(
                                      proThemeNumber: 2,
                                    )));
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8.0),
                          padding: const EdgeInsets.all(16.0),
                          width: 100,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(0xff281B41),
                                Color(0xff34295A),
                                Color(0xff554F9E),
                                Color(0xff63429D),
                                Color(0xff11120F),
                                Color(0xff833A74)
                              ],
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            //TODO new theme 3 change border string
                            border: provider.themeStyle == 'nft'
                                ? Border.all(color: Colors.red, width: 3)
                                : Border.all(),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                //TODO new theme 4 change icon
                                child: Icon(
                                  MdiIcons.fruitGrapes,
                                  color: Color(0xffEBD6AB),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                //TODO new theme 5 change name
                                child: Text('xBerry',
                                    style: TextStyle(
                                        color: Color(0xffFFFFFF),
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        ),
                      ),
                      //TODO New theme 1 add gesture detector
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (provider.isPurchased) {
                            provider.toggleTheme('greenArea');
                          } else {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => ThemeScreen(
                                      proThemeNumber: 3,
                                    )));
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8.0),
                          padding: const EdgeInsets.all(16.0),
                          width: 100,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(0xff144240),
                                Color(0xff0C312D),
                                Color(0xff0C0C0C),
                                Color(0xff0C0E1B),
                                Color(0xff0D3C37),
                                Color(0xff144442)
                              ],
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            //TODO new theme 3 change border string
                            border: provider.themeStyle == 'greenArea'
                                ? Border.all(color: Colors.red, width: 3)
                                : Border.all(),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                //TODO new theme 4 change icon
                                child: Icon(
                                  MdiIcons.leaf,
                                  color: Color(0xffEBD6AB),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                //TODO new theme 5 change name
                                child: Text('Energy',
                                    style: TextStyle(
                                        color: Color(0xffFFFFFF),
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (provider.isPurchased) {
                            provider.toggleTheme('swallow');
                          } else {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => ThemeScreen(
                                      proThemeNumber: 4,
                                    )));
                          }
                        },
                        child: Badge(
                          badgeContent: Text(
                            'NEW',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          shape: BadgeShape.square,
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8.0),
                            padding: const EdgeInsets.all(16.0),
                            width: 100,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xff4B4842),
                                  Color(0xff4B4842),
                                  Color(0xff2F2D29),
                                  Color(0xff292824),
                                  Color(0xff272521),
                                  Color(0xff262420),
                                ],
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              //TODO new theme 3 change border string
                              border: provider.themeStyle == 'swallow'
                                  ? Border.all(color: Colors.red, width: 3)
                                  : Border.all(),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 16.0),
                                  //TODO new theme 4 change icon
                                  child: Icon(
                                    MdiIcons.flower,
                                    color: Color(0xffCFBE8F),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  //TODO new theme 5 change name
                                  child: Text('Choc',
                                      style: TextStyle(
                                          color: Color(0xffFFFFFF),
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      //TODO New theme 1 add gesture detector
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => TabPage()));
                        },
                        child: Text(
                          'OK',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.all(16),
                          backgroundColor: Color(0xff5D51FF),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
