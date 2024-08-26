import 'dart:ui';

import 'package:simple_calendar/presentation/models/month_single_day_item.dart';
import 'package:simple_calendar/presentation/models/single_calendar_event.dart';
import 'package:simple_calendar/repositories/calendar_events_repository.dart';
import 'package:simple_calendar/extensions/datetime_extension.dart';

class MonthCalendarGetEventsUseCase {
  final CalendarEventsRepository _calendarRepository;

  MonthCalendarGetEventsUseCase(this._calendarRepository);

  Future<List<MonthSingleDayItem>> getItems(DateTime date) async {
    final List<DateTime> days = [];

    final startOfCurrentMonth = DateTime(date.year, date.month);
    final weekdayOfFirstDay = startOfCurrentMonth.weekday;
    final endOfCurrentMonth = DateTime(date.year, date.month + 1);

    var daysBetween =
        startOfCurrentMonth.calculateDaysBetween(endOfCurrentMonth);

    final isFirstDayOfNewMonthMonday = endOfCurrentMonth.weekday == 1;

    if (!isFirstDayOfNewMonthMonday) {
      final diff = DateTime.sunday - endOfCurrentMonth.weekday;
      for (var i = 0; i <= diff; i++) {
        daysBetween++;
      }
    }

    final polandUtcDateTime = DateTime(
      startOfCurrentMonth.year,
      startOfCurrentMonth.month,
      startOfCurrentMonth.day,
      startOfCurrentMonth.hour + 2,
    ).toUtc();

    final events = await _calendarRepository.getEventsForMultipleDays(
        startOfCurrentMonth, endOfCurrentMonth);

    for (var i = -weekdayOfFirstDay + 1; i < daysBetween; i++) {
      days.add(polandUtcDateTime.add(Duration(days: i)));
    }

    final readyDates = days
        .map(
          (e) => MonthSingleDayItem(
            date: e,
            hasAnyEvents: _hasAnyEvents(e, events),
            eventColors: _getEventColors(e, events),
            isDayName: false,
          ),
        )
        .toList();

    readyDates.insertAll(
      0,
      days.sublist(0, 7).map((e) {
        return MonthSingleDayItem(
          date: e,
          hasAnyEvents: _hasAnyEvents(e, events),
          isDayName: true,
        );
      }),
    );

    return readyDates;
  }

  bool _hasAnyEvents(DateTime date, List<SingleCalendarEvent> events) {
    return events
        .where((element) => element.eventStart.isSameDate(date))
        .isNotEmpty;
  }

  List<Color> _getEventColors(DateTime date, List<SingleCalendarEvent> events) {
    return events
        .where((e) => e.eventStart.isSameDate(date))
        .map((e) => e.dotTileColor)
        .toList();
  }
}
