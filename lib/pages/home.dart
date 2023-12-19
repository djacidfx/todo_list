import 'dart:async';
import 'dart:io';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:badges/badges.dart';
import 'package:date_count_down/date_count_down.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list/constants.dart';
import 'package:todo_list/screens/add_tasksScreen.dart';
import 'package:todo_list/screens/purchases.dart';
import 'package:todo_list/screens/view_task.dart';
import 'package:todo_list/widgets/action_dialog.dart';
import 'package:todo_list/widgets/counter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/widgets/information_dialog.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import '../calendar_model.dart';
import '../db.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../task_data.dart';

class MyCards extends StatefulWidget {
  @override
  _MyCardsState createState() => _MyCardsState();
}

class _MyCardsState extends State<MyCards> {
  String _formattedDate =
      DateTime.parse(DateFormat('yyyy-MM-dd').format(DateTime.now()))
          .toString();

  int maxTasks;
  DateTime _today;

  List<CalendarItem> _todayList = [];
  getTodosForToday() async {
    var todos = await DB.getTodayList(CalendarItem.table, _formattedDate);
    setState(() {
      _todayList = todos;
    });
  }

  List<CalendarItem> _taskList = [];
  getTasks() async {
    var tasks = await DB.getTaskList(CalendarItem.table);
    setState(() {
      _taskList = tasks;
    });
    if (_taskList.length == 0) {
      Future.delayed(Duration.zero, showTutorial);
    }
  }

  List<CalendarItem> _completeTaskList = [];
  getCompleteTasks() async {
    var tasks = await DB.getStatusList(CalendarItem.table, 1);
    setState(() {
      _completeTaskList = tasks;
    });
  }

  List<CalendarItem> _ongoingTaskList = [];
  getOngoingTasks() async {
    var tasks = await DB.getStatusList(CalendarItem.table, 0);
    setState(() {
      _ongoingTaskList = tasks;
    });
  }

