import 'package:example/models/event_item.dart';
import 'package:simple_calendar/extensions/datetime_extension.dart';
import 'package:simple_calendar/simple_calendar.dart';

class MockEventsService {
  MockEventsService({this.fetchDelay}) {
    _today = DateTime.now().dateOnly();
    _tomorrow = _today.add(const Duration(days: 1));
    _yesterday = _today.subtract(const Duration(days: 1));

    _createMockEvents();
  }
  late DateTime _today;
  late DateTime _tomorrow;
  late DateTime _yesterday;

  Duration? fetchDelay;

  final List<EventItem> _events = [];

  Future<List<EventItem>> getEventsForDay(DateTime date) async {
    if (fetchDelay != null) {
      await Future.delayed(fetchDelay!);
    }

    return _events
        .where((element) =>
            element.eventStart.isAfter(date.dateOnly()) &&
            element.eventStart
                .isBefore(date.dateOnly().add(const Duration(days: 1))))
        .toList();
  }

  Future<List<EventItem>> getEventsForMultipleDays(
      DateTime fromDate, DateTime toDate) async {
    if (fetchDelay != null) {
      await Future.delayed(fetchDelay!);
    }

    final fixedFromDate = fromDate.dateOnly();
    final fixedToDate = toDate.dateOnly().add(Duration(hours: 23, minutes: 59));

    final sortedEvents = _events
        .where((element) =>
            element.eventStart.isAfter(fixedFromDate) &&
            element.eventStart.isBefore(fixedToDate))
        .toList();
    sortedEvents.sort((a, b) => a.eventStart.compareTo(b.eventStart));
    return sortedEvents;
  }

  void _createMockEvents() {
    final todayEvent1 = EventItem(
        id: 1,
        name: 'Event 1',
        eventStart: _today.add(Duration(hours: 1)),
        eventEnd: _today.add(Duration(hours: 5)),
        isAllDay: true);

    final todayEvent2 = EventItem(
        id: 2,
        name: 'Event 2',
        eventStart: _today.add(Duration(hours: 0)),
        eventEnd: _today.add(Duration(hours: 23)),
        isAllDay: true);

    final yesterdayEvent1 = EventItem(
        id: 3,
        name: 'Event 3',
        eventStart: _yesterday.add(Duration(hours: 4)),
        eventEnd: _yesterday.add(Duration(hours: 8)),
        isAllDay: true);

    final yesterdayEvent2 = EventItem(
        id: 4,
        name: 'Event 4',
        eventStart: _yesterday.add(Duration(hours: 4)),
        eventEnd: _yesterday.add(Duration(hours: 8)),
        isAllDay: true);

    final tomorrowEvent1 = EventItem(
        id: 5,
        name: 'Event 5',
        eventStart: _tomorrow.add(Duration(hours: 4)),
        eventEnd: _tomorrow.add(Duration(hours: 8)),
        isAllDay: false);
    final tomorrowEvent2 = EventItem(
        id: 5,
        name: 'Event 5',
        eventStart: _tomorrow.add(Duration(hours: 2)),
        eventEnd: _tomorrow.add(Duration(minutes: 250)),
        isAllDay: false);

    _events.addAll([
      todayEvent1,
      todayEvent2,
      yesterdayEvent1,
      yesterdayEvent2,
      tomorrowEvent1,
      tomorrowEvent2,
    ]);
  }
}
