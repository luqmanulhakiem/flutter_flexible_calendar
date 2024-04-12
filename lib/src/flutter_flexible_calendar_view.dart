// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../flutter_flexible_calendar.dart';
import 'flutter_flexible_datetime_model.dart';
import 'flutter_slivergriddelegate.dart';

/// FlutterFlexibleCalendarView is the main class of the FlutterFlexibleCalendarView API.
///
/// It manages all params required for API using.
/// you can check some required, some not.
///
class FlutterFlexibleCalendarView extends StatefulWidget {
  /// The [month] current month.
  DateTime month;

  /// The [currentMonth] current month prvate param.
  DateTime currentMonth = DateTime.now();

  /// The [disabledPreDay] disabled previous day.
  bool disabledPreDay;

  /// The [showWeekendDay] show weekend day of previous of the month.
  bool showWeekendDay;

  /// The [showHeader] show calendar header.
  bool showHeader;

  /// The [isMultiple] enabled multiple selected.
  bool? isMultipleSelected;

  /// The [setStartSelected] enabled multiple selected.
  DateTime? setStartSelected;

  /// The [setEndSelected] enabled multiple selected.
  DateTime? setEndSelected;

  /// The [maxYear] set max year allow move next.
  int? maxYear;

  /// The [minYear] set min year allow move back.
  int? minYear;

  /// The [dayLists] set list date header.
  ///
  /// Ex: ["Mon", "Tue", "Wed", "Thur", "Fri", "Sat", "Sun"]
  List<String>? dayLists;

  /// The [bgDayOfWeekend] set background item day of weekend.
  Color? bgDayOfWeekend;

  /// The [currentDatePoint] set current status point for today.
  Color? currentDatePoint;

  /// The [colorBg] set background color for calendar.
  Color? colorBg;

  /// The [styleNumberDayOfWeekend] set number of weekend style.
  TextStyle? styleNumberDayOfWeekend;

  /// The [styleDayOfWeekend]
  TextStyle? styleDayOfWeekend;

  /// The [styleSelectedText]
  TextStyle? styleSelectedText;

  /// The [styleSelectedSubText]
  TextStyle? styleSelectedSubText;

  /// The [boxDecorationSelected]
  BoxDecoration? boxDecorationSelected;

  /// The [headerBgColor]
  Color? headerBgColor;

  /// The [styleHeaderTextTitle]
  TextStyle? styleHeaderTextTitle;

  /// The [styleHeaderSubTextTitle]
  TextStyle? styleHeaderSubTextTitle;

  /// The [headerArrowLeft]
  Widget? headerArrowLeft;

  /// The [headerArrowRight]
  Widget? headerArrowRight;

  /// The [headerDateFormat]
  String? headerDateFormat;

  /// The [bgDay]
  Color? bgDay;

  /// The [styleNumberDay]
  TextStyle? styleNumberDay;

  /// The [styleDay]
  TextStyle? styleDay;

  /// The [FlutterFlexibleDatetimeModel]
  Function(FlutterFlexibleDatetimeModel?, DateTime?)? didResult;

  /// The [FlutterFlexibleDatetimeModel]
  Function(
    FlutterFlexibleDatetimeModel? firstDate,
    FlutterFlexibleDatetimeModel? lastDate,
  )? didMultipleSelected;

  /// The [didDisableItemClick]
  Function()? didDisableItemClick;

  /// The [didWeekendItemClick]
  Function()? didWeekendItemClick;

  /// The [calendarType]
  FlutterFlexibleCalendarType? calendarType;

