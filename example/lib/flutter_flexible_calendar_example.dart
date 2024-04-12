import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flexible_calendar/flutter_flexible_calendar.dart';

class FlutterFlexibleCalendarExample extends StatelessWidget {
  final DateTime _currentMonth = DateTime.now();
  FlutterFlexibleCalendarExample({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Flexible Calendar",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: FlutterFlexibleCalendarView(
          showHeader: true,
          headerBgColor: Colors.white38,
          calendarType: FlutterFlexibleCalendarType.standard,
          showWeekendDay: false,
          disabledPreDay: true,
          colorBg: Colors.transparent,
          maxLimitYear: 2,
          minLimitYear: 2,
          isMultipleSelected: true,
          currentSelected: DateTime(2024, 4, 24),
          setStartSelected: DateTime(2024, 4, 13),
          setEndSelected: DateTime(2024, 4, 19),
          month: DateTime(_currentMonth.year, _currentMonth.month, 1),
          didResult: (item, datetime) {
            if (kDebugMode) {
              print(
                  "date selected: ${item?.date}, ${item?.dateTime}, ${item?.nameOffWeek}");
            }
          },
          didMultipleSelected: (firstDate, lastDate) {
            if (kDebugMode) {
              print(
                  "firstDate: ${firstDate?.date}, ${firstDate?.dateTime}, ${firstDate?.nameOffWeek}");
              print(
                  "lastDate: ${lastDate?.date}, ${lastDate?.dateTime}, ${lastDate?.nameOffWeek}");
            }
          },
          didDisableItemClick: () {},
          didWeekendItemClick: () {},
        ),
      ),
    );
  }
}
