class FlutterFlexibleDatetimeModel {
  int date = 0;
  String nameOffWeek = "";
  DateTime? dateTime;
  bool isWeekend;
  bool isSelected;
  bool isPreDay;
  bool isCurrentDay;
  FlutterFlexibleDatetimeModel(
    this.date,
    this.nameOffWeek,
    this.dateTime,
    this.isWeekend,
    this.isSelected,
    this.isPreDay,
    this.isCurrentDay,
  );
}
