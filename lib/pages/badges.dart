import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/widgets/avatar_container.dart';

import '../calendar_model.dart';
import '../db.dart';
import '../task_data.dart';

class BadgeCollection extends StatefulWidget {
  const BadgeCollection({Key key}) : super(key: key);

  @override
  _BadgeCollectionState createState() => _BadgeCollectionState();
}

class _BadgeCollectionState extends State<BadgeCollection> {
  List<CalendarItem> _completeTaskList = [];
  _getCompleteTasks() async {
    var tasks = await DB.getStatusList(CalendarItem.table, 1);
    setState(() {
      _completeTaskList = tasks;
    });
  }

  @override
  void initState() {
    super.initState();
    _getCompleteTasks();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskData>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Badge Collection',
          style: TextStyle(
              color: provider.themeStyle == 'dark'
                  ? Colors.white
                  : Color(0xff000000)),
        ),
        backgroundColor: provider.themeStyle == 'dark'
            ? Color(0xff14224F)
            : Color(0xff8A8A8A),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AvatarWidget(
                    iconName: Icons.star_rate_outlined,
                    avatarName: 'Dominance',
                    isPurchased: true,
                    completedTasks: _completeTaskList.length,
                    targetCompleteTasks: 5,
                  ),
                  AvatarWidget(
                    iconName: Icons.local_police_outlined,
                    avatarName: 'Mogul',
                    isPurchased: true,
                    completedTasks: _completeTaskList.length,
                    targetCompleteTasks: 15,
                  ),
                  AvatarWidget(
                    iconName: Icons.brightness_high_outlined,
                    avatarName: 'Boss',
                    isPurchased: true,
                    completedTasks: _completeTaskList.length,
                    targetCompleteTasks: 25,
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AvatarWidget(
                    iconName: Icons.emoji_events_outlined,
                    avatarName: 'Hero',
                    isPurchased: true,
                    completedTasks: _completeTaskList.length,
                    targetCompleteTasks: 40,
                  ),
                  AvatarWidget(
                    iconName: Icons.security_outlined,
                    avatarName: 'Icon',
                    isPurchased: provider.isPurchased,
                    completedTasks: _completeTaskList.length,
                    targetCompleteTasks: 55,
                  ),
                  AvatarWidget(
                    iconName: Icons.military_tech_outlined,
                    avatarName: 'Legend',
                    isPurchased: provider.isPurchased,
                    completedTasks: _completeTaskList.length,
                    targetCompleteTasks: 70,
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AvatarWidget(
                    iconName: Icons.sports_motorsports_outlined,
                    avatarName: 'Warrior',
                    isPurchased: provider.isPurchased,
                    completedTasks: _completeTaskList.length,
                    targetCompleteTasks: 90,
                  ),
                  AvatarWidget(
                    iconName: Icons.card_membership,
                    avatarName: 'Hercules',
                    isPurchased: provider.isPurchased,
                    completedTasks: _completeTaskList.length,
                    targetCompleteTasks: 110,
                  ),
                  AvatarWidget(
                    iconName: Icons.monetization_on_outlined,
                    avatarName: 'Tycoon',
                    isPurchased: provider.isPurchased,
                    completedTasks: _completeTaskList.length,
                    targetCompleteTasks: 130,
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AvatarWidget(
                    iconName: Icons.emoji_people,
                    avatarName: 'Honest',
                    isPurchased: provider.isPurchased,
                    completedTasks: _completeTaskList.length,
                    targetCompleteTasks: 150,
                  ),
                  AvatarWidget(
                    iconName: Icons.ac_unit,
                    avatarName: 'Whale',
                    isPurchased: provider.isPurchased,
                    completedTasks: _completeTaskList.length,
                    targetCompleteTasks: 170,
                  ),
                  AvatarWidget(
                    iconName: Icons.all_out_outlined,
                    avatarName: 'Knight',
                    isPurchased: provider.isPurchased,
                    completedTasks: _completeTaskList.length,
                    targetCompleteTasks: 200,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
