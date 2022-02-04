extension DateOnlyCompare on DateTime {
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}

extension DateOnly on DateTime {
  DateTime dateOnly() {
    return DateTime(year, month, day);
  }
}

extension TimeInMinutes on DateTime {
  int toMinutes() {
    return hour * 60 + minute;
  }
}