  FlutterFlexibleCalendarView({
    super.key,
    required this.month,
    int? maxLimitYear,
    int? minLimitYear,
    List<String>? days,
    this.calendarType = FlutterFlexibleCalendarType.standard,
    this.headerBgColor,
    this.styleHeaderTextTitle,
    this.styleHeaderSubTextTitle,
    this.styleSelectedText,
    this.styleSelectedSubText,
    this.colorBg,
    this.boxDecorationSelected,
    this.currentDatePoint,
    this.headerArrowLeft,
    this.headerArrowRight,
    this.headerDateFormat,
    this.disabledPreDay = true,
    this.showWeekendDay = true,
    this.showHeader = true,
    this.isMultipleSelected = false,
    this.setStartSelected,
    this.setEndSelected,
    this.bgDayOfWeekend,
    this.styleDayOfWeekend,
    this.styleNumberDayOfWeekend,
    this.bgDay,
    this.styleNumberDay,
    this.styleDay,
    this.didResult,
    this.didDisableItemClick,
    this.didWeekendItemClick,
    this.didMultipleSelected,
  }) {
    dayLists = days ?? ["Mon", "Tue", "Wed", "Thur", "Fri", "Sat", "Sun"];
    maxYear =
        maxLimitYear != null ? month.year + maxLimitYear : month.year + 10;
    minYear = minLimitYear != null ? month.year - minLimitYear : month.year - 2;
    currentMonth = month;
  }
  static int setDefaultMonth({required int month}) {
    return (DateTime.now().month - 1 % 12) + month;
  }

  static DateTime getCurrentMonth() {
    return DateTime.now();
  }

  @override
  CustomCalendarViewState createState() => CustomCalendarViewState();
}

class CustomCalendarViewState extends State<FlutterFlexibleCalendarView> {
  late PageController pageController = PageController(initialPage: 0);

  List<FlutterFlexibleDatetimeModel> listDayOffWeek = [];
  List<List<FlutterFlexibleDatetimeModel>> listDayPerMonth = [];
  List<FlutterFlexibleDatetimeModel> listDayPerMonthMerge = [];
  List<FlutterFlexibleDatetimeModel> listDay = [];
  List<FlutterFlexibleDatetimeModel> listDayS = [];
  List<List<int>> listCurrentSelected = [];
  List<DateTime> listDatedSelected = [];
  FlutterFlexibleDatetimeModel? itemSelected;
  bool isSelected = true;
  int daysInMonth = 0;
  late DateTime firstDayOfMonth;
  late DateTime lastDayOfPreviousMonth;
  DateTime? currentSelected;
  int weekdayOfFirstDay = 0;
  int daysInPreviousMonth = 0;
  int totalWeekdayOfFirstDay = 0;
  int indexPage = 0;
  bool isFirstLoaded = false;
  bool isMoved = false;

  GlobalKey stickyKey = GlobalKey();
  @override
  void initState() {
    isFirstLoaded = true;
    initCalendar();
    super.initState();
  }

  void reInitData() {
    listDayOffWeek = [];
    listDayPerMonth = [];
    listDayPerMonthMerge = [];
    listDay = [];
    listDayS = [];
  }

  void updateDateOfMonth(
    int day,
    int parentIndex,
    int childIndex,
  ) {
    widget.currentMonth = DateTime(widget.month.year, widget.month.month, day);
    currentSelected = DateTime(widget.month.year, widget.month.month, day);

    if (widget.isMultipleSelected == true) {
      if (listCurrentSelected.length >= 2) {
        listCurrentSelected = [];
        widget.setStartSelected = null;
      }
      if (listDatedSelected.length >= 2) {
        listDatedSelected = [];
      }
      List<int> item = [];
      item.add(parentIndex);
      item.add(childIndex);
      listCurrentSelected.add(item);
      listDatedSelected.add(currentSelected!);
      if (listDatedSelected.length >= 2) {
        if (listDatedSelected[0].month != listDatedSelected[1].month) {
          listCurrentSelected = [];
          widget.setStartSelected = null;
          listDatedSelected = [];
        }
      }
    }
    listDayPerMonth.asMap().forEach(
      (key, value) {
        for (var element in value) {
          element.isSelected = false;
        }
        if (key == parentIndex) {
          value[childIndex].isSelected = true;
        }
      },
    );
    if (listCurrentSelected.length == 2) {
      var first = listCurrentSelected[0][1] > listCurrentSelected[1][1]
          ? listCurrentSelected[1][1]
          : listCurrentSelected[0][1];
      var second = listCurrentSelected[1][1] < listCurrentSelected[0][1]
          ? listCurrentSelected[0][1]
          : listCurrentSelected[1][1];
      if (first > second) {
        second = first;
      }

      listDayPerMonth.asMap().forEach(
        (key, value) {
          for (var element in value) {
            element.isSelected = false;
          }
          if (listCurrentSelected[0][0] == listCurrentSelected[1][0]) {
            if (key == parentIndex) {
              for (var i = first; i <= second; i++) {
                value[i].isSelected = true;
              }
            }
          } else {
            for (var i = listCurrentSelected[0][0];
                i <= listCurrentSelected[1][0];
                i++) {
              var first = listCurrentSelected[0][1];
              if (key == i && listCurrentSelected[0][0] == key) {
                for (var i = first; i < value.length; i++) {
                  value[i].isSelected = true;
                }
              }

              if (key == i &&
                  listCurrentSelected[0][0] != key &&
                  listCurrentSelected[1][0] != i) {
                for (var i = 0; i < value.length; i++) {
                  value[i].isSelected = true;
                }
              }

              var second = listCurrentSelected[1][1];
              if (listCurrentSelected[1][0] == key) {
                for (var i = 0; i <= second; i++) {
                  value[i].isSelected = true;
                }
              }
            }
          }
        },
      );
    }
    listDayPerMonthMerge = listDayPerMonth.expand((x) => x).toList();
    var items =
        listDayPerMonthMerge.where((element) => element.isSelected).toList();

    if (widget.isMultipleSelected == true && items.length > 1) {
      print(items.first);
      widget.didMultipleSelected?.call(items.first, items.last);
    }
    setState(() {});
  }

