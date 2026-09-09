import 'package:collection/collection.dart';
import 'package:simple_calendar/presentation/models/same_start_time_events_container.dart';
import 'package:simple_calendar/presentation/models/single_event.dart';

class GroupEventsByStartTimeUseCase {
  List<SameStartEventsGroup> call(List<List<SingleEvent>> events) {
    final List<SameStartEventsGroup> groupedEvents =
        _constMapWithFullHours.toList();

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
          final List<SingleEvent> events = sameTimeGroup.events.toList();
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
    final sortedEntriesByTime = groupedEvents.toList()
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

  List<SameStartEventsGroup> get _constMapWithFullHours {
    final List<SameStartEventsGroup> groupedEvents = [];
    for (int i = 0; i < 24; i++) {
      groupedEvents.add(SameStartEventsGroup(
        events: [],
        countOfRowsAbove: 0,
        startTime: DateTime(0, 1, 1, i, 0),
      ));
    }
    return groupedEvents;
  }
}
