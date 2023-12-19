import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../calendar_model.dart';
import '../db.dart';
import '../task_data.dart';

class Skills extends StatefulWidget {
  const Skills({Key key}) : super(key: key);

  @override
  _SkillsState createState() => _SkillsState();
}

class _SkillsState extends State<Skills> {
  List<CalendarItem> _completeTaskList = [];
  getCompleteTasks() async {
    var tasks = await DB.getStatusList(CalendarItem.table, 1);
    setState(() {
      _completeTaskList = tasks;
    });
  }

  @override
  void initState() {
    super.initState();
    getCompleteTasks();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskData>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Skill Level',
          style: TextStyle(
            color: provider.themeStyle == 'dark' ? Colors.white : Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: provider.themeStyle == 'dark'
            ? Color(0xff14224F)
            : Color(0xff878787),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 40.0),
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment(-1, 0),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Text(
                        'Complete more tasks to rank higher',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  skillsContainer(
                      'Master',
                      _completeTaskList.length >= 150
                          ? 'Achieved'
                          : '${150 - _completeTaskList.length} tasks to go',
                      Colors.blueAccent),
                  SizedBox(
                    height: 40,
                  ),
                  skillsContainer(
                      'Scholar',
                      _completeTaskList.length >= 100
                          ? 'Achieved'
                          : '${100 - _completeTaskList.length} tasks to go',
                      Colors.purple),
                  SizedBox(
                    height: 40,
                  ),
                  skillsContainer(
                      'Pro',
                      _completeTaskList.length >= 70
                          ? 'Achieved'
                          : '${70 - _completeTaskList.length} tasks to go',
                      Colors.deepOrange),
                  SizedBox(
                    height: 40,
                  ),
                  skillsContainer(
                      'Novice',
                      _completeTaskList.length >= 30
                          ? 'Achieved'
                          : '${30 - _completeTaskList.length} tasks to go',
                      Colors.yellow[700]),
                  SizedBox(
                    height: 40,
                  ),
                  skillsContainer(
                      'Newbie',
                      _completeTaskList.length >= 10
                          ? 'Achieved'
                          : '${10 - _completeTaskList.length} tasks to go',
                      Colors.blueGrey),
                  SizedBox(
                    height: 40,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container skillsContainer(String level, String achievedStatus, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 32.0),
      height: 48.0,
      color: color,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            level,
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Text(
            achievedStatus,
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          )
        ],
      ),
    );
  }
}
