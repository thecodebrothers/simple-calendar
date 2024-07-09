import 'package:simple_calendar/presentation/models/single_calendar_event_internal.dart';
import 'package:simple_calendar/presentation/models/single_day_items.dart';
import 'package:simple_calendar/presentation/models/single_event.dart';
import 'package:simple_calendar/repositories/calendar_events_repository.dart';

class OneDayCalendarGetEventsUseCase {
  final CalendarEventsRepository _calendarRepository;

  OneDayCalendarGetEventsUseCase(this._calendarRepository);

  Future<SingleDayItems> getOneDayEventsSorted(
    DateTime date,
    double? minimumEventHeight,
  ) async {
    final stEvents = await _calendarRepository.getEventsForDay(date);
    final events = stEvents.map((element) {
      double? eventHeightThreshold;
      if (minimumEventHeight != null) {
        if (element.eventEnd.difference(element.eventStart).inMinutes <
            minimumEventHeight) {
          final eventHeightThresholdDateTime = element.eventStart
              .add(Duration(minutes: minimumEventHeight.toInt()));
          eventHeightThreshold = eventHeightThresholdDateTime.minute +
              eventHeightThresholdDateTime.hour * 60;
        }
      }
      return SingleCalendarEventInternal(
        singleLine: element.singleLine,
        eventEnd: element.eventEnd,
        secondLine: element.secondLine,
        eventStart: element.eventStart,
        id: element.id,
        isAllDay: element.isAllDay,
        localIconName: element.localIconName,
        networkIconName: element.networkIconName,
        iconBackgroundColor: element.iconBackgroundColor,
        object: element.object,
        dotTileColor: element.dotTileColor,
        tileBackgroundColor: element.tileBackgroundColor,
        imageHeaders: element.imageHeaders,
        eventHeightThreshold: eventHeightThreshold ??
            element.eventEnd.minute + element.eventEnd.hour * 60,
        topLeftLine: element.topLeftLine,
        bottomRightLine: element.bottomRightLine,
        groupId: element.groupId,
        groupOrder: element.groupOrder,
        groupColor: element.groupColor,
      );
    }).toList();

    final Map<String?, List<SingleCalendarEventInternal>> groupedEvents = {};
    for (final event in events) {
      final groupId = event.groupId ?? 'null';
      if (!groupedEvents.containsKey(groupId)) {
        groupedEvents[groupId] = [];
      }
      groupedEvents[groupId]!.add(event);
    }

    final sortedGroupKeys = groupedEvents.keys.toList()
      ..sort((a, b) {
        if (a == 'null' && b == 'null') return 0;
        if (a == 'null') return 1;
        if (b == 'null') return -1;

        final groupA = groupedEvents[a]!.first.groupOrder;
        final groupB = groupedEvents[b]!.first.groupOrder;

        if (groupA == null && groupB == null) return 0;
        if (groupA == null) return 1;
        if (groupB == null) return -1;

        return groupA.compareTo(groupB);
      });

    final List<List<SingleCalendarEventInternal>> multipleGroupedEvents = [];
    final List<SingleCalendarEventInternal> allDayEvents = [];

    for (final element in events) {
      if (element.isAllDay) {
        allDayEvents.add(element);
      }
    }

    for (final groupKey in sortedGroupKeys) {
      final List<SingleCalendarEventInternal> groupEvents =
          groupedEvents[groupKey]!;
      multipleGroupedEvents.add(groupEvents);
    }

    return SingleDayItems(
      date: date,
      allDaysEvents: allDayEvents
          .map((element) => SingleEvent.fromCalendar(element))
          .toList(),
      multipleGroupedEvents: multipleGroupedEvents
          .map(
              (group) => group.map((e) => SingleEvent.fromCalendar(e)).toList())
          .toList(),
    );
  }

  bool eventIsInTimeFrame(double startTimeFrame, double endTimeFrame,
      SingleCalendarEventInternal event) {
    final eventStart = event.eventStart.minute + event.eventStart.hour * 60.0;
    final eventEnd = event.eventHeightThreshold;
    return (eventStart >= startTimeFrame && eventStart < endTimeFrame) ||
        (eventEnd > startTimeFrame && eventEnd <= endTimeFrame) ||
        (eventStart <= startTimeFrame && eventEnd >= endTimeFrame);
  }
}
