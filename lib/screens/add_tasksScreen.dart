import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:todo_list/ads/admob_service.dart';
import 'package:todo_list/calendar_model.dart';
import 'package:todo_list/models/time_zone.dart';
import 'package:todo_list/task_data.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:todo_list/widgets/information_dialog.dart';
import '../db.dart';

class CreateTasksScreen extends StatefulWidget {
  final CalendarItem task;
  final Function updateTaskList;
  final int status;
  //new
  final DateTime selectedDaay;
  CreateTasksScreen(
      {this.task, this.updateTaskList, this.status, this.selectedDaay});
  @override
  _CreateTasksScreenState createState() => _CreateTasksScreenState();
}

class _CreateTasksScreenState extends State<CreateTasksScreen> {
  FlutterLocalNotificationsPlugin fltrNotification;
  int _timeToRemind;
  bool remindMe = false;
  String _name = "";
  String _description = '';
  String _status;
  String _reminder;
  DateTime pickedDate = DateTime.now();
  DateTime _today;
  TimeOfDay time = TimeOfDay.now();
  final List<String> _statuses = ['In Progress', 'Complete'];
  final List<String> _reminders = [
    'Same with Due Date',
    '5 minutes before',
    '30 minutes before',
    '1 day before'
  ];
  bool _validate = false;
  bool _reminderValidator = false;

  List<CalendarItem> _taskList = [];
  getTasks() async {
    var tasks = await DB.getTaskList(CalendarItem.table);
    setState(() {
      _taskList = tasks;
    });
  }

