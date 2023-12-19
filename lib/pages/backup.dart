import 'package:flutter/material.dart';

class Backup extends StatefulWidget {
  const Backup({Key key}) : super(key: key);

  @override
  State<Backup> createState() => _BackupState();
}

class _BackupState extends State<Backup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Backup'),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 40.0),
        child: Column(
          children: [
            Text('ToDo List apps Data saved in this device can be backed up in '
                'your Google Drive Folder and you don\'t have to login this app.'),
            SizedBox(
              height: 15,
            ),
            Text(
                'You can check if Todo list is among the list of apps that have '
                'been backed up in google drive in the Drive app\'s navigation '
                'drawer under Backups > Device > App Data.'),
            SizedBox(
              height: 15,
            ),
            Text(
                'If you can\'t see todo list go to the Drive app\'s navigation '
                'drawer under Settings>Backup and Reset, click \'Backup now\''),
            SizedBox(
              height: 15,
            ),
            Text(
                'Data is restored whenever the app is installed from PlayStore'),
          ],
        ),
      ),
    );
  }
}
