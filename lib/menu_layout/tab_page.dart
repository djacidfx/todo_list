import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/pages/calendar.dart';
import 'package:todo_list/pages/home.dart';
import 'package:todo_list/pages/my_tasks.dart';
import 'package:todo_list/pages/profile.dart';
import 'package:todo_list/task_data.dart';

class TabPage extends StatefulWidget {
  @override
  _TabPageState createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> {
  int _selectedIndex = 0;

  List<Widget> _widgetOptions = <Widget>[
    MyCards(),
    MyTasks(),
    Calendar(),
    Profile(),
  ];

  @override
  void initState() {
    var provider = Provider.of<TaskData>(context, listen: false);
    provider.initialize();
    super.initState();
  }

  @override
  void dispose() {
    var provider = Provider.of<TaskData>(context, listen: false);
    provider.subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskData>(context);
    return Scaffold(
      // backgroundColor: Color(0xff15224F),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          //TODO new theme 1
          canvasColor: provider.themeStyle == 'dark'
              ? Color(0xff15224F)
              : provider.themeStyle == 'crypto'
                  ? Color(0xff000000)
                  : provider.themeStyle == 'nft'
                      ? Color(0xff2F186B)
                      : provider.themeStyle == 'greenArea'
                          ? Color(0xff2D5B57)
                          : provider.themeStyle == 'swallow'
                              ? Color(0xff2F2D29)
                              : Color(0xffFFFFFF),
        ),
        child: BottomNavigationBar(
          backgroundColor: Color(0xff15224F),
          currentIndex: _selectedIndex,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedItemColor:
              //TODO new theme 6
              provider.themeStyle == 'crypto' ||
                      provider.themeStyle == 'nft' ||
                      provider.themeStyle == 'greenArea'
                  ? Colors.white
                  : provider.themeStyle == 'swallow'
                      ? Color(0xffCBB27D)
                      : Colors.blueGrey,
          unselectedItemColor:
              //TODO new theme 7
              provider.themeStyle == 'crypto' ||
                      provider.themeStyle == 'greenArea'
                  ? Color(0xffC19E66)
                  : provider.themeStyle == 'nft'
                      ? Color(0xff677394)
                      : provider.themeStyle == 'swallow'
                          ? Color(0xffA6733D)
                          : Colors.brown,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                //TODO new theme 2
                color: provider.themeStyle == 'dark'
                    ? Colors.blue
                    : provider.themeStyle == 'crypto'
                        ? Color(0xffC19E66)
                        : provider.themeStyle == 'nft'
                            ? Color(0xff677394)
                            : provider.themeStyle == 'swallow'
                                ? Color(0xffA6733D)
                                : Color(0xff191919),
              ),
              label: 'Home',
              activeIcon: Icon(
                Icons.home,
                color: provider.themeStyle == 'dark'
                    ? Colors.redAccent
                    : provider.themeStyle == 'swallow'
                        ? Color(0xffCBB27D)
                        : Colors.white,
              ),
            ),
            BottomNavigationBarItem(
              icon: Badge(
                showBadge: provider.taskBadger == null ? true : false,
                child: Icon(
                  Icons.format_list_bulleted,
                  //TODO new theme 3
                  color: provider.themeStyle == 'dark'
                      ? Colors.blue
                      : provider.themeStyle == 'crypto'
                          ? Color(0xffC19E66)
                          : provider.themeStyle == 'nft'
                              ? Color(0xff677394)
                              : provider.themeStyle == 'swallow'
                                  ? Color(0xffA6733D)
                                  : Color(0xff191919),
                  size: 28,
                ),
              ),
              label: 'My Tasks',
              activeIcon: Icon(
                Icons.format_list_bulleted,
                color: provider.themeStyle == 'dark'
                    ? Colors.redAccent
                    : provider.themeStyle == 'crypto' ||
                            provider.themeStyle == 'nft'
                        ? Colors.white
                        : provider.themeStyle == 'swallow'
                            ? Color(0xffCBB27D)
                            : Color(0xffADB7C1),
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.calendar_today,
                color: provider.themeStyle == 'dark'
                    ? Colors.blue
                    : provider.themeStyle == 'crypto'
                        ? Color(0xffC19E66)
                        : provider.themeStyle == 'nft'
                            ? Color(0xff677394)
                            : provider.themeStyle == 'swallow'
                                ? Color(0xffA6733D)
                                : Color(0xff191919),
              ),
              label: 'Calendar',
              activeIcon: Icon(
                Icons.calendar_today,
                //TODO new theme 4
                color: provider.themeStyle == 'dark'
                    ? Colors.redAccent
                    : provider.themeStyle == 'crypto' ||
                            provider.themeStyle == 'nft'
                        ? Colors.white
                        : provider.themeStyle == 'swallow'
                            ? Color(0xffCBB27D)
                            : Color(0xffADB7C1),
              ),
            ),
            BottomNavigationBarItem(
              icon: Badge(
                showBadge: provider.profileBadger == null ? true : false,
                child: Icon(
                  Icons.account_circle,
                  //TODO new theme 5
                  color: provider.themeStyle == 'dark'
                      ? Colors.blue
                      : provider.themeStyle == 'crypto'
                          ? Color(0xffC19E66)
                          : provider.themeStyle == 'nft'
                              ? Color(0xff677394)
                              : provider.themeStyle == 'swallow'
                                  ? Color(0xffA6733D)
                                  : Color(0xff191919),
                ),
              ),
              label: 'Profile',
              activeIcon: Icon(
                Icons.account_circle,
                //TODO new theme 6
                color: provider.themeStyle == 'dark'
                    ? Colors.redAccent
                    : provider.themeStyle == 'crypto' ||
                            provider.themeStyle == 'nft'
                        ? Colors.white
                        : provider.themeStyle == 'swallow'
                            ? Color(0xffCBB27D)
                            : Color(0xffADB7C1),
              ),
            ),
          ],
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
            if (index == 3) {
              provider.toggleBadge(false);
            } else if (index == 1) {
              provider.toggleTask(false);
            }
          },
        ),
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
    );
  }
}
