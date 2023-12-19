import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:share/share.dart';
import 'package:todo_list/ads/admob_service.dart';
import 'package:todo_list/pages/backup.dart';
import 'package:todo_list/pages/notification_settings.dart';
import 'package:todo_list/pages/theme_settings.dart';
import 'package:todo_list/screens/purchases.dart';

import '../task_data.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  void initState() {
    super.initState();
    getPackageInfo();
  }

  bool shouldOpenDialog = false;
  String appVersion;

  getPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    appVersion = packageInfo.version;
  }

  List<DebuggableCondition> debuggableConditions = [];
  RateMyApp rateMyApp;
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskData>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        //TODO new theme 1
        backgroundColor: provider.themeStyle == 'light'
            ? Color(0xff191919)
            : provider.themeStyle == 'crypto'
                ? Color(0xff101118)
                : provider.themeStyle == 'nft'
                    ? Color(0xff822C55)
                    : provider.themeStyle == 'greenArea'
                        ? Color(0xff2D5B57).withOpacity(0.9)
                        : provider.themeStyle == 'swallow'
                            ? Color(0xff2F2D29)
                            : Color(0xff1F8AB5),
      ),
      body: Container(
        //TODO new theme 2
        color: provider.themeStyle == 'light'
            ? Color(0xffFFFFFF)
            : provider.themeStyle == 'crypto'
                ? Color(0xff3C4343)
                : provider.themeStyle == 'nft'
                    ? Color(0xff833A74)
                    : provider.themeStyle == 'greenArea'
                        ? Color(0xff2D5B57)
                        : provider.themeStyle == 'swallow'
                            ? Color(0xff2F2D29)
                            : Color(0xff47B5DF),
        child: LayoutBuilder(
            builder: (builder, constraints) => SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints(minHeight: constraints.maxHeight),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 24.0, left: 24.0, right: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              'General',
                              style: TextStyle(
                                  color: provider.themeStyle == 'swallow'
                                      ? Color(0xffCBB27D)
                                      : Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0),
                            ),
                          ),
                          ListTile(
                            title: Text(
                              'Notifications',
                              style: TextStyle(
                                //TODO new theme 4
                                color: provider.themeStyle == 'light'
                                    ? Colors.black
                                    : provider.themeStyle == 'crypto'
                                        ? Color(0xffC5A791)
                                        : provider.themeStyle == 'nft' ||
                                                provider.themeStyle ==
                                                    'greenArea'
                                            ? Colors.white
                                            : provider.themeStyle == 'swallow'
                                                ? Color(0xffCBB27D)
                                                : Colors.blueGrey,
                              ),
                            ),
                            leading: Icon(
                              Icons.notifications_none,
                              //TODO new theme 5
                              color: provider.themeStyle == 'light'
                                  ? Colors.black
                                  : provider.themeStyle == 'crypto'
                                      ? Color(0xffC5A791)
                                      : provider.themeStyle == 'nft' ||
                                              provider.themeStyle == 'greenArea'
                                          ? Colors.white
                                          : provider.themeStyle == 'swallow'
                                              ? Color(0xffCBB27D)
                                              : Colors.blueGrey,
                            ),
                            onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (_) => NotificationSettings())),
                          ),
                          ListTile(
                            title: Text(
                              'Style',
                              style: TextStyle(
                                //TODO new theme 6
                                color: provider.themeStyle == 'light'
                                    ? Colors.black
                                    : provider.themeStyle == 'crypto'
                                        ? Color(0xffC5A791)
                                        : provider.themeStyle == 'nft' ||
                                                provider.themeStyle ==
                                                    'greenArea'
                                            ? Colors.white
                                            : provider.themeStyle == 'swallow'
                                                ? Color(0xffCBB27D)
                                                : Colors.blueGrey,
                              ),
                            ),
                            leading: Badge(
                              showBadge:
                                  provider.styleBadger == null ? true : false,
                              child: Icon(
                                Icons.palette_outlined,
                                //TODO new theme 7
                                color: provider.themeStyle == 'light'
                                    ? Colors.black
                                    : provider.themeStyle == 'crypto'
                                        ? Color(0xffC5A791)
                                        : provider.themeStyle == 'nft' ||
                                                provider.themeStyle ==
                                                    'greenArea'
                                            ? Colors.white
                                            : provider.themeStyle == 'swallow'
                                                ? Color(0xffCBB27D)
                                                : Colors.blueGrey,
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => ThemeSettings()));
                              provider.toggleStyle(false);
                            },
                          ),
                          ListTile(
                            title: Text(
                              'Version',
                              style: TextStyle(
                                //TODO new theme 8
                                color: provider.themeStyle == 'light'
                                    ? Colors.black
                                    : provider.themeStyle == 'crypto'
                                        ? Color(0xffC5A791)
                                        : provider.themeStyle == 'nft' ||
                                                provider.themeStyle ==
                                                    'greenArea'
                                            ? Colors.white
                                            : provider.themeStyle == 'swallow'
                                                ? Color(0xffCBB27D)
                                                : Colors.blueGrey,
                              ),
                            ),
                            subtitle: Text(
                              '$appVersion',
                              style: TextStyle(
                                //TODO new theme 9
                                color: provider.themeStyle == 'light'
                                    ? Colors.black
                                    : provider.themeStyle == 'crypto'
                                        ? Color(0xffC5A791)
                                        : provider.themeStyle == 'nft' ||
                                                provider.themeStyle ==
                                                    'greenArea'
                                            ? Colors.white
                                            : provider.themeStyle == 'swallow'
                                                ? Color(0xffCBB27D)
                                                : Colors.blueGrey,
                              ),
                            ),
                            leading: Icon(
                              Icons.info_outline,
                              //TODO new theme 10
                              color: provider.themeStyle == 'light'
                                  ? Colors.black
                                  : provider.themeStyle == 'crypto'
                                      ? Color(0xffC5A791)
                                      : provider.themeStyle == 'nft' ||
                                              provider.themeStyle == 'greenArea'
                                          ? Colors.white
                                          : provider.themeStyle == 'swallow'
                                              ? Color(0xffCBB27D)
                                              : Colors.blueGrey,
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 8.0, bottom: 8.0),
                            child: Text(
                              'Account',
                              style: TextStyle(
                                  color: provider.themeStyle == 'swallow'
                                      ? Color(0xffCBB27D)
                                      : Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0),
                            ),
                          ),
                          ListTile(
                            title: Text(
                              'Benefits of Premium',
                              style: TextStyle(
                                //TODO new theme 15
                                color: provider.themeStyle == 'light'
                                    ? Colors.black
                                    : provider.themeStyle == 'crypto'
                                        ? Color(0xffC5A791)
                                        : provider.themeStyle == 'nft' ||
                                                provider.themeStyle ==
                                                    'greenArea'
                                            ? Colors.white
                                            : provider.themeStyle == 'swallow'
                                                ? Color(0xffCBB27D)
                                                : Colors.blueGrey,
                              ),
                            ),
                            leading: Icon(
                              MdiIcons.crown,
                              //TODO new theme 11
                              color: provider.themeStyle == 'light'
                                  ? Colors.black
                                  : provider.themeStyle == 'crypto'
                                      ? Color(0xffC5A791)
                                      : provider.themeStyle == 'nft' ||
                                              provider.themeStyle == 'greenArea'
                                          ? Colors.white
                                          : provider.themeStyle == 'swallow'
                                              ? Color(0xffCBB27D)
                                              : Colors.blueGrey,
                            ),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => Purchases()));
                            },
                          ),
                          ListTile(
                            title: Text(
                              'Back up and Restore',
                              style: TextStyle(
                                //TODO new theme 15
                                color: provider.themeStyle == 'light'
                                    ? Colors.black
                                    : provider.themeStyle == 'crypto'
                                        ? Color(0xffC5A791)
                                        : provider.themeStyle == 'nft' ||
                                                provider.themeStyle ==
                                                    'greenArea'
                                            ? Colors.white
                                            : provider.themeStyle == 'swallow'
                                                ? Color(0xffCBB27D)
                                                : Colors.blueGrey,
                              ),
                            ),
                            leading: Icon(
                              MdiIcons.backupRestore,
                              //TODO new theme 11
                              color: provider.themeStyle == 'light'
                                  ? Colors.black
                                  : provider.themeStyle == 'crypto'
                                      ? Color(0xffC5A791)
                                      : provider.themeStyle == 'nft' ||
                                              provider.themeStyle == 'greenArea'
                                          ? Colors.white
                                          : provider.themeStyle == 'swallow'
                                              ? Color(0xffCBB27D)
                                              : Colors.blueGrey,
                            ),
                            onTap: () {
                              Navigator.of(context).push(
                                  MaterialPageRoute(builder: (_) => Backup()));
                            },
                          ),
                          ListTile(
                            title: Text(
                              'Feedback / Contact Us',
                              style: TextStyle(
                                //TODO new theme 16
                                color: provider.themeStyle == 'light'
                                    ? Colors.black
                                    : provider.themeStyle == 'crypto'
                                        ? Color(0xffC5A791)
                                        : provider.themeStyle == 'nft' ||
                                                provider.themeStyle ==
                                                    'greenArea'
                                            ? Colors.white
                                            : provider.themeStyle == 'swallow'
                                                ? Color(0xffCBB27D)
                                                : Colors.blueGrey,
                              ),
                            ),
                            leading: Icon(
                              Icons.mail_outline,
                              //TODO new theme 12
                              color: provider.themeStyle == 'light'
                                  ? Colors.black
                                  : provider.themeStyle == 'crypto'
                                      ? Color(0xffC5A791)
                                      : provider.themeStyle == 'nft' ||
                                              provider.themeStyle == 'greenArea'
                                          ? Colors.white
                                          : provider.themeStyle == 'swallow'
                                              ? Color(0xffCBB27D)
                                              : Colors.blueGrey,
                            ),
                            onTap: () async {
                              final Email _email = Email(
                                body: '',
                                subject: 'ToDo List Feedback',
                                recipients: ['cosadelabs@gmail.com'],
                              );
                              String _platformResponse;
                              try {
                                await FlutterEmailSender.send(_email);
                                _platformResponse = 'success';
                              } catch (error) {
                                _platformResponse = error.toString();
                              }

                              if (!mounted) return;
                            },
                          ),
                          ListTile(
                            title: Text(
                              'Share',
                              style: TextStyle(
                                //TODO new theme 17
                                color: provider.themeStyle == 'light'
                                    ? Colors.black
                                    : provider.themeStyle == 'crypto'
                                        ? Color(0xffC5A791)
                                        : provider.themeStyle == 'nft' ||
                                                provider.themeStyle ==
                                                    'greenArea'
                                            ? Colors.white
                                            : provider.themeStyle == 'swallow'
                                                ? Color(0xffCBB27D)
                                                : Colors.blueGrey,
                              ),
                            ),
                            leading: Icon(
                              Icons.share_outlined,
                              //TODO new theme 14
                              color: provider.themeStyle == 'light'
                                  ? Colors.black
                                  : provider.themeStyle == 'crypto'
                                      ? Color(0xffC5A791)
                                      : provider.themeStyle == 'nft' ||
                                              provider.themeStyle == 'greenArea'
                                          ? Colors.white
                                          : provider.themeStyle == 'swallow'
                                              ? Color(0xffCBB27D)
                                              : Colors.blueGrey,
                            ),
                            onTap: () {
                              final RenderBox box = context.findRenderObject();
                              Share.share(
                                  'I am using todo list Pro to organize my day, '
                                  'its really a convenient to-do list. Download it here now: '
                                  'https://play.google.com/store/apps/details?id=com.danieljumakowuoche.todo_list',
                                  subject: 'ToDo List Pro',
                                  sharePositionOrigin:
                                      box.localToGlobal(Offset.zero) &
                                          box.size);
                              Navigator.of(context).pop();
                            },
                          ),
                          RateMyAppBuilder(
                            rateMyApp: RateMyApp(
                              googlePlayIdentifier:
                                  'com.danieljumakowuoche.todo_list',
                              minDays: 7,
                              minLaunches: 20,
                              remindDays: 2,
                              remindLaunches: 20,
                            ),
                            onInitialized: (context, rateMyApp) {
                              setState(
                                () {
                                  this.rateMyApp = rateMyApp;
                                },
                              );
                              if (rateMyApp.shouldOpenDialog) {
                                rateMyApp.showStarRateDialog(
                                  context,
                                  title:
                                      'We are working hard to give you a better experience',
                                  message:
                                      'Please Rate us 5 stars if you enjoy our app',
                                  actionsBuilder: actionsBuilder,
                                );
                              }
                            },
                            builder: (context) => rateMyApp == null
                                ? Center(child: CircularProgressIndicator())
                                : ListTile(
                                    title: Text(
                                      'Rate Us',
                                      style: TextStyle(
                                        //TODO new theme 18
                                        color: provider.themeStyle == 'light'
                                            ? Colors.black
                                            : provider.themeStyle == 'crypto'
                                                ? Color(0xffC5A791)
                                                : provider.themeStyle ==
                                                            'nft' ||
                                                        provider.themeStyle ==
                                                            'greenArea'
                                                    ? Colors.white
                                                    : provider.themeStyle ==
                                                            'swallow'
                                                        ? Color(0xffCBB27D)
                                                        : Colors.blueGrey,
                                      ),
                                    ),
                                    leading: Icon(
                                      Icons.star_half,
                                      //TODO new theme 15
                                      color: provider.themeStyle == 'light'
                                          ? Colors.black
                                          : provider.themeStyle == 'crypto'
                                              ? Color(0xffC5A791)
                                              : provider.themeStyle == 'nft' ||
                                                      provider.themeStyle ==
                                                          'greenArea'
                                                  ? Colors.white
                                                  : provider.themeStyle ==
                                                          'swallow'
                                                      ? Color(0xffCBB27D)
                                                      : Colors.blueGrey,
                                    ),
                                    onTap: () async {
                                      await rateMyApp.showStarRateDialog(
                                          context,
                                          title:
                                              'We are working hard to give you a better experience',
                                          message:
                                              'Please Rate us 5 stars if you enjoy our app',
                                          actionsBuilder: actionsBuilder);
                                    },
                                  ),
                          )
                        ],
                      ),
                    ),
                  ),
                )),
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
              color: provider.themeStyle == 'dark'
                  ? Color(0xff47B5DF)
                  : Color(0xffFFFFFF),
            ),
    );
  }

  List<Widget> actionsBuilder(BuildContext context, double stars) =>
      stars == null
          ? [buildCancelButton()]
          : [buildOkButton(stars), buildCancelButton()];
  Widget buildOkButton(double stars) => TextButton(
        child: Text('OK'),
        onPressed: () async {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Thanks for your feedback!')),
          );

          final launchAppStore = stars >= 4;

          final event = RateMyAppEventType.rateButtonPressed;

          await rateMyApp.callEvent(event);

          if (launchAppStore) {
            rateMyApp.launchStore();
          } else {
            final Email email = Email(
              body: '',
              subject: 'ToDo List Feedback',
              recipients: ['cosadelabs@gmail.com'],
            );
            String platformResponse;
            try {
              await FlutterEmailSender.send(email);
              platformResponse = 'success';
            } catch (error) {
              platformResponse = error.toString();
            }

            if (!mounted) return;

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(platformResponse),
              ),
            );
          }

          Navigator.of(context).pop();
        },
      );

  Widget buildCancelButton() => RateMyAppNoButton(
        rateMyApp,
        text: 'CANCEL',
      );
  void refresh() {
    setState(() {
      debuggableConditions =
          rateMyApp.conditions.whereType<DebuggableCondition>().toList();
      shouldOpenDialog = rateMyApp.shouldOpenDialog;
    });
  }
}
