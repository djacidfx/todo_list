import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/ads/admob_service.dart';
import 'package:todo_list/calendar_model.dart';
import 'package:todo_list/db.dart';
import 'package:todo_list/screens/purchases.dart';
import 'package:todo_list/widgets/action_dialog.dart';
import 'package:todo_list/widgets/label_text.dart';
import 'package:intl/intl.dart';

import '../task_data.dart';
import 'add_tasksScreen.dart';

class ViewTask extends StatefulWidget {
  final CalendarItem taskSelected;
  ViewTask({this.taskSelected});

  @override
  _ViewTaskState createState() => _ViewTaskState();
}

class _ViewTaskState extends State<ViewTask> {
  var _formatter = DateFormat.yMMMMd('en_US');
  bool isPurchased = false;
  bool isReminderOn;
  DateTime _today;
  CalendarItem _viewTask;

  _updateTaskList() async {
    var tasks = await DB.getTaskList(CalendarItem.table);
    setState(() {
      _viewTask = tasks
          .where((element) => element.id == widget.taskSelected.id)
          .toList()[0];
    });
  }

  @override
  void initState() {
    super.initState();
    _today = DateTime.now();
    _viewTask = widget.taskSelected;
  }

  @override
  Widget build(BuildContext context) {
    String _reminderText = _viewTask.reminder == 0
        ? 'Same With Due Date'
        : _viewTask.reminder == 300
            ? '5 minutes before'
            : _viewTask.reminder == 1800
                ? '30 minutes before'
                : _viewTask.reminder == 86400
                    ? '1 Day Before'
                    : 'Not set';
    String _dateFormatted = _formatter.format(DateTime.parse(
        DateFormat('yyyy-MM-dd').format(DateTime.parse(_viewTask.date))));
    DateTime _dueDate = DateTime.parse(
        DateFormat('yyyy-MM-dd').format(DateTime.parse(_viewTask.date)));
    TimeOfDay _dueTime =
        TimeOfDay.fromDateTime(DateFormat.jm().parse(_viewTask.time));
    var _taskDueTimeDate = DateTime(
      _dueDate.year,
      _dueDate.month,
      _dueDate.day,
      _dueTime.hour,
      _dueTime.minute,
    );
    DateTime _completionDate = _viewTask.dateCompleted == null
        ? null
        : DateTime.parse(DateFormat('yyyy-MM-dd')
            .format(DateTime.parse(_viewTask.dateCompleted)));
    TimeOfDay _completionTime = _viewTask.timeCompleted == null
        ? null
        : TimeOfDay.fromDateTime(
            DateFormat.jm().parse(_viewTask.timeCompleted));
    var _taskCompletionTimeDate = _viewTask.dateCompleted == null
        ? null
        : DateTime(
            _completionDate.year,
            _completionDate.month,
            _completionDate.day,
            _completionTime.hour,
            _completionTime.minute,
          );
    DateTime _createdDate = DateTime.parse(
        DateFormat('yyyy-MM-dd').format(DateTime.parse(_viewTask.dateCreated)));
    TimeOfDay _createdTime =
        TimeOfDay.fromDateTime(DateFormat.jm().parse(_viewTask.timeCreated));
    var _taskCreationTimeDate = DateTime(
      _createdDate.year,
      _createdDate.month,
      _createdDate.day,
      _createdTime.hour,
      _createdTime.minute,
    );
    String _createdDateFormatted = _formatter.format(DateTime.parse(
        DateFormat('yyyy-MM-dd')
            .format(DateTime.parse(_viewTask.dateCreated))));
    String _completedDateFormatted = _viewTask.dateCompleted != null
        ? _formatter.format(DateTime.parse(DateFormat('yyyy-MM-dd')
            .format(DateTime.parse(_viewTask.dateCompleted))))
        : '---Pending---';
    var _reminderTime = _viewTask.reminder == null
        ? null
        : _taskDueTimeDate.subtract(Duration(seconds: _viewTask.reminder));
    String _reminderDateFormatted = _viewTask.reminder == null
        ? null
        : _formatter.format(
            DateTime.parse(DateFormat('yyyy-MM-dd').format(_reminderTime)));
    final _dt = _viewTask.reminder == null
        ? null
        : DateTime(_reminderTime.year, _reminderTime.month, _reminderTime.day,
            _reminderTime.hour, _reminderTime.minute);
    final format = DateFormat.jm();
    isReminderOn = _viewTask.reminder == null ? false : true;
    int _countdown = _taskDueTimeDate.difference(_today).inSeconds;
    int _duration = _countdown < 0 ? 0 : _countdown;
    int _day = (_duration ~/ (24 * 3600)).toInt();
    var nnk = _duration % (24 * 3600);
    int _hour = (nnk ~/ 3600).toInt();
    int _minutes = ((_duration % (3600)) ~/ 60).toInt();
    int _completionDuration = _viewTask.dateCompleted == null
        ? 0
        : _taskCompletionTimeDate.difference(_taskCreationTimeDate).inSeconds;
    int _dayCompleteDuration = (_completionDuration ~/ (24 * 3600)).toInt();
    var nnkCompletion = _completionDuration % (24 * 3600);
    int _hourCompletionDuration = (nnkCompletion ~/ 3600).toInt();
    int _minutesCompletionDuration =
        ((_completionDuration % (3600)) ~/ 60).toInt();
    final provider = Provider.of<TaskData>(context);
    return Scaffold(
      //TODO new theme 0
      backgroundColor: provider.themeStyle == 'dark'
          ? Color(0xff13204D)
          : provider.themeStyle == 'crypto'
              ? Color(0xff55462F)
              : provider.themeStyle == 'nft'
                  ? Color(0xff281B41)
                  : provider.themeStyle == 'greenArea'
                      ? Color(0xff20C312D)
                      : provider.themeStyle == 'swallow'
                          ? Color(0xff2F2D29)
                          : Color(0xffEAEAF3),
      appBar: AppBar(
        //TODO new theme 1
        backgroundColor: provider.themeStyle == 'dark'
            ? Color(0xff0B1846)
            : provider.themeStyle == 'crypto'
                ? Color(0xff55462F)
                : provider.themeStyle == 'nft'
                    ? Color(0xff020000)
                    : provider.themeStyle == 'greenArea'
                        ? Color(0xff2D5B57)
                        : provider.themeStyle == 'swallow'
                            ? Color(0xff2F2D29)
                            : Color(0xff86858C),
        title: Text(
          _viewTask.name,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            //TODO new theme 4
            color: provider.themeStyle == 'swallow'
                ? Color(0xffCBB27D)
                : Colors.white,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          //TODO new theme 2
          color: provider.themeStyle == 'dark'
              ? Color(0xff13204E)
              : provider.themeStyle == 'crypto'
                  ? Color(0xff55462F)
                  : provider.themeStyle == 'nft'
                      ? Color(0xff020000)
                      : provider.themeStyle == 'greenArea'
                          ? Color(0xff2D5B57)
                          : provider.themeStyle == 'swallow'
                              ? Color(0xff2F2D29)
                              : Color(0xffEAEAF3),
          border: Border.all(
              color: Colors.deepPurpleAccent.withOpacity(0.1), width: 2),
          boxShadow: [
            BoxShadow(
              color: provider.themeStyle == 'dark'
                  ? Color(0xff343559).withOpacity(0.4)
                  : Color(0xffEAEAF3),
              offset: Offset(0, 8),
              blurRadius: 10,
            ),
          ],
        ),
        // margin: const EdgeInsets.only(top: 20.0),
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 5,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 16),
                decoration: BoxDecoration(
                  color: provider.themeStyle == 'dark'
                      ? Color(0xff071436)
                      : Color(0xffE7B588),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: Colors.black.withOpacity(0.1), width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: provider.themeStyle == 'dark'
                          ? Color(0xff071436).withOpacity(0.4)
                          : Color(0xffE7B588).withOpacity(0.2),
                      offset: Offset(0, 8),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.description,
                      size: 45.0,
                      color: provider.themeStyle == 'dark'
                          ? Color(0xffFDC601)
                          : Color(0xff1A1925),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Container(
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width - 114),
                      child: Text(
                        _viewTask.description == null
                            ? '---No Description---'
                            : _viewTask.description,
                        style: TextStyle(
                          color: provider.themeStyle == 'dark'
                              ? Colors.white
                              : Color(0xff1A1925),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _taskContainerDetails(
                      context,
                      _dateFormatted,
                      'Due Date',
                      _viewTask.time,
                      '',
                      Icons.flag_outlined,
                      true,
                      'The date on which this task falls due'),
                  _taskContainerDetails(
                      context,
                      _viewTask.reminder == null
                          ? '---not set---'
                          : _reminderDateFormatted,
                      'Reminder',
                      _viewTask.reminder == null
                          ? '---not set---'
                          : format.format(_dt),
                      _viewTask.reminder == null
                          ? '---not set---'
                          : _reminderText,
                      Icons.alarm,
                      true,
                      'Alert to remind you to do the task'),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              _timerContainerDetails(
                  context,
                  'Countdown',
                  provider.isPurchased ? _day.toString() : '**',
                  provider.isPurchased ? _hour.toString() : '**',
                  provider.isPurchased ? _minutes.toString() : '**',
                  provider.isPurchased,
                  'This is the period of time leading up to the task.'),
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _taskContainerDetails(
                      context,
                      provider.isPurchased ? _createdDateFormatted : '****',
                      'Created Date',
                      provider.isPurchased ? _viewTask.timeCreated : '****',
                      '',
                      Icons.add_circle_outline,
                      provider.isPurchased,
                      'This is the date when the task was created'),
                  _taskContainerDetails(
                    context,
                    provider.isPurchased
                        ? _viewTask.dateCompleted != null
                            ? _completedDateFormatted
                            : '---Pending---'
                        : '****',
                    'Completed Date',
                    provider.isPurchased
                        ? _viewTask.timeCompleted != null
                            ? _viewTask.timeCompleted
                            : '---Pending---'
                        : '****',
                    '',
                    _viewTask.status == 0
                        ? Icons.history_toggle_off
                        : Icons.check_circle_outlined,
                    provider.isPurchased,
                    'This is the date when the task was completed',
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              _timerContainerDetails(
                  context,
                  'Completion Time',
                  provider.isPurchased
                      ? _viewTask.dateCompleted == null
                          ? '0'
                          : _dayCompleteDuration.toString()
                      : '**',
                  provider.isPurchased
                      ? _viewTask.dateCompleted == null
                          ? '0'
                          : _hourCompletionDuration.toString()
                      : '**',
                  provider.isPurchased
                      ? _viewTask.dateCompleted == null
                          ? '0'
                          : _minutesCompletionDuration.toString()
                      : '**',
                  provider.isPurchased,
                  'This is the total time it took to '
                      'complete this task from the creation date to completion'
                      'date'),
              InkWell(
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => CreateTasksScreen(
                          task: _viewTask,
                          updateTaskList: _updateTaskList,
                        ))),
                child: Container(
                  height: 60,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: provider.themeStyle == 'dark'
                          ? Colors.deepOrange
                          : Color(0xffB1B5B9),
                      borderRadius: BorderRadius.circular(9.0)),
                  child: Center(
                    child: Text("Edit",
                        style: const TextStyle(
                            color: const Color(0xfffefefe),
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.normal,
                            fontSize: 20.0)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: !provider.isPurchased
          ? Container(
              height: 55,
              child: AdWidget(
                key: UniqueKey(),
                ad: AdMobService.createBannerAd()..load(),
              ),
            )
          : Container(
              height: 15,
              color: Color(0xff2E343B),
            ),
    );
  }

  Stack _taskContainerDetails(
      BuildContext context,
      String _dateFormattedContainer,
      String title,
      String timeContainer,
      String bottomText,
      IconData iconContainer,
      bool isPurchasedTask,
      String dialogContent) {
    String premiumActionCall =
        !isPurchasedTask ? 'Try Premium for FREE to view ..' : '';

    final provider = Provider.of<TaskData>(context, listen: false);
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return ActionDialog(
                    title: title,
                    dialogContent: '$dialogContent. $premiumActionCall',
                    secondButtonText: 'OK',
                    secondButtonFunction: () {
                      Navigator.pop(context);
                    },
                    firstIconData: !isPurchasedTask
                        ? MdiIcons.chessQueen
                        : Icons.cancel_outlined,
                    firstButtonText:
                        !isPurchasedTask ? 'Start Free 3-day Trial' : 'Cancel',
                    firstButtonFunction: () {
                      if (!isPurchasedTask) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Purchases()));
                      } else {
                        Navigator.pop(context);
                      }
                    },
                  );
                });
          },
          child: Container(
            foregroundDecoration: !isPurchasedTask
                ? BoxDecoration(
                    color: Colors.grey,
                    backgroundBlendMode: BlendMode.saturation,
                  )
                : null,
            margin: EdgeInsets.only(bottom: 5.0),
            padding: EdgeInsets.fromLTRB(15.0, 15.0, 10.0, 10.0),
            width: 156.0,
            decoration: BoxDecoration(
              color: provider.themeStyle == 'dark'
                  ? Color(0xff071436)
                  : Color(0xff191919),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Row(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11.0,
                      ),
                    ),
                    SizedBox(height: 5.0),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.calendar_today,
                          color: Theme.of(context).accentColor,
                          size: 10.0,
                        ),
                        SizedBox(width: 10.0),
                        Text(
                          "$_dateFormattedContainer",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10.0,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5.0),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.schedule,
                          color: Theme.of(context).accentColor,
                          size: 10.0,
                        ),
                        SizedBox(width: 10.0),
                        Text(
                          timeContainer,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10.0,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      bottomText,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.0,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: 5,
                ),
                Icon(
                  iconContainer,
                  size: 30,
                  color: Color(0xff656FFB),
                ),
              ],
            ),
          ),
        ),
        !isPurchasedTask
            ? Positioned(
                left: 95,
                child: Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      MdiIcons.chessQueen,
                      color: Colors.orangeAccent,
                      size: 25,
                    ),
                  ),
                ),
              )
            : SizedBox(),
      ],
    );
  }

  Stack _timerContainerDetails(
      BuildContext context,
      String title,
      String dayNumber,
      String hourNumber,
      String minNumber,
      bool isPurchasedTimer,
      String dialogContent) {
    String premiumActionCall =
        !isPurchasedTimer ? 'Try Premium for FREE to view ..' : '';
    final provider = Provider.of<TaskData>(context, listen: false);
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return ActionDialog(
                    title: title,
                    dialogContent: '$dialogContent. $premiumActionCall',
                    secondButtonText: 'OK',
                    secondButtonFunction: () {
                      Navigator.pop(context);
                    },
                    firstIconData: !isPurchasedTimer
                        ? MdiIcons.chessQueen
                        : Icons.cancel_outlined,
                    firstButtonText:
                        !isPurchasedTimer ? 'Start Free 3-day Trial' : 'Cancel',
                    firstButtonFunction: () {
                      if (!isPurchasedTimer) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Purchases()));
                      } else {
                        Navigator.pop(context);
                      }
                    },
                  );
                });
          },
          child: Container(
            foregroundDecoration: !isPurchasedTimer
                ? BoxDecoration(
                    color: Colors.grey,
                    backgroundBlendMode: BlendMode.saturation,
                  )
                : null,
            margin: EdgeInsets.only(bottom: 5.0),
            padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
            decoration: BoxDecoration(
              gradient: provider.themeStyle == 'dark'
                  ? LinearGradient(
                      colors: [
                        Color(0xff66389E),
                        Color(0xff8737A9),
                      ],
                    )
                  : LinearGradient(
                      colors: [
                        Color(0xff0D1728),
                        Color(0xff0D1728),
                      ],
                    ),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.0,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LabelText(
                      label: 'DAYS',
                      value: dayNumber.toString().padLeft(2, '0'),
                    ),
                    LabelText(
                      label: 'HRS',
                      value: hourNumber.toString().padLeft(2, '0'),
                    ),
                    LabelText(
                      label: 'MIN',
                      value: minNumber.toString().padLeft(2, '0'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        !isPurchasedTimer
            ? Positioned(
                left: 165,
                child: Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      MdiIcons.chessQueen,
                      color: Colors.orangeAccent,
                      size: 25,
                    ),
                  ),
                ),
              )
            : SizedBox(),
      ],
    );
  }
}
