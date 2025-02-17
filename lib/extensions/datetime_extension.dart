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

extension MonthCompare on DateTime {
  bool isSameMonth(DateTime date) {
    return date.month == month;
  }
}

extension CalculateDaysBetween on DateTime {
  int calculateDaysBetween(DateTime to) {
    final newTo = DateTime(to.year, to.month, to.day);
    return (newTo.difference(this).inHours / 24).round();
  }

  int getDayDifference(DateTime date) => DateTime.utc(year, month, day)
      .difference(DateTime.utc(date.year, date.month, date.day))
      .inDays
      .abs();
}
