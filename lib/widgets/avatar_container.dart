import 'package:flutter/material.dart';

class AvatarWidget extends StatelessWidget {
  final String avatarName;
  final bool isPurchased;
  final IconData iconName;
  final int completedTasks;
  final int targetCompleteTasks;
  AvatarWidget(
      {this.avatarName,
      this.isPurchased,
      this.iconName,
      this.completedTasks,
      this.targetCompleteTasks});

  @override
  Widget build(BuildContext context) {
    return Container(
      foregroundDecoration: isPurchased
          ? completedTasks >= targetCompleteTasks
              ? null
              : BoxDecoration(
                  color: Colors.grey,
                  backgroundBlendMode: BlendMode.saturation,
                )
          : BoxDecoration(
              color: Colors.grey,
              backgroundBlendMode: BlendMode.saturation,
              image: DecorationImage(
                  image: ExactAssetImage('images/ic_lock_name.png'),
                  fit: BoxFit.fill,
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.7), BlendMode.dstATop)),
            ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 45,
            backgroundColor: targetCompleteTasks == 5
                ? Color(0xFF115770)
                : targetCompleteTasks == 15
                    ? Color(0xffDBAD5A)
                    : targetCompleteTasks == 25
                        ? Color(0xff287E62)
                        : targetCompleteTasks == 40
                            ? Color(0xffF5AB79)
                            : targetCompleteTasks == 55
                                ? Color(0xffCFCDC9)
                                : targetCompleteTasks == 70
                                    ? Color(0xff6E9A9A)
                                    : targetCompleteTasks == 90
                                        ? Color(0xffECECEC)
                                        : targetCompleteTasks == 110
                                            ? Color(0xff273E48)
                                            : targetCompleteTasks == 130
                                                ? Color(0xff745F30)
                                                : targetCompleteTasks == 150
                                                    ? Color(0xff0E3339)
                                                    : targetCompleteTasks == 170
                                                        ? Color(0xff20412E)
                                                        : Color(0xff459A56),
            child: CircleAvatar(
              radius: 35,
              backgroundColor: targetCompleteTasks == 5
                  ? Color(0xFFE2CD65)
                  : targetCompleteTasks == 15
                      ? Color(0xff173042)
                      : targetCompleteTasks == 25
                          ? Color(0xff1B1B1B)
                          : targetCompleteTasks == 40
                              ? Color(0xff162620)
                              : targetCompleteTasks == 55
                                  ? Color(0xff223D2D)
                                  : targetCompleteTasks == 70
                                      ? Color(0xffEAE9D3)
                                      : targetCompleteTasks == 90
                                          ? Color(0xff37AEA4)
                                          : targetCompleteTasks == 110
                                              ? Color(0xffECECEC)
                                              : targetCompleteTasks == 130
                                                  ? Color(0xff000000)
                                                  : targetCompleteTasks == 150
                                                      ? Color(0xff65ADDC)
                                                      : targetCompleteTasks ==
                                                              170
                                                          ? Color(0xff75B47D)
                                                          : Color(0xffFFFFFF),
              child: Icon(
                iconName,
                size: 55,
                color: targetCompleteTasks == 5
                    ? Color(0xFF27889A)
                    : targetCompleteTasks == 15
                        ? Color(0xffD8AA59)
                        : targetCompleteTasks == 25
                            ? Color(0xffDCD644)
                            : targetCompleteTasks == 40
                                ? Colors.white70
                                : targetCompleteTasks == 55
                                    ? Color(0xff4DB570)
                                    : targetCompleteTasks == 70
                                        ? Color(0xffE07E66)
                                        : targetCompleteTasks == 90
                                            ? Color(0xffE6577A)
                                            : targetCompleteTasks == 110
                                                ? Color(0xffDF567F)
                                                : targetCompleteTasks == 130
                                                    ? Color(0xffC4B983)
                                                    : targetCompleteTasks == 150
                                                        ? Color(0xff0E3339)
                                                        : targetCompleteTasks ==
                                                                170
                                                            ? Color(0xff20412E)
                                                            : Color(0xff459A56),
              ),
            ),
          ),
          Text(
            avatarName,
            style: TextStyle(fontSize: 16),
          ),
          Text('$targetCompleteTasks Complete', style: TextStyle(fontSize: 10))
        ],
      ),
    );
  }
}
