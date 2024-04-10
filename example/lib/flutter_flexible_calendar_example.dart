import 'package:flutter/material.dart';
import 'package:flutter_flexible_calendar/flutter_flexible_calendar.dart';

class FlutterFlexibleCalendarExample extends StatelessWidget {
  final DateTime _currentMonth = DateTime.now();
  FlutterFlexibleCalendarExample({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Expanded(
          child: FlutterFlexibleCalendarView(
            showHeader: true,
            headerBgColor: Colors.white38,
            calendarType: FlutterFlexibleCalendarType.standard,
            // currentDatePoint: Colors.blue,
            // styleHeaderTextTitle: TextStyle(
            //   color: Colors.red,
            // ),
            // styleHeaderSubTextTitle: TextStyle(
            //   color: Colors.orange,
            // ),
            // styleSelectedText: TextStyle(
            //   color: Colors.red,
            //   fontSize: 18,
            // ),
            // styleSelectedSubText: TextStyle(
            //   color: Colors.blue,
            // ),
            //headerArrowLeft: Icon(Icons.skip_previous),
            //headerArrowRight: Icon(Icons.skip_next),
            showWeekendDay: false,
            disabledPreDay: true,
            colorBg: Colors.transparent,
            maxLimitYear: 2,
            minLimitYear: 2,
            month: DateTime(_currentMonth.year,
                FlutterFlexibleCalendarView.setDefaultMonth(month: 1), 1),
            currentMonth: DateTime(_currentMonth.year,
                FlutterFlexibleCalendarView.setDefaultMonth(month: 1), 1),
            didResult: (item, datetime) {
              print("itme: ${item?.date}");
              print("itme: ${item?.dateTime}");
              print("itme: ${item?.nameOffWeek}");
              print("date: ${datetime?.day}");
              print("date: ${datetime?.month}");
              print("date: ${datetime?.year}");
              //customDateTimeModel = item;
              //getItemSelected();
            },
          ),
        ),
      ),
    );
  }
}
