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
        child: Expanded(
          child: FlutterFlexibleCalendarView(
            showHeader: true,
            headerBgColor: Colors.white38,
            calendarType: FlutterFlexibleCalendarType.horizontal,
            showWeekendDay: false,
            disabledPreDay: true,
            colorBg: Colors.transparent,
            maxLimitYear: 2,
            minLimitYear: 2,
            month: DateTime(_currentMonth.year, _currentMonth.month, 1),
            didResult: (item, datetime) {
              print("itme: ${item?.date}");
              print("itme: ${item?.dateTime}");
              print("itme: ${item?.nameOffWeek}");
              print("date: ${datetime?.day}");
              print("date: ${datetime?.month}");
              print("date: ${datetime?.year}");
            },
            didDisableItemClick: () {},
            didWeekendItemClick: () {},
          ),
        ),
      ),
    );
  }
}
