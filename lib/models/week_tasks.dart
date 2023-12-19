class WeekTasks {
  String weekNum;
  int tasksNum;
  WeekTasks(this.weekNum, this.tasksNum);

  @override
  String toString() {
    return '{ ${this.weekNum}, ${this.tasksNum} }';
  }
}
