import 'dart:async';
import 'calendar_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

abstract class DB {
  static Database _db;
  static int get _version => 1;

  static Future<Database> get db async {
    if (_db == null) {
      _db = await _initDb();
    }
    return _db;
  }

  static Future<Database> _initDb() async {
    String _path = await getDatabasesPath();
    String path = p.join(_path, 'calendar_flutter.db');
    final todoListDb =
        await openDatabase(path, version: _version, onCreate: _onCreate);
    return todoListDb;
  }

  static Future<void> init() async {
    try {
      String _path = await getDatabasesPath();
      String _dbPath = p.join(_path, 'calendar_flutter.db');
      _db = await openDatabase(_dbPath, version: _version, onCreate: _onCreate);
    } catch (ex) {
      print(ex);
    }
  }

  static Future<List<Map<String, dynamic>>> getTaskMapList(String table) async {
    Database db = await DB.db;
    final List<Map<String, dynamic>> result = await db.query(table);
    return result;
  }

  static Future<List<CalendarItem>> getTaskList(String table) async {
    final List<Map<String, dynamic>> taskMapList = await getTaskMapList(table);
    final List<CalendarItem> taskList = [];
    taskMapList.forEach((element) {
      taskList.add(CalendarItem.fromMap(element));
    });
    taskList.sort((taskA, taskB) => taskA.date.compareTo(taskB.date));
    return taskList;
  }

  // Map Status List
  static Future<List<Map<String, dynamic>>> getStatusMapList(
      String table, itemStatus) async {
    Database db = await DB.db;
    final List<Map<String, dynamic>> result =
        await db.query(table, where: 'status=?', whereArgs: [itemStatus]);
    return result;
  }

  // get list by status
  static Future<List<CalendarItem>> getStatusList(
      String table, itemStatus) async {
    final List<Map<String, dynamic>> taskMapList =
        await getStatusMapList(table, itemStatus);
    final List<CalendarItem> taskList = [];
    taskMapList.forEach((element) {
      taskList.add(CalendarItem.fromMap(element));
    });
    taskList.sort((taskA, taskB) => taskA.date.compareTo(taskB.date));
    return taskList;
  }

  static Future<List<Map<String, dynamic>>> getTodayMapList(
      String table, itemDate) async {
    Database db = await DB.db;
    final List<Map<String, dynamic>> result =
        await db.query(table, where: 'date=?', whereArgs: [itemDate]);
    return result;
  }

  // get overdue task
  //TODO new 1
  static Future<List<Map<String, dynamic>>> getOverdueMapList(
      String table, itemDates) async {
    Database db = await DB.db;
    final List<Map<String, dynamic>> result = await db.query(table,
        where: 'date IN (${itemDates.map((_) => '?').join(', ')}) and status=0',
        whereArgs: itemDates);
    return result;
  }

  //TODO new 3
  static Future<List<CalendarItem>> getOverdueList(
      String table, itemDate) async {
    final List<Map<String, dynamic>> taskMapList =
        await getOverdueMapList(table, itemDate);
    final List<CalendarItem> taskList = [];
    taskMapList.forEach((element) {
      taskList.add(CalendarItem.fromMap(element));
    });
    taskList.sort((taskA, taskB) => taskA.date.compareTo(taskB.date));
    return taskList;
  }

  // get list by status
  static Future<List<CalendarItem>> getTodayList(String table, itemDate) async {
    final List<Map<String, dynamic>> taskMapList =
        await getTodayMapList(table, itemDate);
    final List<CalendarItem> taskList = [];
    taskMapList.forEach((element) {
      taskList.add(CalendarItem.fromMap(element));
    });
    taskList.sort((taskA, taskB) => taskA.date.compareTo(taskB.date));
    return taskList;
  }

  static FutureOr<void> _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE events (id INTEGER PRIMARY KEY NOT NULL, name STRING, '
        'description STRING,date STRING, time STRING, datecreated STRING, '
        'timecreated STRING, reminder INTEGER, '
        'datecompleted STRING, timecompleted STRING, status INTEGER)');
  }

  static Future<List<Map<String, dynamic>>> query(String table) async =>
      await _db.query(table);

  static Future<int> insert(String table, CalendarItem item) async =>
      await _db.insert(table, item.toMap());

  static Future<int> delete(String table, CalendarItem item) async =>
      await _db.delete(table, where: 'id=?', whereArgs: [item.id]);

  static Future<int> update(String table, CalendarItem item) async => await _db
      .update(table, item.toMap(), where: 'id=?', whereArgs: [item.id]);
}
