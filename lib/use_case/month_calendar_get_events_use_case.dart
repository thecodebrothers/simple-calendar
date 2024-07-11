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
    final endOfCurrentMonth = DateTime(date.year, date.month + 1, 0);
    final daysBetween = startOfCurrentMonth.calculateDaysBetween(endOfCurrentMonth);
    final polandUtcDateTime = DateTime(
      startOfCurrentMonth.year,
      startOfCurrentMonth.month,
      startOfCurrentMonth.day,
      startOfCurrentMonth.hour + 2,
    ).toUtc();

    final events = await _calendarRepository.getEventsForMultipleDays(
      startOfCurrentMonth,
      endOfCurrentMonth,
    );

    for (var i = -weekdayOfFirstDay + 1; i <= daysBetween; i++) {
      days.add(polandUtcDateTime.add(Duration(days: i)));
    }

    final readyDates = days.map((e) {
      final dayEvents = _getEventsForDay(e, events);
      return MonthSingleDayItem(
        date: e,
        events: dayEvents,
        isDayName: false,
      );
    }).toList();

    readyDates.insertAll(
      0,
      days.sublist(0, 7).map((e) => MonthSingleDayItem(
        date: e,
        events: [],
        isDayName: true,
      )),
    );

    return readyDates;
  }

  List<SingleCalendarEvent> _getEventsForDay(DateTime date, List<SingleCalendarEvent> events) {
    return events.where((event) {
      return (event.eventStart.isSameDate(date) || event.eventStart.isBefore(date)) &&
          (event.eventEnd.isSameDate(date) || event.eventEnd.isAfter(date));
    }).toList();
  }
}