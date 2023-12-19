import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/pages/badges.dart';
import 'package:todo_list/pages/skills.dart';
import 'package:todo_list/screens/purchases.dart';
import 'package:todo_list/task_data.dart';
import 'package:todo_list/widgets/action_dialog.dart';
import 'package:todo_list/widgets/label_text.dart';
import 'package:intl/intl.dart';
import '../calendar_model.dart';
import '../db.dart';

class Achievements extends StatefulWidget {
  @override
  _AchievementsState createState() => _AchievementsState();
}

class _AchievementsState extends State<Achievements> {
  List<int> _taskLengths = [];
  List<CalendarItem> _completeTaskList = [];
  DateTime _today;
  Map<DateTime, List<String>> _weekTasks = {};
  Map<DateTime, List<String>> _monthTasks = {};
  Map<String, List<int>> _monthWeekTasks = {};
  var theValue = 0;
  var theKey;
  List<int> _sevenDayTasks = [];
  List<int> _fourWeekTasks = [];
  String _dayWeekProductive = 'None';
  _getCompleteTasks() async {
    var tasks = await DB.getStatusList(CalendarItem.table, 1);
    setState(() {
      _completeTaskList = tasks;
    });
    _completeTaskList.forEach((element) {
      DateTime _completedDate = DateTime.parse(DateFormat('yyyy-MM-dd')
          .format(DateTime.parse(element.dateCompleted)));
      TimeOfDay _completedTime =
          TimeOfDay.fromDateTime(DateFormat.jm().parse(element.timeCompleted));
      DateTime _createdDate = DateTime.parse(
          DateFormat('yyyy-MM-dd').format(DateTime.parse(element.dateCreated)));
      TimeOfDay _createdTime =
          TimeOfDay.fromDateTime(DateFormat.jm().parse(element.timeCreated));
      final _completionTaskData = DateTime(
        _completedDate.year,
        _completedDate.month,
        _completedDate.day,
        _completedTime.hour,
        _completedTime.minute,
      );
      final _creationTaskData = DateTime(_createdDate.year, _createdDate.month,
          _createdDate.day, _createdTime.hour, _createdTime.minute);
      int _duration =
          _completionTaskData.difference(_creationTaskData).inSeconds;
      print(_completedDate);
      _taskLengths.add(_duration);
      var sevenDaysMinusNow = _today.subtract(Duration(days: 7));
      if (_completedDate.compareTo(sevenDaysMinusNow) > 0 &&
          _completedDate.compareTo(_today) <= 0) {
        if (_weekTasks.containsKey(_completedDate)) {
          _weekTasks[_completedDate].add(element.name);
        } else {
          _weekTasks[_completedDate] = [element.name];
        }
      }
      var thirtyDaysMinusNow = _today.subtract(Duration(days: 30));
      if (_completedDate.compareTo(thirtyDaysMinusNow) > 0 &&
          _completedDate.compareTo(_today) <= 0) {
        if (_monthTasks.containsKey(_completedDate)) {
          _monthTasks[_completedDate].add(element.name);
        } else {
          _monthTasks[_completedDate] = [element.name];
        }
      }
    });
    _weekTasks.forEach((key, value) {
      if (value.length > theValue) {
        theValue = value.length;
        theKey = key;
      }
      _sevenDayTasks.add(value.length);
    });
    _monthTasks.forEach((key, value) {
      var sevenDaysMinusNow = _today.subtract(Duration(days: 7));
      var fourteenDaysMinusNow = _today.subtract(Duration(days: 14));
      var twentyOneDaysMinusNow = _today.subtract(Duration(days: 21));
      var thirtyDaysMinusNow = _today.subtract(Duration(days: 30));
      if (key.compareTo(sevenDaysMinusNow) > 0) {
        if (_monthWeekTasks.containsKey('Week 4')) {
          _monthWeekTasks['Week 4'].add(value.length);
        } else {
          _monthWeekTasks['Week 4'] = [value.length];
        }
      } else if (key.compareTo(fourteenDaysMinusNow) > 0 &&
          key.compareTo(sevenDaysMinusNow) <= 0) {
        if (_monthWeekTasks.containsKey('Week 3')) {
          _monthWeekTasks['Week 3'].add(value.length);
        } else {
          _monthWeekTasks['Week 3'] = [value.length];
        }
      } else if (key.compareTo(twentyOneDaysMinusNow) > 0 &&
          key.compareTo(fourteenDaysMinusNow) <= 0) {
        if (_monthWeekTasks.containsKey('Week 2')) {
          _monthWeekTasks['Week 2'].add(value.length);
        } else {
          _monthWeekTasks['Week 2'] = [value.length];
        }
      } else if (key.compareTo(thirtyDaysMinusNow) > 0 &&
          key.compareTo(twentyOneDaysMinusNow) <= 0) {
        if (_monthWeekTasks.containsKey('Week 1')) {
          _monthWeekTasks['Week 1'].add(value.length);
        } else {
          _monthWeekTasks['Week 1'] = [value.length];
        }
      }
    });
    _monthWeekTasks.forEach((key, value) {
      var _sumEachWeek = value.fold(0, (a, b) => a + b);
      _fourWeekTasks.add(_sumEachWeek);
    });
    _dayWeekProductive = DateFormat.EEEE().format(theKey);
  }

