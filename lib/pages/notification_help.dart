import 'package:android_power_manager/android_power_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:system_settings/system_settings.dart';

import '../task_data.dart';

class NotificationHelp extends StatefulWidget {
  @override
  _NotificationHelpState createState() => _NotificationHelpState();
}

class _NotificationHelpState extends State<NotificationHelp> {
  String _isIgnoringBatteryOptimizations = 'Unknown';
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    if (!mounted) return;
    String isIgnoringBatteryOptimizations = await _checkBatteryOptimizations();
    setState(() {
      _isIgnoringBatteryOptimizations = isIgnoringBatteryOptimizations;
    });
  }

  Future<String> _checkBatteryOptimizations() async {
    String isIgnoringBatteryOptimizations;
    try {
      isIgnoringBatteryOptimizations =
          '${await AndroidPowerManager.isIgnoringBatteryOptimizations}';
    } on PlatformException {
      isIgnoringBatteryOptimizations = 'Failed to get platform version.';
    }
    return isIgnoringBatteryOptimizations;
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskData>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification Help'),
      ),
      body: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          color: provider.themeStyle == 'dark'
              ? Color(0xffC4D2F8)
              : Color(0xffF2F7FF),
        ),
        padding: const EdgeInsets.only(left: 16, right: 16, top: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text(
                'Notification message does not show',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text(
                'ToDo List may be cleared from the background by the system. '
                'If you don\'t receive notifications from the app, '
                'please follow these steps',
                style: TextStyle(color: Colors.black, fontSize: 18.0),
              ),
            ),
            ListTile(
              title: Text(
                'Allow Notification',
                style: TextStyle(fontSize: 18),
              ),
              subtitle: Text(
                'Tap to Enable in the system',
                style: TextStyle(fontSize: 18),
              ),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                SystemSettings.appNotifications();
              },
            ),
            ListTile(
              title: Text(
                'Ignore battery saving mode',
                style: TextStyle(fontSize: 18),
              ),
              trailing: Text(
                '${_isIgnoringBatteryOptimizations == 'false' ? 'Set now' : 'Enabled'}',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () async {
                bool success = await AndroidPowerManager
                    .requestIgnoreBatteryOptimizations();
                if (success) {
                  String isIgnoringBatteryOptimizations =
                      await _checkBatteryOptimizations();
                  setState(() {
                    _isIgnoringBatteryOptimizations =
                        isIgnoringBatteryOptimizations;
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
