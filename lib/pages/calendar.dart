import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lottie/lottie.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list/calendar_model.dart';
import 'package:todo_list/screens/add_tasksScreen.dart';
import 'package:todo_list/screens/purchases.dart';
import 'package:todo_list/task_data.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todo_list/widgets/action_dialog.dart';

import '../db.dart';
import '../screens/view_task.dart';

class Calendar extends StatefulWidget {
  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  DateTime _selectedDay;
  int maxCalTasks;
  DateTime _today;
  DateTime today = DateTime.now();
  CalendarController ctrlr = CalendarController();
  List<Widget> get _eventWidgets =>
      Provider.of<TaskData>(context, listen: false)
          .selectedEvents
          .map((e) => taskWidget(Color(0xfff96060), e, e, e))
          .toList();

  void _onDaySelected(DateTime day, List events, List holidays) {
    setState(() {
      _selectedDay = day;
      Provider.of<TaskData>(context, listen: false).selectedEvents = events;
    });
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

  List<CalendarItem> _completeCalTaskList = [];
  getCompleteCalTasks() async {
    var tasks = await DB.getStatusList(CalendarItem.table, 1);
    setState(() {
      _completeCalTaskList = tasks;
    });
  }

  List<int> badgeCalNumbers = [
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

  List<CalendarItem> _taskList = [];
  getCalTasks() async {
    var tasks = await DB.getTaskList(CalendarItem.table);
    setState(() {
      _taskList = tasks;
    });
  }

  @override
  void initState() {
    super.initState();
    ctrlr = CalendarController();
    _selectedDay = DateTime.now();
    DB.init().then(
        (value) => Provider.of<TaskData>(context, listen: false).fetchEvents());
    _updateTaskList();
    getCalTasks();
    today = DateTime.now();
    getDataCalMax();
    getCompleteCalTasks();
    Provider.of<TaskData>(context, listen: false).initialize();
  }

  FutureOr onGoCalBack(dynamic value) {
    _updateTaskList();
  }

  getDataCalMax() async {
    SharedPreferences prefsMax = await SharedPreferences.getInstance();
    setState(() {
      maxCalTasks = prefsMax.getInt('maximumTasks');
    });
  }

  _updateTaskList() {
    setState(() {
      _eventWidgets;
      getCalTasks();
      getDataCalMax();
      getCompleteCalTasks();
    });
  }

  @override
  void dispose() {
    ctrlr.dispose();
    super.dispose();
  }

  FutureOr _onGoBack(dynamic value) {
    _updateTaskList();
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
                        .then(onGoCalBack);
                    Navigator.of(context).pop();
                  },
                  child: Text('SHARE'),
                ),
              ],
            ),
          );
        });
  }

  Widget eventTitle() {
    if (Provider.of<TaskData>(context).selectedEvents.length == 0) {
      return Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'No Tasks',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tasks',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
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
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: Container(
          // color: provider.themeStyle == 'dark'
          //     ? Color(0xffCCE8FF)
          //     : Color(0xffF2F5FA),
          decoration: BoxDecoration(
            //TODO new theme 1
            gradient: provider.themeStyle == 'dark'
                ? LinearGradient(
                    colors: [
                      Color(0xffCCE8FF),
                      Color(0xffCCE8FF),
                      Color(0xffCCE8FF),
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
          child: Stack(
            children: [
              Consumer<TaskData>(
                builder: (context, todo, child) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppBar(
                        //TODO new theme 9
                        backgroundColor: provider.themeStyle == 'dark'
                            ? Color(0xff182341)
                            : provider.themeStyle == 'greenArea'
                                ? Color(0xff2D5B57)
                                : provider.themeStyle == 'swallow'
                                    ? Color(0xff2F2D29)
                                    : Color(0xff191919),
                        elevation: 0,
                        title: Text(
                          'Calendar',
                          style: TextStyle(
                              fontSize: 30,
                              //TODO new theme 10
                              color: provider.themeStyle == 'swallow'
                                  ? Color(0xffCBB27D)
                                  : Colors.white),
                        ),
                      ),
                      TableCalendar(
                        calendarStyle: CalendarStyle(
                          canEventMarkersOverflow: true,
                          markersColor: provider.themeStyle == 'dark'
                              ? Colors.blue
                              : Color(0xffCCA95C),
                          selectedColor: provider.themeStyle == 'dark'
                              ? Color(0xff557BFF)
                              : Color(0xff86858C),
                          weekdayStyle: TextStyle(
                              //TODO new theme 2
                              color: provider.themeStyle == 'crypto' ||
                                      provider.themeStyle == 'nft' ||
                                      provider.themeStyle == 'greenArea'
                                  ? Colors.white
                                  : provider.themeStyle == 'swallow'
                                      ? Color(0xffCBB27D)
                                      : Colors.black),
                          eventDayStyle: TextStyle(
                            //TODO new theme 3
                            color: provider.themeStyle == 'crypto'
                                ? Colors.white
                                : provider.themeStyle == 'greenArea'
                                    ? Colors.lightBlue
                                    : Colors.black,
                          ),
                        ),
                        daysOfWeekStyle: DaysOfWeekStyle(
                            weekdayStyle: TextStyle(
                                color: provider.themeStyle == 'nft'
                                    ? Colors.white
                                    : Colors.blueGrey)),
                        headerStyle: HeaderStyle(
                          formatButtonShowsNext: false,
                          titleTextStyle: TextStyle(
                            //TODO new theme 4
                            color: provider.themeStyle == 'crypto' ||
                                    provider.themeStyle == 'nft'
                                ? Colors.white
                                : provider.themeStyle == 'greenArea'
                                    ? Color(0xff64BEB6)
                                    : provider.themeStyle == 'swallow'
                                        ? Color(0xffCBB27D)
                                        : Colors.black,
                          ),
                          formatButtonDecoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                              border: Border.all(
                                //TODO new theme 9
                                color: provider.themeStyle == 'crypto' ||
                                        provider.themeStyle == 'nft'
                                    ? Colors.white
                                    : provider.themeStyle == 'greenArea'
                                        ? Color(0xff64BEB6)
                                        : provider.themeStyle == 'swallow'
                                            ? Color(0xffCBB27D)
                                            : Colors.black,
                              )),
                          formatButtonTextStyle: TextStyle(
                            //TODO new theme 8
                            color: provider.themeStyle == 'crypto' ||
                                    provider.themeStyle == 'nft'
                                ? Colors.white
                                : provider.themeStyle == 'greenArea'
                                    ? Color(0xff64BEB6)
                                    : provider.themeStyle == 'swallow'
                                        ? Color(0xffCBB27D)
                                        : Colors.black,
                          ),
                          leftChevronIcon: Icon(
                            Icons.chevron_left,
                            //TODO new theme 5
                            color: provider.themeStyle == 'crypto' ||
                                    provider.themeStyle == 'nft'
                                ? Colors.white
                                : provider.themeStyle == 'greenArea'
                                    ? Color(0xff64BEB6)
                                    : provider.themeStyle == 'swallow'
                                        ? Color(0xffCBB27D)
                                        : Colors.black,
                          ),
                          rightChevronIcon: Icon(
                            Icons.chevron_right,
                            //TODO new theme 6
                            color: provider.themeStyle == 'crypto' ||
                                    provider.themeStyle == 'nft'
                                ? Colors.white
                                : provider.themeStyle == 'greenArea'
                                    ? Color(0xff64BEB6)
                                    : provider.themeStyle == 'swallow'
                                        ? Color(0xffCBB27D)
                                        : Colors.black,
                          ),
                        ),
                        calendarController: ctrlr,
                        startingDayOfWeek: StartingDayOfWeek.sunday,
                        initialCalendarFormat: CalendarFormat.month,
                        events: todo.events,
                        onDaySelected: _onDaySelected,
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 10),
                              eventTitle(),
                              Column(
                                children: _eventWidgets,
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: provider.themeStyle == 'dark'
              ? Colors.redAccent
              : provider.themeStyle == 'greenArea'
                  ? Color(0xff3282F6)
                  : provider.themeStyle == 'swallow'
                      ? Color(0xffCBB27D)
                      : Color(0xffE7B588),
          onPressed: () {
            var tasksCalLimit = maxCalTasks == null ? 10 : maxCalTasks;
            if (provider.isPurchased || _taskList.length < tasksCalLimit) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CreateTasksScreen(
                            updateTaskList: _updateTaskList,
                            selectedDaay: _selectedDay,
                          )));
            } else {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return ActionDialog(
                      title: 'OOPs!',
                      dialogContent:
                          'You have reached the maximum number of tasks for the free '
                          'version. Share the app to unlock 5 '
                          'tasks or Try Premium for FREE and get unlimited tasks plus all '
                          'features.',
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
                        var limitOfTasks = tasksCalLimit + 5;
                        prefsData.setInt('maximumTasks', limitOfTasks);
                        final RenderBox box = context.findRenderObject();
                        Share.share(
                                'I am using todo list Pro to organize my day, '
                                'its really a convenient to-do list. Download it here now: '
                                'https://play.google.com/store/apps/details?id=com.danieljumakowuoche.todo_list',
                                subject: 'ToDo List Pro',
                                sharePositionOrigin:
                                    box.localToGlobal(Offset.zero) & box.size)
                            .then(onGoCalBack);
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
      ),
    );
  }

  Slidable taskWidget(Color color, CalendarItem title, CalendarItem time,
      CalendarItem progress) {
    final provider = Provider.of<TaskData>(context, listen: false);
    List<int> currentCalNumberComplete = badgeCalNumbers
        .where((element) => element - _completeCalTaskList.length == 0)
        .toList();
    final dt = DateTime(
        DateTime.parse(
                DateFormat('yyyy-MM-dd').format(DateTime.parse(time.date)))
            .year,
        DateTime.parse(
                DateFormat('yyyy-MM-dd').format(DateTime.parse(time.date)))
            .month,
        DateTime.parse(
                DateFormat('yyyy-MM-dd').format(DateTime.parse(time.date)))
            .day,
        TimeOfDay.fromDateTime(DateFormat.jm().parse(time.time)).hour,
        TimeOfDay.fromDateTime(DateFormat.jm().parse(time.time)).minute);
    final format = DateFormat.jm();
    return Slidable(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => ViewTask(
                        taskSelected: title,
                      ))).then(_onGoBack);
        },
        child: Container(
          height: 80,
          margin: EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            gradient: title.status == 1
                ? provider.themeStyle == 'dark'
                    ? LinearGradient(
                        colors: [
                          Color(0xff64C939),
                          Color(0xff84CB44),
                          Color(0xffBBD156)
                        ],
                      )
                    : provider.themeStyle == 'crypto' ||
                            provider.themeStyle == 'nft'
                        ? LinearGradient(
                            colors: [
                              Color(0xff64C939).withOpacity(0.5),
                              Color(0xff84CB44).withOpacity(0.3),
                              Color(0xffBBD156).withOpacity(0.2)
                            ],
                          )
                        : LinearGradient(
                            colors: [
                              Color(0xff82A4A4),
                              Color(0xff82A4A4),
                              Color(0xff82A4A4),
                            ],
                          )
                : provider.themeStyle == 'dark'
                    ? LinearGradient(
                        colors: [
                          Color(0xffE55049),
                          Color(0xffEE684D),
                          Color(0xffF78353)
                        ],
                      )
                    : provider.themeStyle == 'crypto' ||
                            provider.themeStyle == 'nft'
                        ? LinearGradient(
                            colors: [
                              Color(0xffF94018).withOpacity(0.7),
                              Color(0xffF94018).withOpacity(0.5),
                              Color(0xffF94018).withOpacity(0.4)
                            ],
                          )
                        : LinearGradient(
                            colors: [
                              Color(0xffE6ABAA),
                              Color(0xffE6ABAA),
                              Color(0xffE6ABAA),
                            ],
                          ),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                offset: Offset(0, 9),
                blurRadius: 20,
              )
            ],
          ),
          child: Row(
            children: [
              title.status == 0
                  ? Icon(
                      Icons.history_toggle_off,
                      color: Colors.white,
                      size: 35,
                    )
                  : IconButton(
                      icon: Icon(Icons.check_circle_outlined),
                      color: Colors.white,
                      onPressed: () {
                        Provider.of<TaskData>(context, listen: false)
                            .markPending(title);
                        _updateTaskList();
                      },
                      iconSize: 35,
                    ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      format.format(dt),
                      style: TextStyle(fontSize: 18, color: Colors.white70),
                    ),
                    Text(
                      progress.status == 0 ? 'Pending' : 'Complete',
                      style: TextStyle(fontSize: 18, color: Colors.white70),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Container(),
              ),
              Container(
                height: 50,
                width: 5,
                color: color,
              )
            ],
          ),
        ),
      ),
      secondaryActions: [
        title.status == 0
            ? IconSlideAction(
                caption: 'Done',
                color: Colors.orangeAccent,
                icon: Icons.check_box_outlined,
                onTap: () {
                  Provider.of<TaskData>(context, listen: false)
                      .markComplete(title);
                  if (currentCalNumberComplete.isNotEmpty) {
                    var numComplete = currentCalNumberComplete[0] + 1;
                    _showMaterialDialog(numComplete);
                  }
                  _updateTaskList();
                },
              )
            : IconSlideAction(
                caption: 'Edit',
                color: Colors.white,
                icon: Icons.edit,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => CreateTasksScreen(
                                task: title,
                                updateTaskList: _updateTaskList,
                              )));
                },
              ),
        IconSlideAction(
          caption: 'Delete',
          color: color,
          icon: Icons.delete,
          onTap: () {
            _showAlertDialog(title);
          },
        ),
      ],
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.3,
    );
  }
}
