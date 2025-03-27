import 'package:collection/collection.dart';
import 'package:simple_calendar/presentation/models/same_start_time_events_container.dart';
import 'package:simple_calendar/presentation/models/single_event.dart';

final _constMapWithFullHours = [
  SameStartEventsGroup(
      events: [], countOfRowsAbove: 0, startTime: DateTime(0, 1, 1, 0, 0)),
  SameStartEventsGroup(
      events: [], countOfRowsAbove: 0, startTime: DateTime(0, 1, 1, 1, 0)),
  SameStartEventsGroup(
      events: [], countOfRowsAbove: 0, startTime: DateTime(0, 1, 1, 2, 0)),
  SameStartEventsGroup(
      events: [], countOfRowsAbove: 0, startTime: DateTime(0, 1, 1, 3, 0)),
  SameStartEventsGroup(
      events: [], countOfRowsAbove: 0, startTime: DateTime(0, 1, 1, 4, 0)),
  SameStartEventsGroup(
      events: [], countOfRowsAbove: 0, startTime: DateTime(0, 1, 1, 5, 0)),
  SameStartEventsGroup(
      events: [], countOfRowsAbove: 0, startTime: DateTime(0, 1, 1, 6, 0)),
  SameStartEventsGroup(
      events: [], countOfRowsAbove: 0, startTime: DateTime(0, 1, 1, 7, 0)),
  SameStartEventsGroup(
      events: [], countOfRowsAbove: 0, startTime: DateTime(0, 1, 1, 8, 0)),
  SameStartEventsGroup(
      events: [], countOfRowsAbove: 0, startTime: DateTime(0, 1, 1, 9, 0)),
  SameStartEventsGroup(
      events: [], countOfRowsAbove: 0, startTime: DateTime(0, 1, 1, 10, 0)),
  SameStartEventsGroup(
      events: [], countOfRowsAbove: 0, startTime: DateTime(0, 1, 1, 11, 0)),
  SameStartEventsGroup(
      events: [], countOfRowsAbove: 0, startTime: DateTime(0, 1, 1, 12, 0)),
  SameStartEventsGroup(
      events: [], countOfRowsAbove: 0, startTime: DateTime(0, 1, 1, 13, 0)),
  SameStartEventsGroup(
      events: [], countOfRowsAbove: 0, startTime: DateTime(0, 1, 1, 14, 0)),
  SameStartEventsGroup(
      events: [], countOfRowsAbove: 0, startTime: DateTime(0, 1, 1, 15, 0)),
  SameStartEventsGroup(
      events: [], countOfRowsAbove: 0, startTime: DateTime(0, 1, 1, 16, 0)),
  SameStartEventsGroup(
      events: [], countOfRowsAbove: 0, startTime: DateTime(0, 1, 1, 17, 0)),
  SameStartEventsGroup(
      events: [], countOfRowsAbove: 0, startTime: DateTime(0, 1, 1, 18, 0)),
  SameStartEventsGroup(
      events: [], countOfRowsAbove: 0, startTime: DateTime(0, 1, 1, 19, 0)),
  SameStartEventsGroup(
      events: [], countOfRowsAbove: 0, startTime: DateTime(0, 1, 1, 20, 0)),
  SameStartEventsGroup(
      events: [], countOfRowsAbove: 0, startTime: DateTime(0, 1, 1, 21, 0)),
  SameStartEventsGroup(
      events: [], countOfRowsAbove: 0, startTime: DateTime(0, 1, 1, 22, 0)),
  SameStartEventsGroup(
    events: [],
    countOfRowsAbove: 0,
    startTime: DateTime(0, 1, 1, 23, 0),
  ),
];

class GroupEventsByStartTimeUseCase {
  List<SameStartEventsGroup> call(List<List<SingleEvent>> events) {
    final List<SameStartEventsGroup> groupedEvents = _constMapWithFullHours;

    for (final List<SingleEvent> group in events) {
      for (final SingleEvent singleEvent in group) {
        final int eventStart = singleEvent.eventStart;
        final DateTime eventStartHour = DateTime(
          0,
          1,
          1,
          eventStart ~/ 60,
          eventStart % 60,
        );
        final sameTimeGroup = groupedEvents
            .firstWhereOrNull((element) => element.startTime == eventStartHour);
        if (sameTimeGroup != null) {
          final List<SingleEvent> events = sameTimeGroup.events;
          events.add(singleEvent);
          groupedEvents.remove(sameTimeGroup);
          groupedEvents.add(SameStartEventsGroup(
            events: events,
            countOfRowsAbove: sameTimeGroup.countOfRowsAbove,
            startTime: eventStartHour,
          ));
        } else {
          groupedEvents.add(SameStartEventsGroup(
            events: [singleEvent],
            countOfRowsAbove: 0,
            startTime: eventStartHour,
          ));
        }
      }
    }

    return _calculateCollectiveDistancesFromStart(groupedEvents);
  }

  List<SameStartEventsGroup> _calculateCollectiveDistancesFromStart(
      List<SameStartEventsGroup> groupedEvents) {
    final sortedEntriesByTime = groupedEvents
      ..sort((a, b) => a.startTime.compareTo(b.startTime));

    int countOfRowsAbove = 0;

    List<SameStartEventsGroup> newGroupedEvents = [];

    for (final item in sortedEntriesByTime) {
      newGroupedEvents.add(SameStartEventsGroup(
        events: item.events,
        countOfRowsAbove: countOfRowsAbove,
        startTime: item.startTime,
      ));

      countOfRowsAbove += item.events.length < 2 ? 1 : item.events.length;
    }

    return newGroupedEvents;
  }
}
