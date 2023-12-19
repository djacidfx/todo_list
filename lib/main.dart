import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:todo_list/ads/admob_service.dart';
import 'package:todo_list/menu_layout/tab_page.dart';
import 'package:todo_list/task_data.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

void main() async {
  InAppPurchaseConnection.enablePendingPurchases();
  WidgetsFlutterBinding.ensureInitialized();
  AdMobService.initialize();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TaskData>(
      create: (context) => TaskData(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'TODO LIST',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: TabPage(),
      ),
    );
  }
}
