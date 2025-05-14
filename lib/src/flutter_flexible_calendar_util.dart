import 'package:intl/intl.dart';

enum FlutterFlexibleCalendarType { standard, horizontal }

List<String> getLocalizedDayList(List<String>? days, String locale) {
  // if `days` null, use default list
  List<String> dayLists =
      days ?? ["Mon", "Tue", "Wed", "Thur", "Fri", "Sat", "Sun"];

  // Sets the locale to use
  Intl.defaultLocale = locale;

  // Change the day name using `DateFormat` and adjust the locale
  List<String> localizedDays = dayLists.map((day) {
    // Change day name based on locale
    DateTime date = DateFormat('EEE').parse(day);
    return DateFormat('EEE')
        .format(date); // Full format of day according to locale
  }).toList();

  return localizedDays;
}