  List<CalendarItem> _ongoingTaskList = [];
  List<String> _overdueTasks = [];
  _getOngoingTasks() async {
    var tasks = await DB.getStatusList(CalendarItem.table, 0);
    setState(() {
      _ongoingTaskList = tasks;
    });
    _ongoingTaskList.forEach((element) {
      DateTime _dueDate = DateTime.parse(
          DateFormat('yyyy-MM-dd').format(DateTime.parse(element.date)));
      if (_dueDate.compareTo(_today) < 0) {
        _overdueTasks.add(element.name);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _getCompleteTasks();
    _getOngoingTasks();
    _today = DateTime.parse(DateFormat('yyyy-MM-dd').format(DateTime.now()));
    print(_overdueTasks.length);
  }

  @override
  Widget build(BuildContext context) {
    var _sum = _taskLengths.fold(0, (a, b) => a + b);
    int _sumAllWeeks = _fourWeekTasks.fold(0, (a, b) => a + b);
    int _averageWeekly = (_sumAllWeeks /
            (_fourWeekTasks.length == 0 ? 1 : _fourWeekTasks.length))
        .ceil();

    var average = _sum / (_taskLengths.length == 0 ? 1 : _taskLengths.length);
    int _day = (average ~/ (24 * 3600)).toInt();
    var nnk = average % (24 * 3600);
    int _hour = (nnk ~/ 3600).toInt();
    int _minutes = ((average % (3600)) ~/ 60).toInt();
    int _sumSeven = _sevenDayTasks.fold(0, (a, b) => a + b);
    int _averageDaily =
        (_sumSeven / (_sevenDayTasks.length == 0 ? 1 : _sevenDayTasks.length))
            .ceil();
    String badges = _completeTaskList.length < 5
        ? '0'
        : _completeTaskList.length < 15
            ? '1'
            : _completeTaskList.length < 25
                ? '2'
                : _completeTaskList.length < 40
                    ? '3'
                    : _completeTaskList.length < 55
                        ? '4'
                        : _completeTaskList.length < 70
                            ? '5'
                            : _completeTaskList.length < 90
                                ? '6'
                                : _completeTaskList.length < 110
                                    ? '7'
                                    : _completeTaskList.length < 130
                                        ? '8'
                                        : _completeTaskList.length < 150
                                            ? '9'
                                            : _completeTaskList.length < 170
                                                ? '10'
                                                : _completeTaskList.length < 200
                                                    ? '11'
                                                    : '12';
    String skillLevel = _completeTaskList.length < 5
        ? 'Beginner'
        : _completeTaskList.length < 15
            ? 'Newbie'
            : _completeTaskList.length < 30
                ? 'Novice'
                : _completeTaskList.length < 50
                    ? 'Pro'
                    : _completeTaskList.length < 80
                        ? 'Scholar'
                        : 'Master';
    final provider = Provider.of<TaskData>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Achievements',
          style: TextStyle(
            color: provider.themeStyle == 'swallow'
                ? Color(0xffCBB27D)
                : Colors.white,
          ),
        ),
        //TODO new theme 1
        backgroundColor: provider.themeStyle == 'dark'
            ? Color(0xff545FDB)
            : provider.themeStyle == 'crypto'
                ? Color(0xff55462F)
                : provider.themeStyle == 'nft'
                    ? Color(0xff281B41)
                    : provider.themeStyle == 'greenArea'
                        ? Color(0xff20C312D)
                        : provider.themeStyle == 'swallow'
                            ? Color(0xff2F2D29)
                            : Color(0xff000000),
      ),
      body: Container(
        // color: provider.themeStyle == 'dark'
        //     ? Color(0xff14224F)
        //     : Color(0xffFFFFFF),
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
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      margin: const EdgeInsets.all(8.0),
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        //TODO new theme 3
                        color: provider.themeStyle == 'dark' ||
                                provider.themeStyle == 'greenArea'
                            ? Colors.pinkAccent
                            : provider.themeStyle == 'crypto' ||
                                    provider.themeStyle == 'nft'
                                ? Colors.cyan
                                : Color(0xff1E1E1E),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0),
                          bottomLeft: Radius.circular(20.0),
                          bottomRight: Radius.circular(20.0),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            Icons.military_tech_outlined,
                            color: Colors.white,
                            size: 35,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                badges,
                                style: TextStyle(
                                  fontSize: 22,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Badges',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.white),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      margin: const EdgeInsets.all(8.0),
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        //TODO new theme 4
                        color: provider.themeStyle == 'dark'
                            ? Color(0xff6942D1)
                            : provider.themeStyle == 'crypto' ||
                                    provider.themeStyle == 'nft' ||
                                    provider.themeStyle == 'greenArea'
                                ? Colors.orange
                                : Color(0xff82A4A4),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0),
                          bottomLeft: Radius.circular(20.0),
                          bottomRight: Radius.circular(20.0),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            Icons.grade_outlined,
                            size: 30,
                            color: Colors.white,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                skillLevel,
                                style: TextStyle(
                                  fontSize: 22,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'level',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Flexible(
              child: Row(
                children: [
                  _buildStatCard(
                      Icons.timer,
                      'Average Completion Time',
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          LabelText(
                            label: 'DAYS',
                            value: provider.isPurchased
                                ? _day.toString().padLeft(2, '0')
                                : '**',
                          ),
                          LabelText(
                            label: 'HRS',
                            value: provider.isPurchased
                                ? _hour.toString().padLeft(2, '0')
                                : '**',
                          ),
                          LabelText(
                            label: 'MIN',
                            value: provider.isPurchased
                                ? _minutes.toString().padLeft(2, '0')
                                : '**',
                          ),
                        ],
                      ),
                      provider.themeStyle == 'dark'
                          ? Colors.green
                          : Color(0xffF0F5FF),
                      'Average Completion Time is the average '
                          'time it took to complete tasks over the last 7 days.',
                      provider.isPurchased),
                  _buildStatCard(
                      Icons.view_week_outlined,
                      'Most Productive day of the week',
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            provider.isPurchased
                                ? '$_dayWeekProductive'
                                : '***day',
                            style: TextStyle(
                              color: provider.themeStyle == 'dark'
                                  ? Colors.white
                                  : Color(0xff4C4C4C),
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            provider.isPurchased
                                ? '$theValue Completed'
                                : '** Completed',
                            style: TextStyle(
                              color: provider.themeStyle == 'dark'
                                  ? Colors.white60
                                  : Color(0xff4C4C4C),
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      provider.themeStyle == 'dark'
                          ? Colors.purple
                          : Color(0xffFAF8F2),
                      'It is the day with the highest number of '
                          'completed tasks over the last 7 days',
                      provider.isPurchased),
                ],
              ),
            ),
            Flexible(
              child: Row(
                children: [
                  _buildStatCard(
                      Icons.assignment_late_outlined,
                      'Total Tasks Overdue',
                      Text(
                        '${_overdueTasks.length}',
                        style: TextStyle(
                          color: provider.themeStyle == 'dark'
                              ? Colors.white
                              : Color(0xff707070),
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      provider.themeStyle == 'dark'
                          ? Colors.orange
                          : Color(0xffEFFCEF),
                      'This are the number of Tasks that had not '
                          'been completed by their due date',
                      true),
                  _buildStatCard(
                      Icons.check_circle_outline,
                      'Average Tasks Complete Per Day',
                      Text(
                        provider.isPurchased ? '$_averageDaily' : '**',
                        style: TextStyle(
                          color: provider.themeStyle == 'dark'
                              ? Colors.white
                              : Color(0xff707070),
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      provider.themeStyle == 'dark'
                          ? Colors.red
                          : Color(0xffE6F5FB),
                      'This are the average number of Tasks '
                          'completed in one day over the last 7 days',
                      provider.isPurchased),
                  _buildStatCard(
                      Icons.fact_check_outlined,
                      'Average Tasks Complete Per Week',
                      Text(
                        provider.isPurchased ? '$_averageWeekly' : '**',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      provider.themeStyle == 'dark'
                          ? Colors.lightBlue
                          : Color(0xffF8C0B9),
                      'This are the average number of Tasks'
                          'Complete per week over the last 30 days',
                      provider.isPurchased),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            ListTile(
              title: Text(
                'Skills Level',
                style: TextStyle(
                    //TODO new theme 5
                    color: provider.themeStyle == 'dark' ||
                            provider.themeStyle == 'crypto' ||
                            provider.themeStyle == 'nft' ||
                            provider.themeStyle == 'greenArea'
                        ? Colors.white
                        : provider.themeStyle == 'swallow'
                            ? Color(0xffCBB27D)
                            : Colors.black),
              ),
              trailing: Icon(Icons.chevron_right,
                  //TODO new theme 7
                  color: provider.themeStyle == 'dark' ||
                          provider.themeStyle == 'crypto' ||
                          provider.themeStyle == 'nft' ||
                          provider.themeStyle == 'greenArea'
                      ? Color(0xffFDC054)
                      : provider.themeStyle == 'swallow'
                          ? Color(0xffCBB27D)
                          : Colors.black),
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => Skills()));
              },
            ),
            ListTile(
              title: Text(
                'Badge Collection',
                style: TextStyle(
                    //TODO new theme 8
                    color: provider.themeStyle == 'dark' ||
                            provider.themeStyle == 'crypto' ||
                            provider.themeStyle == 'nft' ||
                            provider.themeStyle == 'greenArea'
                        ? Colors.white
                        : provider.themeStyle == 'swallow'
                            ? Color(0xffCBB27D)
                            : Colors.black),
              ),
              trailing: Icon(Icons.chevron_right,
                  //TODO new theme 6
                  color: provider.themeStyle == 'dark' ||
                          provider.themeStyle == 'crypto' ||
                          provider.themeStyle == 'nft' ||
                          provider.themeStyle == 'greenArea'
                      ? Color(0xffFDC054)
                      : provider.themeStyle == 'swallow'
                          ? Color(0xffCBB27D)
                          : Colors.black),
              onTap: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => BadgeCollection())),
            )
          ],
        ),
      ),
    );
  }

  Expanded _buildStatCard(IconData cardIcon, String title, Widget count,
      Color color, String dialogContent, bool isPurchasedContainer) {
    String premiumActionCall =
        !isPurchasedContainer ? 'Try now for FREE to view your result' : '';
    final prodiver = Provider.of<TaskData>(context);
    return Expanded(
      child: GestureDetector(
        onTap: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return ActionDialog(
                  title: title,
                  dialogContent: '$dialogContent $premiumActionCall',
                  secondButtonText: 'OK',
                  secondButtonFunction: () {
                    Navigator.pop(context);
                  },
                  firstIconData: !isPurchasedContainer
                      ? MdiIcons.chessQueen
                      : Icons.cancel_outlined,
                  firstButtonText: !isPurchasedContainer
                      ? 'Start Free 3-day Trial'
                      : 'Cancel',
                  firstButtonFunction: () {
                    if (!isPurchasedContainer) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Purchases()));
                    } else {
                      Navigator.pop(context);
                    }
                  },
                );
              });
        },
        child: Stack(
          children: [
            Container(
              foregroundDecoration: !isPurchasedContainer
                  ? BoxDecoration(
                      color: Colors.grey,
                      backgroundBlendMode: BlendMode.saturation,
                    )
                  : null,
              margin: const EdgeInsets.all(8.0),
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Icon(
                    cardIcon,
                    size: 45,
                    color: prodiver.themeStyle == 'dark'
                        ? Colors.white
                        : Color(0xff737373),
                  ),
                  count,
                  Text(
                    title,
                    style: TextStyle(
                      color: prodiver.themeStyle == 'dark'
                          ? Colors.white70
                          : Color(0xff737373),
                      fontSize: 12.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            !isPurchasedContainer
                ? Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Icon(
                        MdiIcons.chessQueen,
                        color: Colors.orangeAccent,
                        size: 40,
                      ),
                    ),
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
