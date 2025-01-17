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
    final endOfCurrentMonth = DateTime(date.year, date.month + 1, 0);

    final weekdayOfFirstDay = startOfCurrentMonth.weekday;
    final startOfWeek =
        startOfCurrentMonth.subtract(Duration(days: weekdayOfFirstDay - 1));

    final endOfWeek =
        endOfCurrentMonth.add(Duration(days: 7 - endOfCurrentMonth.weekday));

    final polandUtcDateTime = DateTime(
      startOfWeek.year,
      startOfWeek.month,
      startOfWeek.day,
      startOfWeek.hour + 2,
    ).toUtc();

    final events = await _calendarRepository.getEventsForMultipleDays(
      startOfWeek,
      endOfWeek,
    );

    for (var i = 0; i <= endOfWeek.difference(startOfWeek).inDays; i++) {
      final currentDate = polandUtcDateTime.add(Duration(days: i));
      days.add(currentDate);
    }

    final readyDates = days.map((e) {
      final dayEvents = _getEventsForDay(e, events);
      return MonthSingleDayItem(
        date: e,
        events: dayEvents,
        isDayName: false,
      );
    }).toList();

    return readyDates;
  }

  List<SingleCalendarEvent> _getEventsForDay(
      DateTime date, List<SingleCalendarEvent> events) {
    return events.where((event) {
      return (event.eventStart.isSameDate(date) ||
              event.eventStart.isBefore(date)) &&
          (event.eventEnd.isSameDate(date) || event.eventEnd.isAfter(date));
    }).toList();
  }
}
