import 'dart:math';

import 'package:simple_calendar/extensions/datetime_extension.dart';
import 'package:simple_calendar/presentation/models/day_with_single_multiple_items.dart';
import 'package:simple_calendar/presentation/models/single_calendar_event_internal.dart';
import 'package:simple_calendar/presentation/models/single_event.dart';
import 'package:simple_calendar/repositories/calendar_events_repository.dart';

class MultipleDaysCalendarGetEventsUseCase {
  final CalendarEventsRepository _calendarRepository;

  MultipleDaysCalendarGetEventsUseCase(
    this._calendarRepository,
  );

  Future<List<DayWithSingleAndMultipleItems>> getMultipleDayEventsSorted(
    DateTime date,
    int daysAround,
    double? minimumEventHeight,
  ) async {
    final List<DateTime> selectedDays = [];
    for (int i = -daysAround; i <= daysAround; i++) {
      selectedDays.add(date.add(Duration(days: i)));
    }

    final stEvents = await _calendarRepository.getEventsForMultipleDays(
      date.add(Duration(days: -daysAround)),
      date.add(Duration(days: daysAround)),
    );

    final allEvents = stEvents.map((element) {
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
        eventStart: element.eventStart,
        id: element.id,
        isAllDay: element.isAllDay,
        networkIconName: element.networkIconName,
        localIconName: element.localIconName,
        iconBackgroundColor: element.iconBackgroundColor,
        object: element.object,
        dotTileColor: element.dotTileColor,
        tileBackgroundColor: element.tileBackgroundColor,
        imageHeaders: element.imageHeaders,
        eventHeightThreshold: eventHeightThreshold ??
            element.eventEnd.minute + element.eventEnd.hour * 60,
      );
    }).toList();

    final List<DayWithSingleAndMultipleItems> list = [];

    for (final item in selectedDays) {
      final eventsForSelectedDay =
          allEvents.where((element) => element.eventStart.isSameDate(item));

      final List<List<SingleCalendarEventInternal>> multipleEvents = [];
      final List<SingleCalendarEventInternal> allDayEvents = [];

      for (final element in eventsForSelectedDay) {
        if (element.isAllDay) {
          allDayEvents.add(element);
        }
      }

      double startTimeFrame = 0;
      double endTimeFrame = 0;

      final List<SingleCalendarEventInternal> eventsToSplit =
          eventsForSelectedDay.where((element) => !element.isAllDay).toList();

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
          endTimeFrame =
              tmpEvents.map((e) => e.eventHeightThreshold).reduce(max);
          for (final item in tmpEvents) {
            eventsToSplit.remove(item);
          }
        }
        tmpEvents.add(firstEvent);
        if (tmpEvents.isNotEmpty) {
          multipleEvents.add(tmpEvents);
        }
      }

      list.add(
        DayWithSingleAndMultipleItems(
          date: item,
          allDaysEvents: allDayEvents
              .map((element) => SingleEvent.fromCalendar(element))
              .toList(),
          multipleEvents: multipleEvents
              .map((element) =>
                  element.map((e) => SingleEvent.fromCalendar(e)).toList())
              .toList(),
        ),
      );
    }
    return list;
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
