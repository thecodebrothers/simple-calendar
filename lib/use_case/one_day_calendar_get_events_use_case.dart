import 'dart:math';

import 'package:simple_calendar/presentation/models/day_with_single_multiple_items.dart';
import 'package:simple_calendar/presentation/models/single_calendar_event_internal.dart';
import 'package:simple_calendar/presentation/models/single_event.dart';
import 'package:simple_calendar/repositories/calendar_events_repository.dart';

class OneDayCalendarGetEventsUseCase {
  final CalendarEventsRepository _calendarRepository;

  OneDayCalendarGetEventsUseCase(this._calendarRepository);

  Future<DayWithSingleAndMultipleItems> getOneDayEventsSorted(
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
      );
    }).toList();

    final List<List<SingleCalendarEventInternal>> multipleEvents = [];
    final List<SingleCalendarEventInternal> allDayEvents = [];

    for (final element in events) {
      if (element.isAllDay) {
        allDayEvents.add(element);
      }
    }

    double startTimeFrame = 0;
    double endTimeFrame = 0;

    final List<SingleCalendarEventInternal> eventsToSplit =
        events.where((element) => !element.isAllDay).toList();

    while (eventsToSplit.isNotEmpty) {
      SingleCalendarEventInternal firstEvent = eventsToSplit.first;
      startTimeFrame =
          firstEvent.eventStart.minute + firstEvent.eventStart.hour * 60;
      endTimeFrame = firstEvent.eventHeightThreshold;
      eventsToSplit.remove(firstEvent);

      List<SingleCalendarEventInternal> tmpEvents = [];

      while (eventsToSplit
          .where((element) =>
              eventIsInTimeFrame(startTimeFrame, endTimeFrame, element))
          .isNotEmpty) {
        for (final element in eventsToSplit) {
          if (eventIsInTimeFrame(startTimeFrame, endTimeFrame, element)) {
            tmpEvents.add(element);
          }
        }
        startTimeFrame = tmpEvents
            .map((e) => e.eventStart.minute + e.eventStart.hour * 60.0)
            .reduce(min);

        endTimeFrame = tmpEvents.map((e) => e.eventHeightThreshold).reduce(max);
        for (final item in tmpEvents) {
          eventsToSplit.remove(item);
        }
      }
      tmpEvents.add(firstEvent);
      if (tmpEvents.isNotEmpty) {
        multipleEvents.add(tmpEvents);
      }
    }

    return DayWithSingleAndMultipleItems(
      date: date,
      allDaysEvents: allDayEvents
          .map((element) => SingleEvent.fromCalendar(element))
          .toList(),
      multipleEvents: multipleEvents
          .map((element) =>
              element.map((e) => SingleEvent.fromCalendar(e)).toList())
          .toList(),
    );
  }

  bool eventIsInTimeFrame(double startTimeFrame, double endTimeFrame,
      SingleCalendarEventInternal event) {
    final eventStartTimeFrame =
        event.eventStart.minute + event.eventStart.hour * 60;
    final eventEndTimeFrame = event.eventHeightThreshold;
    if (eventEndTimeFrame == startTimeFrame ||
        eventStartTimeFrame == endTimeFrame) {
      return false;
    }
    return (eventStartTimeFrame >= startTimeFrame &&
            eventStartTimeFrame <= endTimeFrame ||
        eventEndTimeFrame >= startTimeFrame &&
            eventEndTimeFrame <= endTimeFrame);
  }
}
