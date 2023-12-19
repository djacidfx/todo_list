import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/pages/notification_help.dart';
import '../task_data.dart';

class NotificationSettings extends StatefulWidget {
  const NotificationSettings({Key key}) : super(key: key);

  @override
  _NotificationSettingsState createState() => _NotificationSettingsState();
}

class _NotificationSettingsState extends State<NotificationSettings> {
  String key = 'Remind Me';
  bool isSwitched = false;
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskData>(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        brightness: Brightness.light,
        //TODO new theme 1
        backgroundColor: provider.themeStyle == 'dark'
            ? Color(0xff13204D)
            : provider.themeStyle == 'crypto'
                ? Color(0xff55462F)
                : provider.themeStyle == 'nft'
                    ? Color(0xff281B41)
                    : provider.themeStyle == 'greenArea'
                        ? Color(0xff20C312D)
                        : Colors.transparent,
        title: Text(
          'Notification Settings',
          style: TextStyle(color: Colors.grey[400]),
        ),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          //TODO new theme 2
          color: provider.themeStyle == 'dark'
              ? Color(0xffC4D2F8)
              : provider.themeStyle == 'crypto'
                  ? Color(0xff55462F)
                  : provider.themeStyle == 'nft'
                      ? Color(0xff020000)
                      : provider.themeStyle == 'greenArea'
                          ? Color(0xff2D5B57)
                          : Color(0xffF2F7FF),
        ),
        padding: const EdgeInsets.only(left: 16, right: 16, top: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text(
                'Notifications & Reminders',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0),
              ),
            ),
            ListTile(
              title: Text(
                'Task Reminder Does Not Work',
                style: TextStyle(fontSize: 18),
              ),
              subtitle: Text(
                'Tap to find solutions',
                style: TextStyle(fontSize: 18),
              ),
              trailing: Icon(Icons.help_outline),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => NotificationHelp()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
