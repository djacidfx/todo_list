class CalendarItem {
  static String table = 'events';
  int id;
  String name;
  String description;
  String date;
  String time;
  int reminder;
  String dateCreated;
  String timeCreated;
  String dateCompleted;
  String timeCompleted;
  int status; // 0 = In Progress, 1 = Complete

  CalendarItem(
      {this.id,
      this.name,
      this.description,
      this.date,
      this.time,
      this.reminder,
      this.status,
      this.dateCreated,
      this.timeCreated,
      this.dateCompleted,
      this.timeCompleted});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'name': name,
      'description': description,
      'date': date,
      'time': time,
      'reminder': reminder,
      'status': status,
      'datecreated': dateCreated,
      'timecreated': timeCreated,
      'datecompleted': dateCompleted,
      'timecompleted': timeCompleted,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  static CalendarItem fromMap(Map<String, dynamic> map) {
    return CalendarItem(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      date: map['date'],
      time: map['time'],
      reminder: map['reminder'],
      status: map['status'],
      dateCreated: map['datecreated'],
      timeCreated: map['timecreated'],
      dateCompleted: map['datecompleted'],
      timeCompleted: map['timecompleted'],
    );
  }
}
