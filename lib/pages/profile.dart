import 'dart:io';

import 'package:badges/badges.dart';
import 'package:date_count_down/date_count_down.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/ads/admob_service.dart';
import 'package:todo_list/pages/donation.dart';
import 'package:todo_list/pages/settings.dart';
import 'package:todo_list/screens/achievements.dart';
import 'package:todo_list/screens/purchases.dart';
import 'package:todo_list/task_data.dart';
import 'package:todo_list/widgets/action_dialog.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  void initState() {
    super.initState();
    _today = DateTime.now();
    getLastDay();
  }

  DateTime _today;
  int _lastDay;
  DateTime _endOfMonth;
  DateTime _midMonth;
  DateTime _midMonthPlusOne;
  DateTime _threeDaysBeforeEnd;

  getLastDay() {
    _lastDay = DateTime(_today.year, _today.month + 1, 0, 0, 0, 0).day;
    _endOfMonth = DateTime(_today.year, _today.month, _lastDay).toUtc();
    _midMonth = DateTime(_today.year, _today.month, 15).toUtc();
    _midMonthPlusOne = _midMonth.add(Duration(days: 1));
  }

  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Do you want to quit?'),
            content: Text(
                '\'Setting clear goals and finding measures that will mark progress toward them can improve the human condition\' - Bill Gates'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('No'),
              ),
              TextButton(
                onPressed: () => exit(0),
                child: Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskData>(context);
    _threeDaysBeforeEnd = _endOfMonth.subtract(Duration(days: 3));
    bool _todayGreaterThan = _threeDaysBeforeEnd.compareTo(_today) <= 0;
    bool _todayLessThan = _endOfMonth.compareTo(_today) >= 0;
    bool _todayGreaterThanMid = _midMonth.compareTo(_today) <= 0;
    bool _todayLessThanMid = _midMonthPlusOne.compareTo(_today) >= 0;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        //TODO new theme 1
        backgroundColor: provider.themeStyle == 'nft'
            ? Color(0xff281B41)
            : provider.themeStyle == 'greenArea'
                ? Color(0xff20C312D)
                : provider.themeStyle == 'swallow'
                    ? Color(0xff2F2D29)
                    : Color(0xff2E343B),
        body: SingleChildScrollView(
          child: Container(
            //TODO new theme 2
            color: provider.themeStyle == 'nft'
                ? Color(0xff281B41)
                : provider.themeStyle == 'greenArea'
                    ? Color(0xff20C312D)
                    : provider.themeStyle == 'swallow'
                        ? Color(0xff2F2D29)
                        : Color(0xff2E343B),
            child: Padding(
              padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 75.0),
              child: Column(
                children: [
                  ListTile(
                    title: Text(
                      'Achievements',
                      //TODO new theme 3
                      style: TextStyle(
                          color: provider.themeStyle == 'swallow'
                              ? Color(0xffCBB27D)
                              : Colors.white),
                    ),
                    subtitle: Text(
                      'Dashboards and Awards',
                      style: TextStyle(
                          color: provider.themeStyle == 'swallow'
                              ? Color(0xffCBB27D)
                              : Colors.white70),
                    ),
                    leading: Icon(
                      Icons.school_outlined,
                      color: provider.themeStyle == 'swallow'
                          ? Color(0xffCBB27D)
                          : Colors.white,
                    ),
                    trailing: Icon(Icons.chevron_right,
                        color: provider.themeStyle == 'swallow'
                            ? Color(0xffCBB27D)
                            : Colors.white70),
                    onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => Achievements())),
                  ),
                  Divider(),
                  ListTile(
                    title: Text(
                      'Settings',
                      style: TextStyle(
                          color: provider.themeStyle == 'swallow'
                              ? Color(0xffCBB27D)
                              : Colors.white),
                    ),
                    subtitle: Text(
                      'General and Account',
                      style: TextStyle(
                          color: provider.themeStyle == 'swallow'
                              ? Color(0xffCBB27D)
                              : Colors.white70),
                    ),
                    leading: Badge(
                      showBadge: provider.settingsBadger == null ? true : false,
                      child: Icon(
                        Icons.settings,
                        color: provider.themeStyle == 'swallow'
                            ? Color(0xffCBB27D)
                            : Colors.white,
                      ),
                    ),
                    trailing: Icon(Icons.chevron_right,
                        color: provider.themeStyle == 'swallow'
                            ? Color(0xffCBB27D)
                            : Colors.white70),
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (_) => Settings()));
                      provider.toggleSettings(false);
                    },
                  ),
                  Divider(),
                  ListTile(
                    title: Text(
                      'Benefits of Premium',
                      style: TextStyle(
                          color: provider.themeStyle == 'swallow'
                              ? Color(0xffCBB27D)
                              : Colors.white),
                    ),
                    subtitle: Text(
                      'Results and Features',
                      style: TextStyle(
                          color: provider.themeStyle == 'swallow'
                              ? Color(0xffCBB27D)
                              : Colors.white70),
                    ),
                    leading: Icon(
                      MdiIcons.crown,
                      color: provider.themeStyle == 'swallow'
                          ? Color(0xffCBB27D)
                          : Colors.white,
                    ),
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (_) => Purchases()));
                    },
                    trailing: Icon(Icons.chevron_right,
                        color: provider.themeStyle == 'swallow'
                            ? Color(0xffCBB27D)
                            : Colors.white70),
                  ),
                  Divider(),
                  InkWell(
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (_) => Donation()));
                    },
                    child: Container(
                      height: 50,
                      width: 200,
                      decoration: BoxDecoration(
                          color: provider.themeStyle == 'dark'
                              ? Colors.purple
                              : provider.themeStyle == 'swallow'
                                  ? Color(0xffFFBFB1)
                                  : Color(0xffB1B5B9),
                          borderRadius: BorderRadius.circular(20.0)),
                      child: Center(
                        child: Text("❤  Donate",
                            style: TextStyle(
                                color: provider.themeStyle == 'swallow'
                                    ? Color(0xff523D39)
                                    : Color(0xfffefefe),
                                fontWeight: FontWeight.w600,
                                fontSize: 15.0)),
                      ),
                    ),
                  ),
                  Divider(),
                  !provider.isPurchased
                      ? _todayGreaterThan && _todayLessThan
                          ? Container(
                              margin: const EdgeInsets.all(16.0),
                              padding: const EdgeInsets.fromLTRB(
                                  16.0, 16.0, 16.0, 16.0),
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: [
                                    Color(0xff6071B0),
                                    Color(0xff8980B8),
                                    Color(0xffB294C0),
                                  ]),
                                  color: Color(0xffE6ECEB),
                                  borderRadius: BorderRadius.circular(20)),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'BIG SAVE REWARD',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Icon(
                                        Icons.redeem_outlined,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '50% OFF',
                                            style: TextStyle(
                                              fontSize: 26,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Text(
                                            'LifeTime',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (_) => Purchases()));
                                        },
                                        child: Container(
                                          width: 140,
                                          decoration: BoxDecoration(
                                              color: Colors.orangeAccent,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(24))),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16.0, vertical: 8.0),
                                          child: Center(
                                            child: Text(
                                              'Redeem Now',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        'Expires in ',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      CountDownText(
                                        due: _endOfMonth,
                                        finishedText: 'Expired',
                                        showLabel: true,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          : _todayLessThanMid && _todayGreaterThanMid
                              ? Container(
                                  margin: const EdgeInsets.all(16.0),
                                  padding: const EdgeInsets.fromLTRB(
                                      16.0, 16.0, 16.0, 16.0),
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(colors: [
                                        Color(0xff6071B0),
                                        Color(0xff8980B8),
                                        Color(0xffB294C0),
                                      ]),
                                      color: Color(0xffE6ECEB),
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Special Thanksgiving offer',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          Icon(
                                            Icons.flash_on_outlined,
                                            color: Colors.white,
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '80% OFF',
                                                style: TextStyle(
                                                  fontSize: 26,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              Text(
                                                'Lifetime Subscription',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (_) =>
                                                          Purchases()));
                                            },
                                            child: Container(
                                              width: 140,
                                              decoration: BoxDecoration(
                                                  color: Colors.orangeAccent,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(24))),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 16.0,
                                                      vertical: 8.0),
                                              child: Center(
                                                child: Text(
                                                  'Redeem Now',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        'Few Coupons Left',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                )
                              : Container()
                      : Container(),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: !provider.isPurchased
            ? Container(
                height: 65,
                child: AdWidget(
                  key: UniqueKey(),
                  ad: AdMobService.createBannerAd()..load(),
                ),
              )
            : Container(
                height: 65,
                color: Color(0xff2E343B),
              ),
      ),
    );
  }
}
