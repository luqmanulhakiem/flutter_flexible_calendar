enum FlutterFlexibleCalendarType { standard, horizontal }

List<String> getLocalizedDayList(String locale) {
  return switch (locale) {
    'id' => ["Sen", "Sel", "Rab", "Kam", "Jum", "Sab", "Min"],
    _ => ["Mon", "Tue", "Wed", "Thur", "Fri", "Sat", "Sun"]
  };
}
