import 'dart:async';
import 'dart:io';
import 'package:badges/badges.dart';
import 'package:date_count_down/date_count_down.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lottie/lottie.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list/ads/admob_service.dart';
import 'package:todo_list/calendar_model.dart';
import 'package:todo_list/constants.dart';
import 'package:todo_list/db.dart';
import 'package:todo_list/menu_layout/tab_page.dart';
import 'package:todo_list/pages/calendar.dart';
import 'package:todo_list/pages/home.dart';
import 'package:todo_list/screens/add_tasksScreen.dart';
import 'package:todo_list/screens/purchases.dart';
import 'package:todo_list/screens/view_task.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/widgets/action_dialog.dart';

import '../task_data.dart';

class MyTasks extends StatefulWidget {
  @override
  _MyTasksState createState() => _MyTasksState();
}

class _MyTasksState extends State<MyTasks> {
  int status;
  Future<List<CalendarItem>> _taskList;
  List<Map<String, dynamic>> _results;
  List<CalendarItem> _uncompletedTasks;
  DateTime _today;
  int maxMyTasks;
  String _formattedDate =
      DateTime.parse(DateFormat('yyyy-MM-dd').format(DateTime.now()))
          .toString();

  List<int> badgeMyNumbers = [
    4,
    14,
    24,
    39,
    54,
    69,
    89,
    109,
    129,
    149,
    169,
    199
  ];
  Widget _taskCell(CalendarItem item) {
    var _formatter = DateFormat.yMMMMd('en_US');
    var provida = Provider.of<TaskData>(context, listen: false);
    String _dateFormatted = _formatter.format(DateTime.parse(
        DateFormat('yyyy-MM-dd').format(DateTime.parse(item.date))));
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => ViewTask(
                        taskSelected: item,
                      ))).then(_onGoBack);
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            // TODO new theme 8
            gradient: item.status == 1
                ? provida.themeStyle == 'dark'
                    ? LinearGradient(
                        colors: [
                          Color(0xff64C939),
                          Color(0xff84CB44),
                          Color(0xffBBD156)
                        ],
                      )
                    : provida.themeStyle == 'crypto' ||
                            provida.themeStyle == 'nft' ||
                            provida.themeStyle == 'greenArea' ||
                            provida.themeStyle == 'swallow'
                        ? LinearGradient(
                            colors: [
                              Color(0xff64C939).withOpacity(0.5),
                              Color(0xff84CB44).withOpacity(0.3),
                              Color(0xffBBD156).withOpacity(0.2)
                            ],
                          )
                        : LinearGradient(
                            colors: [
                              Color(0xff90B5B6),
                              Color(0xff90B5B6),
                              Color(0xff90B5B6),
                            ],
                          )
                : provida.themeStyle == 'dark'
                    ? LinearGradient(
                        colors: [
                          Color(0xffE55049),
                          Color(0xffEE684D),
                          Color(0xffF78353)
                        ],
                      )
                    : provida.themeStyle == 'crypto' ||
                            provida.themeStyle == 'nft' ||
                            provida.themeStyle == 'greenArea' ||
                            provida.themeStyle == 'swallow'
                        ? LinearGradient(
                            colors: [
                              Color(0xffF94018).withOpacity(0.7),
                              Color(0xffF94018).withOpacity(0.5),
                              Color(0xffF94018).withOpacity(0.4)
                            ],
                          )
                        : LinearGradient(
                            colors: [
                              Color(0xffE4BBBB),
                              Color(0xffFFBDBC),
                              Color(0xffFFBDBC)
                            ],
                          ),
            // color: item.status == 1 ? kCompleteColor : Colors.blueGrey[200],
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                color: Colors.deepPurpleAccent.withOpacity(0.1), width: 2),
            boxShadow: [
              BoxShadow(
                color: Color(0xff343559).withOpacity(0.4),
                offset: Offset(0, 8),
                blurRadius: 10,
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  SizedBox(
                    width: 20,
                    height: 60,
                    child: item.status == 1
                        ? IconButton(
                            icon: Icon(Icons.check_circle_outline),
                            onPressed: () {
                              Provider.of<TaskData>(context, listen: false)
                                  .markPending(item);
                              _updateTaskList();
                            },
                          )
                        : Icon(Icons.history_toggle_off),
                  ),
                ],
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            _dateFormatted,
                            //TODO new theme 9
                            style: provida.themeStyle == 'crypto' ||
                                    provida.themeStyle == 'nft' ||
                                    provida.themeStyle == 'greenArea' ||
                                    provida.themeStyle == 'swallow'
                                ? TextStyle(
                                    fontSize: 10,
                                    color: provida.themeStyle == 'swallow'
                                        ? Color(0xffCBB27D)
                                        : Colors.white)
                                : kDateTextStyle,
                          ),
                        ),
                        Text(
                          item.time,
                          //TODO new theme 10
                          style: provida.themeStyle == 'crypto' ||
                                  provida.themeStyle == 'nft' ||
                                  provida.themeStyle == 'greenArea' ||
                                  provida.themeStyle == 'swallow'
                              ? TextStyle(
                                  fontSize: 10,
                                  color: provida.themeStyle == 'swallow'
                                      ? Color(0xffCBB27D)
                                      : Colors.white)
                              : kTimeTextStyle,
                        )
                      ],
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Text(
                      item.name,
                      overflow: TextOverflow.ellipsis,
                      style: kSubTextStyle,
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        _reportInnerCell(item),
                        SizedBox(
                          width: 10,
                        ),
                        _deleteButton(item),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<CalendarItem> _completeMyTaskList = [];
  getMyCompleteTasks() async {
    var tasks = await DB.getStatusList(CalendarItem.table, 1);
    setState(() {
      _completeMyTaskList = tasks;
    });
  }

  Widget _reportInnerCell(CalendarItem item) {
    List<int> currentMyNumberComplete = badgeMyNumbers
        .where((element) => element - _completeMyTaskList.length == 0)
        .toList();
    return GestureDetector(
      onTap: () {
        if (item.status == 0) {
          Provider.of<TaskData>(context, listen: false).markComplete(item);
          if (currentMyNumberComplete.isNotEmpty) {
            var numComplete = currentMyNumberComplete[0] + 1;
            _showMaterialDialog(numComplete);
          }
          _updateTaskList();
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => CreateTasksScreen(
                        task: item,
                        updateTaskList: _updateTaskList,
                      )));
        }
      },
      child: Container(
        width: 70,
        decoration: BoxDecoration(
            color: item.status == 0 ? Colors.orangeAccent : Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(24))),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Center(
          child: Text(
            item.status == 0 ? 'Done' : 'Edit',
            style: TextStyle(
              color: Colors.blueGrey,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }

  Widget _deleteButton(CalendarItem item) {
    return GestureDetector(
      onTap: () {
        _showAlertDialog(item);
      },
      child: Container(
        width: 80,
        decoration: BoxDecoration(
            color: Colors.redAccent,
            borderRadius: BorderRadius.all(Radius.circular(24))),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Center(
          child: Text(
            'Delete',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showAlertDialog(CalendarItem itemToDelete) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Confirm Delete'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  Text('Are you sure you want to delete the selected task?'),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Provider.of<TaskData>(context, listen: false)
                      .deleteEvent(itemToDelete);
                  _updateTaskList();
                  Navigator.of(context).pop();
                },
                child: Text('Yes'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('No'),
              ),
            ],
          );
        });
  }

  FutureOr _onGoBack(dynamic value) {
    _updateTaskList();
  }

  @override
  void initState() {
    super.initState();
    _updateTaskList();
    _today = DateTime.now();
    getMyDataMax();
    getMyCompleteTasks();
    DB.init().then(
        (value) => Provider.of<TaskData>(context, listen: false).fetchEvents());
    getLastDay();
    getOverdueTasks();
  }

  getOverdueTasks() async {
    _results = await DB.query(CalendarItem.table);
  }

  _updateTaskList() {
    if (status == null) {
      setState(() {
        _taskList = DB.getTaskList(CalendarItem.table);
      });
    } else if (status == 3) {
      setState(() {
        List<String> overdueDates = [];
        _uncompletedTasks =
            _results.map((e) => CalendarItem.fromMap(e)).toList();
        _uncompletedTasks.forEach((element) {
          DateTime formattedElementDate = DateTime.parse(
              DateFormat('yyyy-MM-dd')
                  .format(DateTime.parse(element.date.toString())));
          if (formattedElementDate
                      .compareTo(_today.subtract(Duration(days: 1))) <
                  0 &&
              element.status == 0) {
            overdueDates.add(element.date.toString());
          }
        });
        _taskList = DB.getOverdueList(CalendarItem.table, overdueDates);
      });
    } else {
      setState(() {
        _taskList = DB.getStatusList(CalendarItem.table, status);
      });
    }
    setState(() {
      getMyCompleteTasks();
    });
  }

  Future<void> _showMaterialDialog(int num) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 20),
                      height: 250,
                      width: double.infinity,
                      child: Lottie.asset('images/cong_example.json',
                          animate: true,
                          frameRate: FrameRate.composition,
                          repeat: true,
                          reverse: true,
                          fit: BoxFit.contain),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: IconButton(
                          icon: Icon(
                            Icons.cancel_outlined,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20, left: 20, top: 24),
                  child: Text(
                    'Congratulations',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20, left: 20, top: 16),
                  child:
                      Text('You have completed $num tasks. New Badge Awarded.'),
                ),
                TextButton(
                  onPressed: () {
                    final RenderBox box = context.findRenderObject();
                    Share.share(
                            'I am using todo list Pro to organize my day, '
                            'its really a convenient to-do list. Download it here now: '
                            'https://play.google.com/store/apps/details?id=com.danieljumakowuoche.todo_list',
                            subject: 'ToDo List Pro',
                            sharePositionOrigin:
                                box.localToGlobal(Offset.zero) & box.size)
                        .then(onGoMyBack);
                    Navigator.of(context).pop();
                  },
                  child: Text('SHARE'),
                ),
              ],
            ),
          );
        });
  }

  getCalendarItemsByStatus(int status) {
    setState(() {
      _taskList = DB.getStatusList(CalendarItem.table, status);
    });
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

  FutureOr onGoMyBack(dynamic value) {
    _updateTaskList();
    getMyDataMax();
  }

  getMyDataMax() async {
    SharedPreferences prefsMax = await SharedPreferences.getInstance();
    setState(() {
      maxMyTasks = prefsMax.getInt('maximumTasks');
    });
  }

  int _lastDay;
  DateTime _endOfMonth;
  DateTime _threeDaysBeforeEnd;
  DateTime _midMonth;
  DateTime _midMonthPlusOne;

  getLastDay() {
    _lastDay = DateTime(_today.year, _today.month + 1, 0, 0, 0, 0).day;
    _endOfMonth = DateTime(_today.year, _today.month, _lastDay).toUtc();
    _midMonth = DateTime(_today.year, _today.month, 15).toUtc();
    _midMonthPlusOne = _midMonth.add(Duration(days: 1));
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskData>(context);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          //TODO new theme 1
          backgroundColor: provider.themeStyle == 'dark'
              ? Color(0xff343559)
              : provider.themeStyle == 'crypto'
                  ? Color(0xff55462F)
                  : provider.themeStyle == 'nft'
                      ? Color(0xff020000)
                      : provider.themeStyle == 'greenArea'
                          ? Color(0xff2D5B57)
                          : provider.themeStyle == 'swallow'
                              ? Color(0xff2F2D29)
                              : Color(0xffFFFFFF),
          title: Text(
            'My Tasks',
            //TODO new theme 2
            style: TextStyle(
                color: provider.themeStyle == 'crypto'
                    ? Color(0xffB2ABAB)
                    : provider.themeStyle == 'nft' ||
                            provider.themeStyle == 'greenArea'
                        ? Colors.white
                        : provider.themeStyle == 'swallow'
                            ? Color(0xffCBB27D)
                            : Color(0xff171720)),
          ),
        ),
        body: Container(
          width: double.infinity,
          // color: provider.themeStyle == 'dark'
          //     ? Color(0xff2B2B49)
          //     : Color(0xffF4F6FA),
          decoration: BoxDecoration(
            //TODO new theme 3
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
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
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
                              Color(0xff822C55),
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
          ),
          child: Row(
            children: [
              //container for Content
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(
                      top: 16, bottom: 16, left: 16, right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          _buildGestureDetectorTasks(null, 'All'),
                          _buildGestureDetectorTasks(0, 'Pending'),
                          _buildGestureDetectorTasks(1, 'Complete'),
                          _buildGestureDetectorTasks(3, 'Overdue'),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      //  List  of all Tasks
                      Expanded(
                        child: FutureBuilder(
                          future: _taskList,
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            return ListView.builder(
                              addAutomaticKeepAlives: true,
                              padding: EdgeInsets.symmetric(vertical: 15.0),
                              itemCount: 1 + snapshot.data.length,
                              itemBuilder: (BuildContext context, int index) {
                                if (index == 0) {
                                  var textInstance = status == 0
                                      ? 'In Progress'
                                      : status == 1
                                          ? 'Complete'
                                          : status == null
                                              ? ''
                                              : 'Overdue';
                                  return Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${snapshot.data.length} Tasks $textInstance',
                                          style: TextStyle(
                                              color: Color(0xff8384AE),
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600),
                                        )
                                      ],
                                    ),
                                  );
                                }
                                return _taskCell(snapshot.data[index - 1]);
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          //TODO new theme
          backgroundColor: provider.themeStyle == 'dark'
              ? Colors.redAccent
              : provider.themeStyle == 'nft'
                  ? Color(0xff3FF3FF)
                  : provider.themeStyle == 'greenArea'
                      ? Color(0xff3282F6)
                      : provider.themeStyle == 'swallow'
                          ? Color(0xffFFDE9C)
                          : Color(0xff86858A),
          onPressed: () async {
            var tasksMyLimit = maxMyTasks == null ? 10 : maxMyTasks;
            print(tasksMyLimit);
            var allTasks = await _taskList;
            if (provider.isPurchased || allTasks.length < tasksMyLimit) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CreateTasksScreen(
                            updateTaskList: _updateTaskList,
                            status: status = null,
                          )));
            } else {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return ActionDialog(
                      title: 'OOPs!',
                      dialogContent:
                          'You have reached the maximum number of tasks for the free '
                          'version. Share the app to unlock 5 tasks or Try '
                          'Premium for FREE and get unlimited tasks plus all features.',
                      firstIconData: MdiIcons.crown,
                      firstButtonText: 'Start Free 3-day Trial',
                      secondButtonText: 'Share',
                      firstButtonFunction: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => Purchases()));
                      },
                      secondButtonFunction: () async {
                        SharedPreferences prefsData =
                            await SharedPreferences.getInstance();
                        var limitOfTasks = tasksMyLimit + 5;
                        prefsData.setInt('maximumTasks', limitOfTasks);
                        final RenderBox box = context.findRenderObject();
                        Share.share(
                                'I am using todo list Pro to organize my day, '
                                'its really a convenient to-do list. Download it here now: '
                                'https://play.google.com/store/apps/details?id=com.danieljumakowuoche.todo_list',
                                subject: 'ToDo List Pro',
                                sharePositionOrigin:
                                    box.localToGlobal(Offset.zero) & box.size)
                            .then(onGoMyBack);
                        Navigator.of(context).pop();
                      },
                    );
                  });
            }
          },
          child: Icon(
            Icons.add,
            color:
                provider.themeStyle == 'swallow' ? Colors.black : Colors.white,
          ),
        ),
        bottomNavigationBar: !provider.isPurchased
            ? Container(
                height: 55,
                child: AdWidget(
                  key: UniqueKey(),
                  ad: AdMobService.taskCreateBannerAd()..load(),
                ),
              )
            : Container(
                height: 5,
                color: Color(0xff2E343B),
              ),
      ),
    );
  }

  GestureDetector _buildGestureDetectorTasks(int nume, String posti) {
    var prodiver = Provider.of<TaskData>(context, listen: false);
    return GestureDetector(
      onTap: () {
        setState(() {
          status = nume;
        });
        _updateTaskList();
      },
      child: Container(
        width: 80,
        decoration: BoxDecoration(
          // border: Border.all(
          //   color: Colors.orangeAccent,
          //   // style: status == nume ? BorderStyle.none : BorderStyle.solid
          // ),
          borderRadius: BorderRadius.all(Radius.circular(16)),
          //TODO new theme 5
          color: status == nume
              ? prodiver.themeStyle == 'dark'
                  ? Color(0xff6098FE)
                  : prodiver.themeStyle == 'crypto'
                      ? Color(0xffEEC027)
                      : prodiver.themeStyle == 'nft'
                          ? Color(0xffB2356B)
                          : prodiver.themeStyle == 'greenArea'
                              ? Color(0xff2E85BA)
                              : prodiver.themeStyle == 'swallow'
                                  ? Color(0xffF7EAC3)
                                  : Color(0xffE7B588)
              : prodiver.themeStyle == 'dark' ||
                      prodiver.themeStyle == 'greenArea'
                  ? Color(0xff4F4F83)
                  : prodiver.themeStyle == 'crypto'
                      ? Color(0xff425246)
                      : prodiver.themeStyle == 'nft'
                          ? Color(0xff2B91BF)
                          : prodiver.themeStyle == 'swallow'
                              ? Color(0xff9C937A)
                              : Color(0xffE8EAF0),
        ),
        padding: const EdgeInsets.all(8),
        child: Center(
          child: Column(
            children: [
              Icon(
                nume == null
                    ? Icons.view_list_outlined
                    : nume == 0
                        ? Icons.schedule
                        : nume == 1
                            ? Icons.done
                            : Icons.assignment_late_outlined,
                size: 18,
                //TODO new theme 7
                color: status == nume
                    ? prodiver.themeStyle == 'crypto'
                        ? Color(0xff425246)
                        : prodiver.themeStyle == 'swallow'
                            ? Color(0xff5E5540)
                            : Colors.white
                    : prodiver.themeStyle == 'crypto'
                        ? Colors.white
                        : prodiver.themeStyle == 'nft'
                            ? Colors.white
                            : prodiver.themeStyle == 'swallow'
                                ? Color(0xffD1BD8D)
                                : Color(0xff8384AE),
              ),
              Text(
                posti,
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 12,
                  //TODO new theme 6
                  color: status == nume
                      ? prodiver.themeStyle == 'crypto'
                          ? Color(0xff425246)
                          : prodiver.themeStyle == 'swallow'
                              ? Color(0xff5E5540)
                              : Colors.white
                      : prodiver.themeStyle == 'crypto' ||
                              prodiver.themeStyle == 'nft'
                          ? Colors.white
                          : prodiver.themeStyle == 'swallow'
                              ? Color(0xffD1BD8D)
                              : Color(0xff8384AE),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
