import 'dart:math';

import 'package:simple_calendar/extensions/datetime_extension.dart';
import 'package:simple_calendar/presentation/models/day_with_single_multiple_items.dart';
import 'package:simple_calendar/presentation/models/single_calendar_event.dart';
import 'package:simple_calendar/presentation/models/single_event.dart';
import 'package:simple_calendar/repositories/calendar_events_repository.dart';

class OneDayCalendarGetEventsUseCase {
  final CalendarEventsRepository _calendarRepository;

  OneDayCalendarGetEventsUseCase(this._calendarRepository);

  Future<DayWithSingleAndMultipleItems> getOneDayEventsSorted(DateTime date) async {
    final stEvents = await _calendarRepository.getEventsForDay(date);
    final events = stEvents
        .map(
          (element) => SingleCalendarEvent(
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
            imageHeaders: element.imageHeaders
          ),
        )
        .toList();

    final List<List<SingleCalendarEvent>> multipleEvents = [];
    final List<SingleCalendarEvent> allDayEvents = [];

    for (final element in events) {
      if (element.isAllDay) {
        allDayEvents.add(element);
      }
    }

    double startTimeFrame = 0;
    double endTimeFrame = 0;

    final List<SingleCalendarEvent> eventsToSplit = events.where((element) => !element.isAllDay).toList();

    while (eventsToSplit.isNotEmpty) {
      SingleCalendarEvent firstEvent = eventsToSplit.first;
      startTimeFrame = firstEvent.eventStart.minute + firstEvent.eventStart.hour * 60;
      endTimeFrame = firstEvent.eventEnd.minute + firstEvent.eventEnd.hour * 60;
      eventsToSplit.remove(firstEvent);

      List<SingleCalendarEvent> tmpEvents = [];

      while (eventsToSplit.where((element) => eventIsInTimeFrame(startTimeFrame, endTimeFrame, element)).isNotEmpty) {
        for (final element in eventsToSplit) {
          if (eventIsInTimeFrame(startTimeFrame, endTimeFrame, element)) {
            tmpEvents.add(element);
          }
        }
        startTimeFrame = tmpEvents.map((e) => e.eventStart.minute + e.eventStart.hour * 60.0).reduce(min);
        endTimeFrame = tmpEvents.map((e) => e.eventEnd.minute + e.eventEnd.hour * 60.0).reduce(max);
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
      allDaysEvents: allDayEvents.map((element) => SingleEvent.fromCalendar(element)).toList(),
      multipleEvents:
          multipleEvents.map((element) => element.map((e) => SingleEvent.fromCalendar(e)).toList()).toList(),
    );
  }

  bool eventIsInTimeFrame(double startTimeFrame, double endTimeFrame, SingleCalendarEvent event) {
    final eventStartTimeFrame = event.eventStart.minute + event.eventStart.hour * 60;
    final eventEndTimeFrame = event.eventEnd.minute + event.eventEnd.hour * 60;
    return (eventStartTimeFrame >= startTimeFrame && eventStartTimeFrame <= endTimeFrame ||
        eventEndTimeFrame >= startTimeFrame && eventEndTimeFrame <= endTimeFrame);
  }
}
