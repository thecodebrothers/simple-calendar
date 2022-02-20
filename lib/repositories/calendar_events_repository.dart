import 'package:simple_calendar/presentation/models/single_calendar_event.dart';

abstract class CalendarEventsRepository {
  Future<List<SingleCalendarEvent>> getEventsForDay(DateTime date);

  Future<List<SingleCalendarEvent>> getEventsForMultipleDays(DateTime fromDate, DateTime toDate);
}