  void initCurrentWeek(int index) {
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeIn,
    );
  }

  void initCalendar() {
    reInitData();
    daysInMonth = DateTime(widget.month.year, widget.month.month + 1, 0).day;
    firstDayOfMonth = DateTime(widget.month.year, widget.month.month, 1);
    weekdayOfFirstDay = firstDayOfMonth.weekday;
    totalWeekdayOfFirstDay = weekdayOfFirstDay;
    lastDayOfPreviousMonth = firstDayOfMonth.subtract(const Duration(days: 1));
    daysInPreviousMonth = lastDayOfPreviousMonth.day;
    var indexName = 0;
    for (var i = 0; i < (daysInMonth + weekdayOfFirstDay - 1); i++) {
      String dayName = "";
      indexName++;
      dayName = widget.dayLists![indexName - 1];
      if (indexName == 7 && i != 0) {
        indexName = 0;
      }

      if (i < weekdayOfFirstDay - 1) {
        int previousMonthDay =
            daysInPreviousMonth - (weekdayOfFirstDay - i) + 2;
        listDayOffWeek.add(
          FlutterFlexibleDatetimeModel(
            previousMonthDay,
            dayName,
            DateTime(widget.month.year, widget.month.month, previousMonthDay),
            true,
            false,
            true,
            false,
          ),
        );
      } else {
        DateTime date = DateTime(
            widget.month.year, widget.month.month, i - weekdayOfFirstDay + 2);

        listDayOffWeek.add(
          FlutterFlexibleDatetimeModel(
            date.day,
            dayName,
            DateTime(widget.month.year, widget.month.month, date.day),
            false,
            false,
            false,
            false,
          ),
        );
      }
    }
    for (final (_, item) in listDayOffWeek.indexed) {
      listDayS.add(item);
    }
    int n = 0;
    int startDate = 0;
    if (!widget.showWeekendDay) {
      startDate = totalWeekdayOfFirstDay - 1;
    }
    for (var i = startDate; i < listDayS.length; i++) {
      n++;
      var item = listDayS[i];

      listDay.add(item);

      if ((n) % 7 == 0) {
        listDayPerMonth.add(listDay);
        listDay = [];
      }
    }

    if ((listDayOffWeek.length != (listDayPerMonth.length * 7))) {
      listDayPerMonth.add(listDay);
    }
    List<int> item = [];
    if (isFirstLoaded) {
      listDayPerMonth.asMap().forEach((key, value) {
        value.asMap().forEach((childIndex, element) {
          if (DateTime.now().year == element.dateTime?.year &&
              DateTime.now().day == element.date &&
              DateTime.now().month == element.dateTime?.month) {
            if (currentSelected == null) {
              element.isSelected = true;
              widget.didResult?.call(element, widget.currentMonth);
              List<int> item = [];
              item.add(key);
              item.add(childIndex);
              listCurrentSelected.add(item);
            }
            widget.currentMonth =
                DateTime(widget.month.year, widget.month.month, element.date);
            element.dateTime = widget.currentMonth;
            element.isCurrentDay = true;
            indexPage = key;
          }
          if (widget.isMultipleSelected == true &&
              currentSelected?.year == element.dateTime?.year &&
              currentSelected!.day >= element.date &&
              currentSelected?.month == element.dateTime?.month &&
              listCurrentSelected.length > 1) {
            if (listCurrentSelected[0][0] == listCurrentSelected[1][0]) {
              var first = listCurrentSelected[0][1];
              var second = listCurrentSelected[1][1];
              if (key == listCurrentSelected[0][0]) {
                for (var i = first; i <= second; i++) {
                  value[i].isSelected = true;
                }
              }
            } else {
              for (var i = listCurrentSelected[0][0];
                  i <= listCurrentSelected[1][0];
                  i++) {
                var first = listCurrentSelected[0][1];
                if (key == i && listCurrentSelected[0][0] == key) {
                  for (var i = first; i < value.length; i++) {
                    value[i].isSelected = true;
                  }
                }

                if (key == i &&
                    listCurrentSelected[0][0] != key &&
                    listCurrentSelected[1][0] != i) {
                  for (var i = 0; i < value.length; i++) {
                    value[i].isSelected = true;
                  }
                }

                var second = listCurrentSelected[1][1];
                if (listCurrentSelected[1][0] == key) {
                  for (var i = 0; i <= second; i++) {
                    value[i].isSelected = true;
                  }
                }
              }
            }
          } else {
            if (widget.setStartSelected != null &&
                widget.setEndSelected != null &&
                widget.isMultipleSelected == true) {
              if (DateTime.now().day != widget.setStartSelected!.day) {
                element.isSelected = false;
              } else {
                element.isSelected = true;
              }
              for (var i = widget.setStartSelected!.day;
                  i <= widget.setEndSelected!.day;
                  i++) {
                if (widget.setStartSelected?.year == element.dateTime?.year &&
                    i >= element.date &&
                    widget.setStartSelected?.month == element.dateTime?.month) {
                  if (i == element.date) {
                    element.isSelected = true;
                    item.add(key);
                    item.add(childIndex);
                    listCurrentSelected.add(item);
                  }
                  element.dateTime = widget.currentMonth;

                  indexPage = key;
                  widget.didResult?.call(element, widget.currentMonth);
                }
              }
            } else {
              if (currentSelected != null &&
                  currentSelected?.year == element.dateTime?.year &&
                  currentSelected!.day >= element.date &&
                  currentSelected?.month == element.dateTime?.month) {
                if (currentSelected!.day == element.date) {
                  element.isSelected = true;
                }
                element.dateTime = widget.currentMonth;
                if (currentSelected?.day == DateTime.now().day) {
                  element.isCurrentDay = true;
                } else {
                  element.isCurrentDay = false;
                }
                indexPage = key;
                widget.didResult?.call(element, widget.currentMonth);
              }
            }
          }
          if (DateTime.now().year >= element.dateTime!.year &&
              DateTime.now().day > element.date &&
              DateTime.now().month >= element.dateTime!.month) {
            element.isPreDay = true;
            element.isCurrentDay = false;
          }
          if (DateTime.now().year > element.dateTime!.year) {
            element.isPreDay = false;
            element.isCurrentDay = false;
          }
        });
      });
      listDayPerMonthMerge = listDayPerMonth.expand((x) => x).toList();
      var items =
          listDayPerMonthMerge.where((element) => element.isSelected).toList();

      if (widget.isMultipleSelected == true && items.length > 1) {
        print(items.first);
        widget.didMultipleSelected?.call(items.first, items.last);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isMoved) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        initCurrentWeek(indexPage);
        final RenderBox renderBoxRed =
            stickyKey.currentContext!.findRenderObject() as RenderBox;
        final height = renderBoxRed.size.height;
        print(height);
      });
      isMoved = true;
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Visibility(
          visible: widget.showHeader,
          child: Container(
            padding: const EdgeInsets.only(left: 10, right: 10),
            color: widget.headerBgColor ?? Colors.white,
            child: Row(
              children: [
                IconButton(
                  style: const ButtonStyle(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () {
                    isFirstLoaded = true;
                    bool isFirstMonthOfYear = widget.currentMonth.month == 1;
                    if (widget.currentMonth.year == widget.minYear &&
                        isFirstMonthOfYear) {
                      return;
                    }
                    var preMonth = DateTime(
                        widget.currentMonth.year, widget.month.month - 1, 1);

                    widget.month = preMonth;
                    widget.currentMonth = preMonth;
                    initCalendar();
                    setState(() {
                      pageController.animateToPage(
                        0,
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeIn,
                      );
                    });
                  },
                  icon: widget.headerArrowLeft ??
                      const Icon(
                        Icons.arrow_left_rounded,
                        color: Colors.grey,
                        size: 35,
                      ),
                ),
                const Spacer(),
                Column(
                  children: [
                    Text(
                      DateFormat(widget.headerDateFormat ?? 'MMM')
                          .format(widget.currentMonth),
                      style: widget.styleHeaderTextTitle ??
                          TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      DateFormat('yyyy').format(DateTime(
                          widget.currentMonth.year,
                          widget.currentMonth.month,
                          widget.currentMonth.day)),
                      style: widget.styleHeaderSubTextTitle ??
                          TextStyle(
                            color: Colors.black45,
                            fontWeight: FontWeight.normal,
                          ),
                    ),
                  ],
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    isFirstLoaded = true;
                    widget.didResult?.call(null, null);
                    bool isLastMonthOfYear = widget.currentMonth.month == 12;
                    if (widget.maxYear == widget.currentMonth.year &&
                        isLastMonthOfYear) {
                      return;
                    }
                    var nextMonth = DateTime(
                        widget.currentMonth.year, widget.month.month + 1, 1);
                    widget.month = nextMonth;
                    widget.currentMonth = nextMonth;
                    initCalendar();
                    setState(() {
                      pageController.animateToPage(
                        0,
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeIn,
                      );
                    });
                  },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: widget.headerArrowRight ??
                      const Icon(
                        Icons.arrow_right_rounded,
                        color: Colors.grey,
                        size: 35,
                      ),
                ),
              ],
            ),
          ),
        ),
        Visibility(
          visible:
              widget.calendarType == FlutterFlexibleCalendarType.horizontal,
          child: Container(
            height: 100,
            color: widget.colorBg ?? Colors.transparent,
            child: PageView.builder(
              controller: pageController,
              onPageChanged: (index) {},
              itemCount: listDayPerMonth.length,
              itemBuilder: (context, pageIndex) {
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(
                    left: 10,
                    right: 10,
                    bottom: 10,
                    top: 10,
                  ),
                  gridDelegate: const FlutterSliverGridDelegate(
                      crossAxisCount: 7, height: 80),
                  itemCount: listDayPerMonth[pageIndex].length,
                  itemBuilder: (context, index) {
                    var day = listDayPerMonth[pageIndex][index];
                    if (widget.showWeekendDay) {
                      if (index < totalWeekdayOfFirstDay - 1 &&
                          pageIndex == 0) {
                        return InkWell(
                          onTap: widget.didWeekendItemClick == null
                              ? null
                              : () {
                                  widget.didWeekendItemClick?.call();
                                },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.only(
                              left: 5,
                              right: 5,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(99),
                              color: widget.bgDayOfWeekend ??
                                  const Color(0x00F4F4F5),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "${day.date}",
                                  style: widget.styleNumberDayOfWeekend ??
                                      const TextStyle(
                                        color: Color(0xFFA1A1AA),
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                      ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 2),
                                  child: Text(
                                    day.nameOffWeek,
                                    style: widget.styleDayOfWeekend ??
                                        const TextStyle(
                                          color: Color(0xFFA1A1AA),
                                          fontSize: 10,
                                          fontWeight: FontWeight.w400,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    }
                    if (widget.disabledPreDay) {
                      if (day.isPreDay) {
                        return InkWell(
                          onTap: widget.didDisableItemClick == null
                              ? null
                              : () {
                                  widget.didDisableItemClick?.call();
                                },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.only(
                              left: 5,
                              right: 5,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(99),
                              color: widget.bgDayOfWeekend ??
                                  const Color(0x00F4F4F5),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "${day.date}",
                                  style: widget.styleNumberDayOfWeekend ??
                                      const TextStyle(
                                        color: Color(0xFFA1A1AA),
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                      ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 2),
                                  child: Text(
                                    day.nameOffWeek,
                                    style: widget.styleDayOfWeekend ??
                                        const TextStyle(
                                          color: Color(0xFFA1A1AA),
                                          fontSize: 10,
                                          fontWeight: FontWeight.w400,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    }
                    return InkWell(
                      borderRadius: const BorderRadius.all(Radius.circular(80)),
                      highlightColor: Colors.black.withAlpha(5),
                      focusColor: Colors.black.withAlpha(5),
                      splashColor: Colors.black.withAlpha(5),
                      onTap: () {
                        isFirstLoaded = false;
                        updateDateOfMonth(
                          day.date,
                          pageIndex,
                          index,
                        );
                        day.dateTime = widget.currentMonth;
                        widget.didResult?.call(day, widget.currentMonth);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(
                          left: 5,
                          right: 5,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(99),
                          color: widget.bgDayOfWeekend ??
                              (day.isSelected == true
                                  ? const Color(0xFFE0F2FE)
                                  : Colors.transparent),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "${day.date}",
                              style: day.isSelected == true
                                  ? widget.styleSelectedText ??
                                      TextStyle(
                                        color: const Color(0xFF0369A1),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      )
                                  : widget.styleNumberDay ??
                                      TextStyle(
                                        color: const Color(0xFF27272A),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: Text(
                                day.nameOffWeek,
                                style: day.isSelected == true
                                    ? widget.styleSelectedSubText ??
                                        TextStyle(
                                          color: const Color(0xFF0369A1),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        )
                                    : widget.styleDay ??
                                        TextStyle(
                                          color: const Color(0xFF52525B),
                                          fontSize: 10,
                                          fontWeight: FontWeight.w400,
                                        ),
                              ),
                            ),
                            Visibility(
                              visible: day.isCurrentDay,
                              child: Container(
                                margin: const EdgeInsets.only(
                                  top: 5,
                                ),
                                width: 5,
                                height: 5,
                                child: CircleAvatar(
                                  backgroundColor:
                                      widget.currentDatePoint ?? Colors.red,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
        Visibility(
          visible: widget.calendarType == FlutterFlexibleCalendarType.standard,
          child: Container(
            color: widget.colorBg ?? Colors.transparent,
            height: listDayPerMonthMerge.length > 35 ? 500 : 430,
            child: PageView.builder(
              controller: pageController,
              onPageChanged: (index) {},
              itemCount: 1,
              itemBuilder: (context, pageIndex) {
                return GridView.builder(
                  key: stickyKey,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(
                    left: 10,
                    right: 10,
                    bottom: 10,
                    top: 10,
                  ),
                  gridDelegate: const FlutterSliverGridDelegate(
                    crossAxisCount: 7,
                    height: 80,
                  ),
                  itemCount: listDayPerMonthMerge.length,
                  itemBuilder: (context, index) {
                    var day = listDayPerMonthMerge[index];
                    if (widget.showWeekendDay) {
                      if (index < totalWeekdayOfFirstDay - 1 && index == 0) {
                        return InkWell(
                          onTap: widget.didWeekendItemClick == null
                              ? null
                              : () {
                                  widget.didWeekendItemClick?.call();
                                },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.only(
                              left: 5,
                              right: 5,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(99),
                              color: widget.bgDayOfWeekend ??
                                  const Color(0x00F4F4F5),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "${day.date}",
                                  style: widget.styleNumberDayOfWeekend ??
                                      const TextStyle(
                                        color: Color(0xFFA1A1AA),
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                      ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 2),
                                  child: Text(
                                    day.nameOffWeek,
                                    style: widget.styleDayOfWeekend ??
                                        const TextStyle(
                                          color: Color(0xFFA1A1AA),
                                          fontSize: 10,
                                          fontWeight: FontWeight.w400,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    }
                    if (widget.disabledPreDay) {
                      if (day.isPreDay) {
                        return InkWell(
                          onTap: widget.didDisableItemClick == null
                              ? null
                              : () {
                                  widget.didDisableItemClick?.call();
                                },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.only(
                              left: 5,
                              right: 5,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(99),
                              color: widget.bgDayOfWeekend ??
                                  const Color(0x00F4F4F5),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "${day.date}",
                                  style: widget.styleNumberDayOfWeekend ??
                                      const TextStyle(
                                        color: Color(0xFFA1A1AA),
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                      ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 2),
                                  child: Text(
                                    day.nameOffWeek,
                                    style: widget.styleDayOfWeekend ??
                                        const TextStyle(
                                          color: Color(0xFFA1A1AA),
                                          fontSize: 10,
                                          fontWeight: FontWeight.w400,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    }
                    return InkWell(
                      borderRadius: const BorderRadius.all(Radius.circular(80)),
                      highlightColor: Colors.black.withAlpha(5),
                      focusColor: Colors.black.withAlpha(5),
                      splashColor: Colors.black.withAlpha(5),
                      onTap: () {
                        isFirstLoaded = false;
                        int indexParent = 0;
                        int indexActive = 0;

                        if (index < 7) {
                          indexParent = 0;
                          indexActive = index - 0;
                        } else if (index >= 7 && index < 7 * 2) {
                          indexParent = 1;
                          indexActive = index - 7 * 1;
                        } else if (index >= 7 * 2 && index < 7 * 3) {
                          indexParent = 2;
                          indexActive = index - 7 * 2;
                        } else if (index >= 7 * 3 && index < 7 * 4) {
                          indexParent = 3;
                          indexActive = index - 7 * 3;
                        } else if (index >= 7 * 4 && index < 7 * 5) {
                          indexParent = 4;
                          indexActive = index - (7 * 4);
                        } else {
                          indexParent = 5;
                          indexActive = index - (7 * 5);
                        }
                        updateDateOfMonth(
                          day.date,
                          indexParent,
                          indexActive,
                        );
                        day.dateTime = widget.currentMonth;
                        widget.didResult?.call(day, widget.currentMonth);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(
                          left: 5,
                          right: 5,
                        ),
                        decoration: day.isSelected
                            ? widget.boxDecorationSelected ??
                                BoxDecoration(
                                    borderRadius: BorderRadius.circular(99),
                                    color: widget.bgDayOfWeekend ??
                                        const Color(0xFFE0F2FE))
                            : BoxDecoration(
                                borderRadius: BorderRadius.circular(99),
                                color: widget.bgDayOfWeekend ??
                                    Colors.transparent),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "${day.date}",
                              style: day.isSelected == true
                                  ? widget.styleSelectedText ??
                                      TextStyle(
                                        color: const Color(0xFF0369A1),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      )
                                  : widget.styleNumberDay ??
                                      TextStyle(
                                        color: const Color(0xFF27272A),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: Text(
                                day.nameOffWeek,
                                style: day.isSelected == true
                                    ? widget.styleSelectedSubText ??
                                        TextStyle(
                                          color: const Color(0xFF0369A1),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        )
                                    : widget.styleDay ??
                                        TextStyle(
                                          color: const Color(0xFF52525B),
                                          fontSize: 10,
                                          fontWeight: FontWeight.w400,
                                        ),
                              ),
                            ),
                            Visibility(
                              visible: day.isCurrentDay,
                              child: Container(
                                margin: const EdgeInsets.only(
                                  top: 5,
                                ),
                                width: 5,
                                height: 5,
                                child: CircleAvatar(
                                  backgroundColor:
                                      widget.currentDatePoint ?? Colors.red,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

extension Range on num {
  bool isBetween(num from, num to) {
    return from <= this && this < to;
  }
}