  _updateTaskList() {
    setState(() {
      getTodosForToday();
      getTasks();
      getCompleteTasks();
      getOngoingTasks();
      getDataMax();
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
                //TODO Create tenary operators for icon, name, test upto 40 complete tasks
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
                        .then(onGoBack);
                    Navigator.of(context).pop();
                  },
                  child: Text('SHARE'),
                ),
              ],
            ),
          );
        });
  }

  List<int> badgeNumbers = [4, 14, 24, 39, 54, 69, 89, 109, 129, 149, 169, 199];

  FutureOr onGoBack(dynamic value) {
    _updateTaskList();
    getDataMax();
  }

  TutorialCoachMark tutorialCoachMark;
  List<TargetFocus> targets = <TargetFocus>[];

  GlobalKey keyButton = GlobalKey();

  @override
  void initState() {
    super.initState();
    getTodosForToday();
    getTasks();
    getCompleteTasks();
    getOngoingTasks();
    _today = DateTime.now();
    getLastDay();
    salesCopyDialog();
    tipOfTheDayDialog();
    DB.init().then(
        (value) => Provider.of<TaskData>(context, listen: false).fetchEvents());
    getDataMax();
  }

  getDataMax() async {
    SharedPreferences prefsMax = await SharedPreferences.getInstance();
    setState(() {
      maxTasks = prefsMax.getInt('maximumTasks');
    });
  }

  List<int> couponNumber = [
    98,
    89,
    82,
    66,
    55,
    49,
    46,
    43,
    37,
    32,
    26,
    20,
    17,
    15,
    14,
    13,
    12,
    11,
    8,
    5,
    3,
    0
  ];
  List<int> voucherNumber = [
    686,
    623,
    574,
    462,
    385,
    343,
    322,
    301,
    257,
    224,
    182,
    140,
    119,
    105,
    98,
    91,
    84,
    77,
    56,
    35,
    21,
    3
  ];
  int _lastDay;
  DateTime _endOfMonth;
  DateTime _threeDaysBeforeEnd;
  DateTime _midMonth;
  DateTime _midMonthPlusOne;
  DateTime _midMonthOne;
  DateTime _midMonthTwo;
  DateTime _midMonthThree;
  DateTime _midMonthFour;
  DateTime _midMonthFive;
  DateTime _midMonthSix;
  DateTime _midMonthSeven;
  DateTime _midMonthEight;
  DateTime _midMonthNine;
  DateTime _midMonthTen;
  DateTime _midMonthEleven;
  DateTime _midMonthTwelve;
  DateTime _midMonthThirteen;
  DateTime _midMonthFourteen;
  DateTime _midMonthFifteen;
  DateTime _midMonthSixteen;
  DateTime _midMonthSeventeen;
  DateTime _midMonthEighteen;
  DateTime _midMonthNineteen;
  DateTime _midMonthTwenty;
  DateTime _midMonthTwentyOne;
  DateTime _midMonthTwentyTwo;
  DateTime endMonthOne;
  DateTime endMonthTwo;
  DateTime endMonthThree;
  DateTime endMonthFour;
  DateTime endMonthFive;
  DateTime endMonthSix;
  DateTime endMonthSeven;
  DateTime endMonthEight;
  DateTime endMonthNine;
  DateTime endMonthTen;
  DateTime endMonthEleven;
  DateTime endMonthTwelve;
  DateTime endMonthThirteen;
  DateTime endMonthFourteen;
  DateTime endMonthFifteen;
  DateTime endMonthSixteen;
  DateTime endMonthSevenTeen;
  DateTime endMonthEighteen;
  DateTime endMonthNineTeen;
  DateTime endMonthTwenty;
  DateTime endMonthTwentyOne;

  getLastDay() {
    _lastDay = DateTime(_today.year, _today.month + 1, 0, 0, 0, 0).day;
    _endOfMonth = DateTime(_today.year, _today.month, _lastDay).toUtc();
    _midMonth = DateTime(_today.year, _today.month, 15).toUtc();
    _midMonthPlusOne = _midMonth.add(Duration(days: 1));
    _midMonthOne = _midMonth.add(Duration(hours: 1));
    _midMonthTwo = _midMonth.add(Duration(hours: 2));
    _midMonthThree = _midMonth.add(Duration(hours: 3));
    _midMonthFour = _midMonth.add(Duration(hours: 4));
    _midMonthFive = _midMonth.add(Duration(hours: 5));
    _midMonthSix = _midMonth.add(Duration(hours: 6));
    _midMonthSeven = _midMonth.add(Duration(hours: 7));
    _midMonthEight = _midMonth.add(Duration(hours: 8));
    _midMonthNine = _midMonth.add(Duration(hours: 9));
    _midMonthTen = _midMonth.add(Duration(hours: 10));
    _midMonthEleven = _midMonth.add(Duration(hours: 11));
    _midMonthTwelve = _midMonth.add(Duration(hours: 12));
    _midMonthThirteen = _midMonth.add(Duration(hours: 13));
    _midMonthFourteen = _midMonth.add(Duration(hours: 14));
    _midMonthFifteen = _midMonth.add(Duration(hours: 15));
    _midMonthSixteen = _midMonth.add(Duration(hours: 16));
    _midMonthSeventeen = _midMonth.add(Duration(hours: 17));
    _midMonthEighteen = _midMonth.add(Duration(hours: 18));
    _midMonthNineteen = _midMonth.add(Duration(hours: 19));
    _midMonthTwenty = _midMonth.add(Duration(hours: 20));
    _midMonthTwentyOne = _midMonth.add(Duration(hours: 21));
    _midMonthTwentyTwo = _midMonth.add(Duration(hours: 22));
  }

  salesCopyDialog() async {
    SharedPreferences prefsCopy = await SharedPreferences.getInstance();
    final int lastAccess = prefsCopy.getInt('lastAccess');
    final provider = Provider.of<TaskData>(context, listen: false);
    if (lastAccess != null) {
      // Get last access as DateTime
      final DateTime lastAccessTime =
          DateTime.fromMillisecondsSinceEpoch(lastAccess);

      // Check if he opened the app
      final opened = lastAccessTime.isAfter(_today);
      if (!opened) {
        if (!provider.isPurchased) {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                //TODO days back to 3
                _threeDaysBeforeEnd = _endOfMonth.subtract(Duration(days: 1));
                bool _todayGreaterThan =
                    _threeDaysBeforeEnd.compareTo(_today) <= 0;
                bool _todayLessThan = _endOfMonth.compareTo(_today) >= 0;
                return Dialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  child: Stack(
                    children: [
                      Container(
                        padding: EdgeInsets.only(
                            left: 15, top: 20, right: 15, bottom: 20),
                        margin: EdgeInsets.only(top: 45),
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Color(0xff323E51),
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
                              'Are you making progress in life? Do you feel like you are achieving nothing at all? Thats not true. This app sees it all',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xffFE8F00)),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    Column(
                                      children: [
                                        Icon(
                                          Icons.star,
                                          color: Colors.amberAccent,
                                        ),
                                        Text(
                                          'Your Achievements',
                                          style: TextStyle(color: Colors.white),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Column(
                                      children: [
                                        Icon(
                                          Icons.work_history,
                                          color: Colors.orange,
                                        ),
                                        Text(
                                          'Your Optimal Times',
                                          style: TextStyle(color: Colors.white),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Badge(
                                      badgeContent: Text(
                                        'BONUS',
                                        style: TextStyle(
                                          fontSize: 7,
                                          color: Colors.white,
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          Icon(
                                            Icons.palette_outlined,
                                            color: Colors.blueAccent,
                                          ),
                                          Text(
                                            'Smart themes',
                                            style:
                                                TextStyle(color: Colors.white),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Column(
                                      children: [
                                        Icon(
                                          Icons.insights,
                                          color: Colors.pinkAccent,
                                        ),
                                        Text(
                                          'Your Task highlights',
                                          style: TextStyle(color: Colors.white),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Column(
                                      children: [
                                        Icon(
                                          Icons.calendar_view_month_outlined,
                                          color: Colors.purpleAccent,
                                        ),
                                        Text(
                                          'Your Week at a glance',
                                          style: TextStyle(color: Colors.white),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Badge(
                                      badgeContent: Text(
                                        'BONUS',
                                        style: TextStyle(
                                          fontSize: 7,
                                          color: Colors.white,
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          Icon(
                                            Icons.block,
                                            color: Colors.yellowAccent,
                                          ),
                                          Text(
                                            'No Ads',
                                            style:
                                                TextStyle(color: Colors.white),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Column(
                              children: [
                                Text(
                                  'Join 12,345+ high achievers like you using this tools to track performance.',
                                  style: TextStyle(color: Colors.white),
                                ),
                                Text(
                                  '89% of premium subscribers had more control of their day after using our tools.',
                                  style: TextStyle(color: Colors.white),
                                ),
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
                                        MaterialPageRoute(
                                            builder: (_) => Purchases()));
                                  },
                                  child: Text(
                                    'More Info',
                                    style: TextStyle(
                                        fontSize: 11, color: Colors.white),
                                  ),
                                  style: TextButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding: EdgeInsets.all(16),
                                    backgroundColor: Color(0xff5D51FF),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    'Remind Me Later',
                                    style: TextStyle(
                                        fontSize: 11, color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              });
        }
        //TODO change back to days: 3
        var threeDaysAhead = _today.add(Duration(days: 3));
        prefsCopy.setInt('lastAccess', threeDaysAhead.millisecondsSinceEpoch);
      }
    } else {
      //TODO change back to days: 1
      var daysThreeAhead = _today.add(Duration(days: 1));
      prefsCopy.setInt('lastAccess', daysThreeAhead.millisecondsSinceEpoch);
    }
  }

  tipOfTheDayDialog() async {
    SharedPreferences prefsTip = await SharedPreferences.getInstance();
    final int lastDayTip = prefsTip.getInt('tipOfTheDay');
    if (lastDayTip != null) {
      // Get last access as DateTime
      final DateTime lastTipAccessTime =
          DateTime.fromMillisecondsSinceEpoch(lastDayTip);
      // Check if he opened the app
      final opened = lastTipAccessTime.isAfter(_today);
      if (!opened) {
        String dayOfTheWeek = DateFormat('EEEE').format(_today);
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return InformationDialog(
                title: 'Tip of the Day',
                dialogContent: dayOfTheWeek == 'Monday'
                    ? 'Don\'t tackle the easy stuff first. Researchers have '
                        'found that willpower is a finite resource that steadily '
                        'decreases throughout the day. So your brain is much '
                        'better at handling the hardest tasks at the beginning '
                        'of the day when you\'re more focussed.'
                    : dayOfTheWeek == 'Tuesday'
                        ? 'Minimize Multitasking. Multitasking can seem '
                            'inevitable in our modern, ever-connected lifestyles. '
                            'But Research shows it can make us 40% less '
                            'productive and cause us to make 50% more mistakes. '
                            'Removing Notifications from your work computer and '
                            'putting away your cell phone are two great ways to '
                            'start.'
                        : dayOfTheWeek == 'Sunday'
                            ? 'Set weekly goals of tasks you must accomplish. '
                                'Having a clear plan for the week ensures there '
                                'is less room for procrastination.'
                            : dayOfTheWeek == 'Wednesday'
                                ? 'Schedule Everything. Have you ever caught '
                                    'yourself mindlessly clicking back and forth '
                                    'between open tabs in your browser, to an '
                                    'email, to your project management window '
                                    'and back again? Well, maybe it’s just us, '
                                    'but if we’re not working off of a carefully '
                                    'crafted to-do list, there are far too many '
                                    'distractions that will flood our mind and '
                                    'interrupt our work-flow, instead of '
                                    'allowing us to check off one item after '
                                    'the next.'
                                : dayOfTheWeek == 'Thursday'
                                    ? 'Plan your day using the Rule of 3. At the '
                                        'start of the day, before you start '
                                        'working, simply step back from your '
                                        'work and ask yourself: by the time the '
                                        'day is done, what three main tasks will '
                                        'I want to have accomplished? Figuring out '
                                        'what’s most important keeps you from '
                                        'losing hours as you blindly respond to '
                                        'whatever comes in.'
                                    : dayOfTheWeek == 'Friday'
                                        ? 'Get Some Sleep. Sleep is a crucial '
                                            'component of success, and this is '
                                            'one of our top productivity tips '
                                            'for physical health. Avoid working '
                                            'long hours and sacrificing sleep to '
                                            'complete all pending tasks. The '
                                            'next time you are tempted to stay '
                                            'up late and work with a frazzled '
                                            'brain, get some sleep and revisit '
                                            'the task in the morning instead. '
                                            'Taking the time to sleep may '
                                            'actually help your brain recharge, '
                                            'boost cognitive performance, and '
                                            'ultimately improve your '
                                            'effectiveness at work. '
                                        : 'Take Breaks. There’s a limit to how '
                                            'long anybody can devote deep focus '
                                            'to a task. No matter how busy you '
                                            'are, after a certain amount of time'
                                            ', the law of diminishing returns '
                                            'kicks in, and fatigue—physical and/'
                                            'or mental—starts to impair your '
                                            'effectiveness. Schedule breaks '
                                            'periodically even during the '
                                            'busiest days. You’ll return to your '
                                            'work refreshed, both mentally and '
                                            'physically, and ready to be even '
                                            'more productive.',
              );
            });

        var oneDaysAhead = _today.add(Duration(days: 1));
        prefsTip.setInt('tipOfTheDay', oneDaysAhead.millisecondsSinceEpoch);
      }
    } else {
      var hoursSixAhead = _today.add(Duration(hours: 6));
      prefsTip.setInt('tipOfTheDay', hoursSixAhead.millisecondsSinceEpoch);
    }
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
    _threeDaysBeforeEnd = _endOfMonth.subtract(Duration(days: 3));
    endMonthOne = _endOfMonth.subtract(Duration(hours: 23));
    endMonthTwo = _endOfMonth.subtract(Duration(hours: 22));
    endMonthThree = _endOfMonth.subtract(Duration(hours: 21));
    endMonthFour = _endOfMonth.subtract(Duration(hours: 20));
    endMonthFive = _endOfMonth.subtract(Duration(hours: 19));
    endMonthSix = _endOfMonth.subtract(Duration(hours: 18));
    endMonthSeven = _endOfMonth.subtract(Duration(hours: 17));
    endMonthEight = _endOfMonth.subtract(Duration(hours: 16));
    endMonthNine = _endOfMonth.subtract(Duration(hours: 15));
    endMonthTen = _endOfMonth.subtract(Duration(hours: 14));
    endMonthEleven = _endOfMonth.subtract(Duration(hours: 13));
    endMonthTwelve = _endOfMonth.subtract(Duration(hours: 12));
    endMonthThirteen = _endOfMonth.subtract(Duration(hours: 11));
    endMonthFourteen = _endOfMonth.subtract(Duration(hours: 10));
    endMonthFifteen = _endOfMonth.subtract(Duration(hours: 9));
    endMonthSixteen = _endOfMonth.subtract(Duration(hours: 8));
    endMonthSevenTeen = _endOfMonth.subtract(Duration(hours: 7));
    endMonthEighteen = _endOfMonth.subtract(Duration(hours: 6));
    endMonthNineTeen = _endOfMonth.subtract(Duration(hours: 5));
    endMonthTwenty = _endOfMonth.subtract(Duration(hours: 4));
    endMonthTwentyOne = _endOfMonth.subtract(Duration(hours: 3));
    bool nowGreaterThanEndOne = endMonthOne.compareTo(_today) >= 0;
    bool nowGreaterThanEndTwo = endMonthTwo.compareTo(_today) >= 0;
    bool nowGreaterThanEndThree = endMonthThree.compareTo(_today) >= 0;
    bool nowGreaterThanEndFour = endMonthFour.compareTo(_today) >= 0;
    bool nowGreaterThanEndFive = endMonthFive.compareTo(_today) >= 0;
    bool nowGreaterThanEndSix = endMonthSix.compareTo(_today) >= 0;
    bool nowGreaterThanEndSeven = endMonthSeven.compareTo(_today) >= 0;
    bool nowGreaterThanEndEight = endMonthEight.compareTo(_today) >= 0;
    bool nowGreaterThanEndNine = endMonthNine.compareTo(_today) >= 0;
    bool nowGreaterThanEndTen = endMonthTen.compareTo(_today) >= 0;
    bool nowGreaterThanEndEleven = endMonthEleven.compareTo(_today) >= 0;
    bool nowGreaterThanEndTwelve = endMonthTwelve.compareTo(_today) >= 0;
    bool nowGreaterThanEndThirteen = endMonthThirteen.compareTo(_today) >= 0;
    bool nowGreaterThanEndFourteen = endMonthFourteen.compareTo(_today) >= 0;
    bool nowGreaterThanEndFifteen = endMonthFifteen.compareTo(_today) >= 0;
    bool nowGreaterThanEndSixteen = endMonthSixteen.compareTo(_today) >= 0;
    bool nowGreaterThanEndSeventeen = endMonthSevenTeen.compareTo(_today) >= 0;
    bool nowGreaterThanEndEighteen = endMonthEighteen.compareTo(_today) >= 0;
    bool nowGreaterThanEndNineteen = endMonthNineTeen.compareTo(_today) >= 0;
    bool nowGreaterThanEndTwenty = endMonthTwenty.compareTo(_today) >= 0;
    bool nowGreaterThanEndTwentyOne = endMonthTwentyOne.compareTo(_today) >= 0;
    bool _todayGreaterThan = _threeDaysBeforeEnd.compareTo(_today) <= 0;
    bool _todayLessThan = _endOfMonth.compareTo(_today) >= 0;
    bool _todayGreaterThanMid = _midMonth.compareTo(_today) <= 0;
    bool _todayLessThanMid = _midMonthPlusOne.compareTo(_today) >= 0;
    bool _nowGreaterThanMidOne = _midMonthOne.compareTo(_today) >= 0;
    bool _nowGreaterThanMidTwo = _midMonthTwo.compareTo(_today) >= 0;
    bool _nowGreaterThanMidThree = _midMonthThree.compareTo(_today) >= 0;
    bool _nowGreaterThanMidFour = _midMonthFour.compareTo(_today) >= 0;
    bool _nowGreaterThanMidFive = _midMonthFive.compareTo(_today) >= 0;
    bool _nowGreaterThanMidSix = _midMonthSix.compareTo(_today) >= 0;
    bool _nowGreaterThanMidSeven = _midMonthSeven.compareTo(_today) >= 0;
    bool _nowGreaterThanMidEight = _midMonthEight.compareTo(_today) >= 0;
    bool _nowGreaterThanMidNine = _midMonthNine.compareTo(_today) >= 0;
    bool _nowGreaterThanMidTen = _midMonthTen.compareTo(_today) >= 0;
    bool _nowGreaterThanMidEleven = _midMonthEleven.compareTo(_today) >= 0;
    bool _nowGreaterThanMidTwelve = _midMonthTwelve.compareTo(_today) >= 0;
    bool _nowGreaterThanMidThirteen = _midMonthThirteen.compareTo(_today) >= 0;
    bool _nowGreaterThanMidFourteen = _midMonthFourteen.compareTo(_today) >= 0;
    bool _nowGreaterThanMidFifteen = _midMonthFifteen.compareTo(_today) >= 0;
    bool _nowGreaterThanMidSixteen = _midMonthSixteen.compareTo(_today) >= 0;
    bool _nowGreaterThanMidSeventeen =
        _midMonthSeventeen.compareTo(_today) >= 0;
    bool _nowGreaterThanMidEighteen = _midMonthEighteen.compareTo(_today) >= 0;
    bool _nowGreaterThanMidNineteen = _midMonthNineteen.compareTo(_today) >= 0;
    bool _nowGreaterThanMidTwenty = _midMonthTwenty.compareTo(_today) >= 0;
    bool _nowGreaterThanMidTwentyOne =
        _midMonthTwentyOne.compareTo(_today) >= 0;
    int _voucherNum = nowGreaterThanEndOne
        ? voucherNumber[0]
        : nowGreaterThanEndTwo
            ? voucherNumber[1]
            : nowGreaterThanEndThree
                ? voucherNumber[2]
                : nowGreaterThanEndFour
                    ? voucherNumber[3]
                    : nowGreaterThanEndFive
                        ? voucherNumber[4]
                        : nowGreaterThanEndSix
                            ? voucherNumber[5]
                            : nowGreaterThanEndSeven
                                ? voucherNumber[6]
                                : nowGreaterThanEndEight
                                    ? voucherNumber[7]
                                    : nowGreaterThanEndNine
                                        ? voucherNumber[8]
                                        : nowGreaterThanEndTen
                                            ? voucherNumber[9]
                                            : nowGreaterThanEndEleven
                                                ? voucherNumber[10]
                                                : nowGreaterThanEndTwelve
                                                    ? voucherNumber[11]
                                                    : nowGreaterThanEndThirteen
                                                        ? voucherNumber[12]
                                                        : nowGreaterThanEndFourteen
                                                            ? voucherNumber[13]
                                                            : nowGreaterThanEndFifteen
                                                                ? voucherNumber[
                                                                    14]
                                                                : nowGreaterThanEndSixteen
                                                                    ? voucherNumber[
                                                                        15]
                                                                    : nowGreaterThanEndSeventeen
                                                                        ? voucherNumber[
                                                                            16]
                                                                        : nowGreaterThanEndEighteen
                                                                            ? voucherNumber[17]
                                                                            : nowGreaterThanEndNineteen
                                                                                ? voucherNumber[18]
                                                                                : nowGreaterThanEndTwenty
                                                                                    ? voucherNumber[19]
                                                                                    : nowGreaterThanEndTwentyOne
                                                                                        ? voucherNumber[20]
                                                                                        : voucherNumber[21];
    int _couponNum = _nowGreaterThanMidOne
        ? couponNumber[0]
        : _nowGreaterThanMidTwo
            ? couponNumber[1]
            : _nowGreaterThanMidThree
                ? couponNumber[2]
                : _nowGreaterThanMidFour
                    ? couponNumber[3]
                    : _nowGreaterThanMidFive
                        ? couponNumber[4]
                        : _nowGreaterThanMidSix
                            ? couponNumber[5]
                            : _nowGreaterThanMidSeven
                                ? couponNumber[6]
                                : _nowGreaterThanMidEight
                                    ? couponNumber[7]
                                    : _nowGreaterThanMidNine
                                        ? couponNumber[8]
                                        : _nowGreaterThanMidTen
                                            ? couponNumber[9]
                                            : _nowGreaterThanMidEleven
                                                ? couponNumber[10]
                                                : _nowGreaterThanMidTwelve
                                                    ? couponNumber[11]
                                                    : _nowGreaterThanMidThirteen
                                                        ? couponNumber[12]
                                                        : _nowGreaterThanMidFourteen
                                                            ? couponNumber[13]
                                                            : _nowGreaterThanMidFifteen
                                                                ? couponNumber[
                                                                    14]
                                                                : _nowGreaterThanMidSixteen
                                                                    ? couponNumber[
                                                                        15]
                                                                    : _nowGreaterThanMidSeventeen
                                                                        ? couponNumber[
                                                                            16]
                                                                        : _nowGreaterThanMidEighteen
                                                                            ? couponNumber[17]
                                                                            : _nowGreaterThanMidNineteen
                                                                                ? couponNumber[18]
                                                                                : _nowGreaterThanMidTwenty
                                                                                    ? couponNumber[19]
                                                                                    : _nowGreaterThanMidTwentyOne
                                                                                        ? couponNumber[20]
                                                                                        : couponNumber[21];
    final int _completedToday = _todayList
        .where((CalendarItem element) => element.status == 1)
        .toList()
        .length;
    var _percentAll = ((_completeTaskList.length /
                (_taskList.length == 0 ? 1 : _taskList.length)) *
            100)
        .toStringAsFixed(0);

    var _percentToday =
        ((_completedToday / (_todayList.length == 0 ? 1 : _todayList.length)) *
                100)
            .toStringAsFixed(0);
    List<int> currentNumberComplete = badgeNumbers
        .where((element) => element - _completeTaskList.length == 0)
        .toList();
    final provider = Provider.of<TaskData>(context);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        //TODO new theme 1
        backgroundColor: provider.themeStyle == 'dark'
            ? Color(0xff0B1846)
            : provider.themeStyle == 'crypto'
                ? Color(0xff21181B)
                : provider.themeStyle == 'nft'
                    ? Color(0xff63429D)
                    : provider.themeStyle == 'greenArea'
                        ? Color(0xff2D5B57)
                        : provider.themeStyle == 'swallow'
                            ? Color(0xff2F2D29)
                            : Color(0xffF2F5FA),
        body: SingleChildScrollView(
          child: Container(
            // color: provider.themeStyle == 'dark'
            //     ? Color(0xff0B1846)
            //     : Color(0xffF2F5FA),
            decoration: BoxDecoration(
              //TODO new theme 2
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
            padding: EdgeInsets.only(left: 16, right: 16, top: 48, bottom: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      'Home',
                      style: TextStyle(
                          //TODO new theme 3
                          color: provider.themeStyle == 'dark'
                              ? Colors.white
                              : provider.themeStyle == 'crypto'
                                  ? Color(0xffE9D5A7)
                                  : provider.themeStyle == 'nft' ||
                                          provider.themeStyle == 'greenArea'
                                      ? Colors.white
                                      : provider.themeStyle == 'swallow'
                                          ? Color(0xffCBB27D)
                                          : Color(0xff10243A),
                          fontWeight: FontWeight.bold,
                          fontSize: 24),
                    ),
                    !provider.isPurchased
                        ? _todayLessThan && _todayGreaterThan
                            ? TextButton(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (_) => Purchases()));
                                },
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.local_offer,
                                          color: Colors.white,
                                        ),
                                        DefaultTextStyle(
                                          style: TextStyle(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w900,
                                            color: Colors.white,
                                          ),
                                          child: AnimatedTextKit(
                                            isRepeatingAnimation: true,
                                            animatedTexts: [
                                              RotateAnimatedText(
                                                'BIG SAVE',
                                              ),
                                              TyperAnimatedText('50% OFF',
                                                  speed: Duration(
                                                      milliseconds: 100)),
                                              FadeAnimatedText(
                                                'BIG SAVE',
                                                duration: Duration(seconds: 3),
                                                fadeOutBegin: 0.9,
                                                fadeInEnd: 0.7,
                                              ),
                                              ScaleAnimatedText('LIFETIME',
                                                  scalingFactor: 0.2),
                                              TyperAnimatedText('BIG SAVE',
                                                  speed: Duration(
                                                      milliseconds: 100)),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                          'Expires in ',
                                          style: TextStyle(
                                              color: Colors.white, fontSize: 8),
                                        ),
                                        CountDownText(
                                          due: _endOfMonth,
                                          finishedText: 'Expired',
                                          showLabel: true,
                                          style: TextStyle(
                                              color: Colors.white, fontSize: 8),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                style: TextButton.styleFrom(
                                  elevation: 10,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  padding: EdgeInsets.all(8),
                                  backgroundColor: Color(0xffF082AC),
                                ),
                              )
                            : _todayGreaterThanMid && _todayLessThanMid
                                ? TextButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (_) => Purchases()));
                                    },
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.local_offer,
                                              color: Colors.white,
                                              size: 15,
                                            ),
                                            Text(
                                              '80% OFF Lifetime',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          _midMonthTwentyTwo
                                                      .compareTo(_today) <=
                                                  0
                                              ? 'Sold Out'
                                              : '${_couponNum.toString()} Coupons left',
                                          style: TextStyle(
                                              color: Colors.white, fontSize: 8),
                                        ),
                                      ],
                                    ),
                                    style: TextButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(0),
                                      ),
                                      padding: EdgeInsets.all(8),
                                      backgroundColor: Color(0xffF082AC),
                                    ),
                                  )
                                : Container()
                        : Container()
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return InformationDialog(
                                title: 'Overall Progress',
                                dialogContent:
                                    'Overall progress means the percentage of '
                                    'all tasks that are complete',
                              );
                            });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                          //TODO new theme 4
                          // color: provider.themeStyle == 'dark'
                          //     ? Color(0xff15224F)
                          //     : Color(0xffFFFFFF),
                          gradient: provider.themeStyle == 'dark'
                              ? LinearGradient(
                                  colors: [
                                    Color(0xff0B1846),
                                    Color(0xff0B1846),
                                    Color(0xff0B1846),
                                  ],
                                )
                              : provider.themeStyle == 'crypto' ||
                                      provider.themeStyle == 'swallow'
                                  ? LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                          Colors.white.withOpacity(0.2),
                                          Colors.white.withOpacity(0.05),
                                        ],
                                      stops: [
                                          0.0,
                                          1.0
                                        ])
                                  : provider.themeStyle == 'nft' ||
                                          provider.themeStyle == 'greenArea'
                                      ? LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                              Colors.white.withOpacity(0.2),
                                              Colors.white.withOpacity(0.05),
                                            ],
                                          stops: [
                                              0.0,
                                              1.0
                                            ])
                                      : LinearGradient(
                                          colors: [
                                            Color(0xffF2F5FA),
                                            Color(0xffF2F5FA),
                                            Color(0xffF2F5FA),
                                          ],
                                        ),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.0),
                            topRight: Radius.circular(20.0),
                            bottomLeft: Radius.circular(20.0),
                            bottomRight: Radius.circular(20.0),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularPercentIndicator(
                              radius: 120,
                              lineWidth: 10,
                              animation: true,
                              percent: _completeTaskList.length /
                                  (_taskList.length == 0
                                      ? 1
                                      : _taskList.length),
                              center: Text(
                                _percentAll + '%',
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w600,
                                    //TODO new theme 6
                                    color: provider.themeStyle == 'dark'
                                        ? Color(0xffCA6EEF)
                                        : provider.themeStyle == 'crypto'
                                            ? Color(0xffD1B497)
                                            : provider.themeStyle == 'nft' ||
                                                    provider.themeStyle ==
                                                        'greenArea'
                                                ? Colors.white
                                                : provider.themeStyle ==
                                                        'swallow'
                                                    ? Color(0xffCBB27D)
                                                    : Color(0xff7E8A97)),
                              ),
                              //TODO new theme 8
                              backgroundColor: provider.themeStyle == 'dark'
                                  ? Color(0xffD9BBFE)
                                  : provider.themeStyle == 'crypto'
                                      ? Color(0xff86714E)
                                      : provider.themeStyle == 'nft'
                                          ? Color(0xff7C85F8)
                                          : provider.themeStyle == 'greenArea'
                                              ? Color(0xff2D5B57)
                                              : provider.themeStyle == 'swallow'
                                                  ? Color(0xff2F2D29)
                                                  : Color(0xffE5F8FC),
                              circularStrokeCap: CircularStrokeCap.round,
                              //TODO new theme 9
                              progressColor: provider.themeStyle == 'dark'
                                  ? Color(0xffCA6EEF)
                                  : provider.themeStyle == 'crypto'
                                      ? Color(0xffBA9C90)
                                      : provider.themeStyle == 'nft'
                                          ? Color(0xffFF4FBC)
                                          : provider.themeStyle == 'greenArea'
                                              ? Color(0xff5DC9D2)
                                              : provider.themeStyle == 'swallow'
                                                  ? Color(0xffFFE09D)
                                                  : Color(0xffE2E9F5),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Overall Progress',
                              style: TextStyle(
                                  //TODO new theme 7
                                  fontWeight: FontWeight.bold,
                                  color: provider.themeStyle == 'dark'
                                      ? Colors.white
                                      : provider.themeStyle == 'crypto'
                                          ? Color(0xffFFFFFF)
                                          : provider.themeStyle == 'nft' ||
                                                  provider.themeStyle ==
                                                      'greenArea'
                                              ? Colors.white
                                              : provider.themeStyle == 'swallow'
                                                  ? Color(0xffCBB27D)
                                                  : Color(0xff1D2F44)),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    // color: provider.themeStyle == 'dark'
                    //     ? Color(0xff15224F)
                    //     : Color(0xffFFFFFF),
                    //TODO new theme 10
                    gradient: provider.themeStyle == 'dark'
                        ? LinearGradient(
                            colors: [
                              Color(0xff0B1846),
                              Color(0xff0B1846),
                              Color(0xff0B1846),
                            ],
                          )
                        : provider.themeStyle == 'crypto' ||
                                provider.themeStyle == 'swallow'
                            ? LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                    Colors.white.withOpacity(0.2),
                                    Colors.white.withOpacity(0.05),
                                  ],
                                stops: [
                                    0.0,
                                    1.0
                                  ])
                            : provider.themeStyle == 'nft' ||
                                    provider.themeStyle == 'greenArea'
                                ? LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                        Colors.white.withOpacity(0.2),
                                        Colors.white.withOpacity(0.05),
                                      ],
                                    stops: [
                                        0.0,
                                        1.0
                                      ])
                                : LinearGradient(
                                    colors: [
                                      Color(0xffF2F5FA),
                                      Color(0xffF2F5FA),
                                      Color(0xffF2F5FA),
                                    ],
                                  ),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 4),
                        blurRadius: 30,
                        color: Color(0xff15224F).withOpacity(.16),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      //TODO new theme 11
                      Counter(
                        color: provider.themeStyle == 'dark'
                            ? kAllTasksColor
                            : provider.themeStyle == 'nft'
                                ? Colors.orangeAccent
                                : Color(0xffE7B588),
                        number: _taskList.length,
                        title: "All Tasks",
                      ),
                      Counter(
                        //TODO new theme 12
                        color: provider.themeStyle == 'dark'
                            ? kInProgressColor
                            : provider.themeStyle == 'nft'
                                ? Colors.redAccent
                                : Color(0xffFFBDBC),
                        number: _ongoingTaskList.length,
                        title: "Pending",
                      ),
                      Counter(
                        //TODO new theme 13
                        color: provider.themeStyle == 'dark'
                            ? kCompleteColor
                            : provider.themeStyle == 'nft'
                                ? Colors.lightGreenAccent
                                : Color(0xff82A4A4),
                        number: _completeTaskList.length,
                        title: "Complete",
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Today',
                  style: TextStyle(
                      //TODO new theme 24
                      color: provider.themeStyle == 'dark'
                          ? Colors.white
                          : provider.themeStyle == 'crypto'
                              ? Color(0xffE9D5A7)
                              : provider.themeStyle == 'nft' ||
                                      provider.themeStyle == 'greenArea'
                                  ? Colors.white
                                  : provider.themeStyle == 'swallow'
                                      ? Color(0xffCBB27D)
                                      : Color(0xff1E3146),
                      fontSize: 20),
                ),
                SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return InformationDialog(
                            title: 'Today\'s Progress',
                            dialogContent:
                                'Today\'s progress means the percentage of '
                                'today\'s tasks that are complete',
                          );
                        });
                  },
                  child: LinearPercentIndicator(
                    animation: true,
                    animationDuration: 1000,
                    lineHeight: 20.0,
                    percent: _completedToday /
                        (_todayList.length == 0 ? 1 : _todayList.length),
                    center: Text(
                      _percentToday + '%',
                      style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w600,
                          //TODO new theme 22
                          color: provider.themeStyle == 'nft'
                              ? Colors.white
                              : Colors.black),
                    ),
                    linearStrokeCap: LinearStrokeCap.roundAll,
                    //TODO new theme 21
                    progressColor: provider.themeStyle == 'dark'
                        ? Colors.blue[400]
                        : provider.themeStyle == 'nft'
                            ? Color(0xff76E3FB)
                            : provider.themeStyle == 'swallow'
                                ? Color(0xff7092BE)
                                : Color(0xff90B1B1),
                    //TODO new theme 23
                    backgroundColor: provider.themeStyle == 'nft'
                        ? Color(0xff000001)
                        : Colors.grey,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                _todayList.isEmpty
                    ? Text(
                        'You do not have any Tasks today',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: provider.themeStyle == 'dark'
                                ? Colors.white
                                : provider.themeStyle == 'nft'
                                    ? Colors.white
                                    : Color(0xff606E7C)),
                      )
                    : ListView.separated(
                        scrollDirection: Axis.vertical,
                        physics: ClampingScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final itemTask = _todayList[index];
                          return ListTile(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => ViewTask(
                                            taskSelected: itemTask,
                                          ))).then(onGoBack);
                            },
                            title: Text(
                              itemTask.name,
                              style: TextStyle(
                                //TODO new theme 14
                                color: provider.themeStyle == 'dark'
                                    ? Colors.white
                                    : provider.themeStyle == 'crypto'
                                        ? Color(0xffFAF7F5)
                                        : provider.themeStyle == 'nft' ||
                                                provider.themeStyle ==
                                                    'greenArea'
                                            ? Colors.white
                                            : provider.themeStyle == 'swallow'
                                                ? Color(0xffAC9669)
                                                : Color(0xff606E7C),
                                decoration: itemTask.status == 1
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Text(
                              itemTask.time,
                              style: TextStyle(
                                //TODO new theme 15
                                color: itemTask.status == 0
                                    ? provider.themeStyle == 'dark'
                                        ? Colors.white
                                        : provider.themeStyle == 'crypto'
                                            ? Color(0xffFAF7F5)
                                            : provider.themeStyle == 'nft'
                                                ? Colors.white
                                                : provider.themeStyle ==
                                                        'swallow'
                                                    ? Color(0xffAC9669)
                                                    : Color(0xff606E7C)
                                    : provider.themeStyle == 'dark'
                                        ? Colors.green
                                        : provider.themeStyle == 'nft'
                                            ? Colors.lightGreenAccent
                                            : provider.themeStyle == 'swallow'
                                                ? Color(0xffAC9669)
                                                : Color(0xff82A4A4),
                              ),
                            ),
                            trailing: itemTask.status == 0
                                ? Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextButton(
                                        style: TextButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          padding: const EdgeInsets.all(16),
                                          //TODO new theme 16
                                          backgroundColor: provider
                                                      .themeStyle ==
                                                  'dark'
                                              ? Colors.orangeAccent
                                              : provider.themeStyle == 'crypto'
                                                  ? Color(0xff636B8E)
                                                  : provider.themeStyle == 'nft'
                                                      ? Color(0xffFE48B1)
                                                      : provider.themeStyle ==
                                                                  'greenArea' ||
                                                              provider.themeStyle ==
                                                                  'swallow'
                                                          ? Color(0xffF08650)
                                                          : Color(0xff191919),
                                        ),
                                        child: Text(
                                          'Done',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w900,
                                            fontSize: 12,
                                            color: Colors.white,
                                          ),
                                        ),
                                        onPressed: () {
                                          Provider.of<TaskData>(context,
                                                  listen: false)
                                              .markComplete(itemTask);
                                          if (currentNumberComplete
                                              .isNotEmpty) {
                                            var numComplete =
                                                currentNumberComplete[0] + 1;
                                            _showMaterialDialog(numComplete);
                                          }

                                          _updateTaskList();
                                        },
                                      ),
                                      IconButton(
                                          icon: Icon(
                                            Icons.delete,
                                            //TODO new theme 17
                                            color: provider.themeStyle == 'dark'
                                                ? Colors.white70
                                                : provider.themeStyle ==
                                                        'crypto'
                                                    ? Color(0xff714F3F)
                                                    : provider.themeStyle ==
                                                            'nft'
                                                        ? Colors.purple
                                                        : provider.themeStyle ==
                                                                'greenArea'
                                                            ? Color(0xff818049)
                                                            : provider.themeStyle ==
                                                                    'swallow'
                                                                ? Color(
                                                                    0xffAC9669)
                                                                : Color(
                                                                    0xff020202),
                                          ),
                                          onPressed: () {
                                            _showAlertDialog(itemTask);
                                          }),
                                    ],
                                  )
                                : Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          Icons.edit,
                                          //TODO new theme 18
                                          color: provider.themeStyle == 'dark'
                                              ? Colors.white70
                                              : provider.themeStyle == 'crypto'
                                                  ? Color(0xff714F3F)
                                                  : provider.themeStyle == 'nft'
                                                      ? Colors.deepPurpleAccent
                                                      : provider.themeStyle ==
                                                              'greenArea'
                                                          ? Color(0xff714F3F)
                                                          : provider.themeStyle ==
                                                                  'swallow'
                                                              ? Color(
                                                                  0xffAC9669)
                                                              : Color(
                                                                  0xff020202),
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      CreateTasksScreen(
                                                        task: itemTask,
                                                        updateTaskList:
                                                            _updateTaskList,
                                                      )));
                                        },
                                      ),
                                      IconButton(
                                          icon: Icon(
                                            Icons.delete,
                                            //TODO new theme 19
                                            color: provider.themeStyle == 'dark'
                                                ? Colors.white70
                                                : provider.themeStyle ==
                                                        'crypto'
                                                    ? Color(0xff714F3F)
                                                    : provider.themeStyle ==
                                                            'nft'
                                                        ? Colors.purple
                                                        : provider.themeStyle ==
                                                                'greenArea'
                                                            ? Color(0xff714F3F)
                                                            : provider.themeStyle ==
                                                                    'swallow'
                                                                ? Color(
                                                                    0xffAC9669)
                                                                : Color(
                                                                    0xff020202),
                                          ),
                                          onPressed: () {
                                            _showAlertDialog(itemTask);
                                          }),
                                    ],
                                  ),
                            leading: itemTask.status == 0
                                ? Icon(
                                    Icons.history_toggle_off,
                                    color: provider.themeStyle == 'dark'
                                        ? Colors.redAccent
                                        : Color(0xffE6ABAA),
                                  )
                                : IconButton(
                                    icon: Icon(Icons.check_circle),
                                    onPressed: () {
                                      Provider.of<TaskData>(context,
                                              listen: false)
                                          .markPending(itemTask);
                                      _updateTaskList();
                                    },
                                    color: provider.themeStyle == 'dark'
                                        ? Colors.green
                                        : provider.themeStyle == 'nft'
                                            ? Colors.lightGreenAccent
                                            : Color(0xff82A4A4),
                                  ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return Divider(height: 10);
                        },
                        itemCount: _todayList.length,
                      ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          key: keyButton,
          //TODO new theme 20
          backgroundColor: provider.themeStyle == 'dark'
              ? Colors.redAccent
              : provider.themeStyle == 'nft'
                  ? Color(0xff3FF3FF)
                  : provider.themeStyle == 'greenArea'
                      ? Color(0xff3282F6)
                      : provider.themeStyle == 'swallow'
                          ? Color(0xffFFDE9C)
                          : Color(0xffE2E9F5),
          onPressed: () {
            var tasksLimit = maxTasks == null ? 10 : maxTasks;
            if (provider.isPurchased || _taskList.length < tasksLimit) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CreateTasksScreen(
                            updateTaskList: _updateTaskList,
                          )));
            } else {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return ActionDialog(
                      title: 'OOPs!',
                      dialogContent:
                          'You have reached the maximum number of tasks for the free '
                          'version. Share the app to unlock 5 tasks or Try Premium for FREE   '
                          ' and get unlimited tasks plus all features.',
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
                        var limitOfTasks = tasksLimit + 5;
                        prefsData.setInt('maximumTasks', limitOfTasks);
                        final RenderBox box = context.findRenderObject();
                        Share.share(
                                'I am using todo list Pro to organize my day, '
                                'its really a convenient to-do list. Download it here now: '
                                'https://play.google.com/store/apps/details?id=com.danieljumakowuoche.todo_list',
                                subject: 'ToDo List Pro',
                                sharePositionOrigin:
                                    box.localToGlobal(Offset.zero) & box.size)
                            .then(onGoBack);
                        Navigator.of(context).pop();
                      },
                    );
                  });
            }
          },
          child: Icon(
            Icons.add,
            //TODO new theme 21
            color: provider.themeStyle == 'dark' ||
                    provider.themeStyle == 'greenArea'
                ? Colors.white
                : Color(0xff191919),
          ),
        ),
      ),
    );
  }

  void initTargets() {
    targets.clear();
    targets.add(
      TargetFocus(
        identify: "First Todo",
        keyTarget: keyButton,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Create Task",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "Tap this button to create your first task",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void showTutorial() {
    initTargets();
    tutorialCoachMark = TutorialCoachMark(
      context,
      targets: targets,
      colorShadow: Colors.red,
      textSkip: "SKIP",
      paddingFocus: 10,
      opacityShadow: 0.8,
      onFinish: () {
        print("finish");
      },
      onClickTarget: (target) {
        print('onClickTarget: $target');
      },
      onSkip: () {
        print("skip");
      },
      onClickOverlay: (target) {
        print('onClickOverlay: $target');
      },
    )..show();
  }
}

class BenefitsWidgets extends StatelessWidget {
  final String firstText;
  final String secondText;
  final String thirdText;
  final IconData benefitsIcon;
  final Color benefitColor;
  BenefitsWidgets(
      {this.firstText,
      this.secondText,
      this.thirdText,
      this.benefitsIcon,
      this.benefitColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 40,
          width: 50,
          decoration: BoxDecoration(
            color: benefitColor,
            borderRadius: BorderRadius.all(Radius.circular(13)),
          ),
          child: Icon(
            benefitsIcon,
            color: Colors.white,
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          firstText,
          style: TextStyle(fontSize: 12, color: Color(0xffFE8F00)),
        ),
        Text(
          secondText,
          style: TextStyle(fontSize: 9, color: Color(0xffFFFFFF)),
        ),
        Text(
          thirdText,
          style: TextStyle(fontSize: 9, color: Color(0xffFFFFFF)),
        ),
      ],
    );
  }
}