  Future scheduledNotification() async {
    var interval = RepeatInterval.daily;

    var android = AndroidNotificationDetails(
      "id",
      "channel",
      "description",
    );
    var platform = new NotificationDetails(android: android);
    await fltrNotification.periodicallyShow(
      0,
      "🌞 Free mental Space. Lets Track how you are growing.",
      "Set your planner now?",
      interval,
      platform,
    );
  }

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _name = widget.task.name;
      _description = widget.task.description;
      pickedDate = DateTime.parse(
          DateFormat('yyyy-MM-dd').format(DateTime.parse(widget.task.date)));
      time = TimeOfDay.fromDateTime(DateFormat.jm().parse(widget.task.time));
      _status = widget.task.status == 0 ? 'In Progress' : 'Complete';
    }
    //new condition
    else if (widget.selectedDaay != null) {
      pickedDate = widget.selectedDaay;
    }
    //end condition
    var androidInitialize = AndroidInitializationSettings('app_icon');
    var iOSinitialize = IOSInitializationSettings();
    var initializationSettings =
        InitializationSettings(android: androidInitialize, iOS: iOSinitialize);
    fltrNotification = FlutterLocalNotificationsPlugin();
    fltrNotification.initialize(initializationSettings);
    tz.initializeTimeZones();
    getTasks();
    _today = DateTime.now();
  }

  Future _showNotification() async {
    var androidDetails = AndroidNotificationDetails(
        'channelId', 'Todo List Reminder', 'This is a TODO app',
        importance: Importance.max);
    var iOSDetails = IOSNotificationDetails();
    var generalNotificationDetails =
        NotificationDetails(android: androidDetails, iOS: iOSDetails);
    List<CalendarItem> _data;
    var scheduledDate;
    final timeZone = TimeZone();
    String timeZoneName = await timeZone.getTimeZoneName();
    final location = await timeZone.getLocation(timeZoneName);

    List<Map<String, dynamic>> _results = await DB.query(CalendarItem.table);
    _data = _results.map((e) => CalendarItem.fromMap(e)).toList();
    _data.forEach((element) {
      var timeSet = TimeOfDay.fromDateTime(DateFormat.jm().parse(element.time));
      DateTime formattedDate = DateTime.parse(DateFormat('yyyy-MM-dd')
          .format(DateTime.parse(element.date.toString())));
      var itemDate = DateTime(formattedDate.year, formattedDate.month,
          formattedDate.day, timeSet.hour, timeSet.minute, 0);
      var timeNow = DateTime.now();
      int seconds = itemDate.difference(timeNow).inSeconds;

      int secondsBefore = seconds - _timeToRemind;

      if (secondsBefore > 0) {
        scheduledDate =
            tz.TZDateTime.now(location).add(Duration(seconds: secondsBefore));
        fltrNotification.zonedSchedule(element.id, element.name, element.time,
            scheduledDate, generalNotificationDetails,
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime,
            androidAllowWhileIdle: true);
      }
    });
  }

  _showSuccessSnackBar(message) {
    var _snackBar = SnackBar(
      content: message,
      duration: Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(_snackBar);
  }

  Future<bool> _alertDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return InformationDialog(
            title: 'Well Done 👏',
            dialogContent: 'You have created your first task '
                'and started the Journey to become the '
                'most organised version of yourself. '
                'Once Complete, click \'DONE\' button '
                'to track your success. Wish you the best.',
          );
        });
  }

  Future<bool> _blankTaskTitleDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return InformationDialog(
            title: 'Error!',
            dialogContent: 'Task Title can\'t be empty',
          );
        });
  }

  Future<bool> _reminderSetDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return InformationDialog(
            title: 'Error!',
            dialogContent: 'Please set reminder time',
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskData>(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.grey[800],
        ),
        elevation: 0,
        title: Text(
          widget.task == null ? "Create New Task" : "Update Task",
          style: TextStyle(
            fontSize: 25,
            height: 1.2,
            fontWeight: FontWeight.w700,
            color: Colors.grey[800],
          ),
        ),
        backgroundColor: Colors.transparent,
        actions: [
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () async {
                  var formattedDate = DateTime.parse(
                      DateFormat('yyyy-MM-dd').format(pickedDate));
                  var createdDate = DateTime.parse(
                      DateFormat('yyyy-MM-dd').format(DateTime.now()));
                  var createdTime = TimeOfDay.now();
                  _timeToRemind = _reminder == 'Same with Due Date'
                      ? 0
                      : _reminder == '5 minutes before'
                          ? 300
                          : _reminder == '30 minutes before'
                              ? 1800
                              : _reminder == '1 day before'
                                  ? 86400
                                  : null;

                  if (_name.isEmpty) {
                    setState(() {
                      _validate = true;
                    });
                    await _blankTaskTitleDialog(context);
                  } else if (remindMe == true && _reminder == null) {
                    setState(() {
                      _reminderValidator = true;
                    });
                    _reminderSetDialog(context);
                  } else {
                    if (widget.task == null) {
                      Provider.of<TaskData>(context, listen: false).addEvent(
                          _name,
                          _description,
                          formattedDate,
                          time,
                          createdDate,
                          createdTime,
                          _timeToRemind);
                      _showSuccessSnackBar(Text('Task Created'));
                      widget.updateTaskList();
                      if (remindMe == true) {
                        _showNotification();
                      }
                    } else {
                      Provider.of<TaskData>(context, listen: false).updateEvent(
                          _name,
                          _description,
                          formattedDate,
                          time,
                          _status,
                          widget.task,
                          _timeToRemind);
                      _showSuccessSnackBar(Text('Task Updated'));
                      if (remindMe == true) {
                        _showNotification();
                      }
                      widget.updateTaskList();
                    }
                    if (!provider.isPurchased) {
                      if (_taskList.length % 3 == 0 && _taskList.length != 0) {
                        AdMobService.showInterstitialAd();
                      }
                    }
                    if (_taskList.length == 0) {
                      scheduledNotification();
                      await _alertDialog(context);
                    }
                    Navigator.pop(context);
                  }
                },
                child: Icon(
                  MdiIcons.floppy,
                  size: 30.0,
                  color: Colors.black,
                ),
              ))
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                maxLength: 30,
                controller: TextEditingController(text: _name),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[800],
                ),
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                    color: Colors.blueGrey[100],
                  )),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                    color: Colors.blueGrey[100],
                  )),
                  hintText: 'Task title',
                  hintStyle: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[400],
                  ),
                  errorText: _validate ? 'Task title can\'t be empty' : null,
                ),
                onChanged: (value) {
                  _name = value;
                },
                autofocus: true,
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                'Description (optional)',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 5),
              Container(
                height: 100,
                padding: EdgeInsets.all(8),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(15),
                    topLeft: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                  border: Border.all(
                    color: Colors.grey.withOpacity(0.5),
                  ),
                ),
                child: TextField(
                    maxLength: 100,
                    controller: TextEditingController(text: _description),
                    maxLines: 6,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Add description Here',
                        hintStyle: TextStyle(
                          color: Colors.grey[400],
                          fontWeight: FontWeight.w500,
                          fontSize: 24,
                        )),
                    style: TextStyle(
                      fontSize: 18,
                      height: 1.2,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey[800],
                    ),
                    onChanged: (value) {
                      _description = value;
                    }),
              ),
              SizedBox(
                height: 16,
              ),
              // container for timing tray
              Container(
                child: Row(
                  children: [
                    InkWell(
                      onTap: _pickDate,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Color.fromRGBO(255, 240, 240, 1)),
                        padding: const EdgeInsets.all(16),
                        child: Icon(
                          Icons.calendar_today,
                          color: Colors.redAccent,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      '${DateFormat.yMMMMEEEEd().format(pickedDate)}',
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.2,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey[700],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 16,
              ),

              // container for timing tray 2

              Container(
                child: Row(
                  children: [
                    // container for icon
                    InkWell(
                      onTap: _pickTime,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Color.fromRGBO(255, 240, 240, 1)),
                        padding: const EdgeInsets.all(16),
                        child: Icon(
                          Icons.alarm,
                          color: Colors.orangeAccent,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 24,
                    ),
                    // for text
                    Text(
                      '${time.format(context)}',
                      style: TextStyle(
                        fontSize: 18,
                        height: 1.2,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey[700],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 16,
              ),
              // container for task category
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.blueGrey[100],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: widget.task == null
                    ? Container()
                    : DropdownButtonFormField(
                        isDense: true,
                        icon: Icon(Icons.arrow_drop_down_circle),
                        iconSize: 22.0,
                        iconEnabledColor: Theme.of(context).primaryColor,
                        items: _statuses.map((String priority) {
                          return DropdownMenuItem(
                              value: priority,
                              child: Text(
                                priority,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18.0,
                                ),
                              ));
                        }).toList(),
                        style: TextStyle(fontSize: 18.0),
                        decoration: InputDecoration(
                          labelText: 'Status',
                          labelStyle: TextStyle(fontSize: 18.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        validator: (input) => _status == null
                            ? 'Please Select the Current Status'
                            : null,
                        onSaved: (input) => _status = input,
                        onChanged: (value) {
                          setState(() {
                            _status = value;
                          });
                        },
                        value: _status,
                      ),
              ),
              SizedBox(
                height: 16,
              ),
              // container for remind
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.blueGrey[100],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    // container for Icon
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Color.fromRGBO(240, 235, 235, 1)),
                      padding: const EdgeInsets.all(16),
                      child: Icon(
                        Icons.alarm_on,
                        color: Colors.purpleAccent[100],
                      ),
                    ),
                    SizedBox(
                      width: 24,
                    ),
                    // for text
                    Text(
                      'Remind Me',
                      style: TextStyle(
                        fontSize: 18,
                        height: 1.2,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey[700],
                      ),
                    ),
                    Spacer(),
                    Switch(
                      value: remindMe,
                      onChanged: (value) {
                        setState(() {
                          remindMe = value;
                        });
                      },
                      activeColor: Colors.lightBlueAccent,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.blueGrey[100],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: remindMe == false
                    ? Container()
                    : DropdownButtonFormField(
                        isDense: true,
                        icon: Icon(Icons.arrow_drop_down_circle),
                        iconSize: 22.0,
                        iconEnabledColor: Theme.of(context).primaryColor,
                        items: _reminders.map((String setReminder) {
                          return DropdownMenuItem(
                              value: setReminder,
                              child: Text(
                                setReminder,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18.0,
                                ),
                              ));
                        }).toList(),
                        style: TextStyle(fontSize: 18.0),
                        decoration: InputDecoration(
                          labelText: 'Set Reminder',
                          labelStyle: TextStyle(fontSize: 18.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          errorText: _reminderValidator
                              ? 'Please Set a reminder'
                              : null,
                        ),
                        validator: (input) =>
                            input == null ? 'Please Set a reminder' : null,
                        onSaved: (input) => _reminder = input,
                        onChanged: (value) {
                          setState(() {
                            _reminder = value;
                          });
                        },
                        value: _reminder,
                      ),
              ),
              SizedBox(
                height: 16,
              ),
              // button for create task
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(16),
                      backgroundColor: Color(0xff1E57B6),
                    ),
                    child: Text(
                      widget.task == null ? 'Save' : "Update",
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () async {
                      var formattedDate = DateTime.parse(
                          DateFormat('yyyy-MM-dd').format(pickedDate));
                      var createdDate = DateTime.parse(
                          DateFormat('yyyy-MM-dd').format(DateTime.now()));
                      var createdTime = TimeOfDay.now();
                      _timeToRemind = _reminder == 'Same with Due Date'
                          ? 0
                          : _reminder == '5 minutes before'
                              ? 300
                              : _reminder == '30 minutes before'
                                  ? 1800
                                  : _reminder == '1 day before'
                                      ? 86400
                                      : null;

                      if (_name.isEmpty) {
                        setState(() {
                          _validate = true;
                        });
                        await _blankTaskTitleDialog(context);
                      } else if (remindMe == true && _reminder == null) {
                        setState(() {
                          _reminderValidator = true;
                        });
                        await _reminderSetDialog(context);
                      } else {
                        if (widget.task == null) {
                          Provider.of<TaskData>(context, listen: false)
                              .addEvent(
                                  _name,
                                  _description,
                                  formattedDate,
                                  time,
                                  createdDate,
                                  createdTime,
                                  _timeToRemind);
                          _showSuccessSnackBar(Text('Task Created'));
                          widget.updateTaskList();
                          if (remindMe == true) {
                            _showNotification();
                          }
                        } else {
                          Provider.of<TaskData>(context, listen: false)
                              .updateEvent(_name, _description, formattedDate,
                                  time, _status, widget.task, _timeToRemind);
                          _showSuccessSnackBar(Text('Task Updated'));
                          if (remindMe == true) {
                            _showNotification();
                          }
                          widget.updateTaskList();
                        }
                        if (!provider.isPurchased) {
                          if (_taskList.length % 3 == 0 &&
                              _taskList.length != 0) {
                            AdMobService.showInterstitialAd();
                          }
                        }
                        if (_taskList.length == 0) {
                          scheduledNotification();
                          await _alertDialog(context);
                        }
                        Navigator.pop(context);
                      }
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  _pickDate() async {
    DateTime date = await showDatePicker(
      context: context,
      initialDate: pickedDate,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
    );
    if (date != null) {
      setState(() {
        pickedDate = date;
      });
    }
  }

  _pickTime() async {
    TimeOfDay t = await showTimePicker(
      context: context,
      initialTime: time,
    );
    if (t != null) {
      setState(() {
        time = t;
      });
    }
  }
}
