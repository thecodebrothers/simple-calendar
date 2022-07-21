import 'dart:math';

import 'package:simple_calendar/extensions/datetime_extension.dart';
import 'package:simple_calendar/presentation/models/day_with_single_multiple_items.dart';
import 'package:simple_calendar/presentation/models/single_calendar_event.dart';
import 'package:simple_calendar/presentation/models/single_event.dart';
import 'package:simple_calendar/repositories/calendar_events_repository.dart';

class MultipleDaysCalendarGetEventsUseCase {
  final CalendarEventsRepository _calendarRepository;

  MultipleDaysCalendarGetEventsUseCase(
    this._calendarRepository,
  );

  Future<List<DayWithSingleAndMultipleItems>> getMultipleDayEventsSorted(DateTime date, int daysAround) async {
    final List<DateTime> selectedDays = [];
    for (int i = -daysAround; i <= daysAround; i++) {
      selectedDays.add(date.add(Duration(days: i)));
    }

    final stEvents = await _calendarRepository.getEventsForMultipleDays(
      date.add(Duration(days: -daysAround)),
      date.add(Duration(days: daysAround)),
    );
    final allEvents = stEvents
        .map(
          (element) => SingleCalendarEvent(
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
          ),
        )
        .toList();

    final List<DayWithSingleAndMultipleItems> list = [];

    for (final item in selectedDays) {
      final eventsForSelectedDay = allEvents.where((element) => element.eventStart.isSameDate(item));

      final List<List<SingleCalendarEvent>> multipleEvents = [];
      final List<SingleCalendarEvent> allDayEvents = [];

      for (final element in eventsForSelectedDay) {
        if (element.isAllDay) {
          allDayEvents.add(element);
        }
      }

      double startTimeFrame = 0;
      double endTimeFrame = 0;

      final List<SingleCalendarEvent> eventsToSplit =
          eventsForSelectedDay.where((element) => !element.isAllDay).toList();

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

      list.add(
        DayWithSingleAndMultipleItems(
          date: date,
          allDaysEvents: allDayEvents.map((element) => SingleEvent.fromCalendar(element)).toList(),
          multipleEvents:
              multipleEvents.map((element) => element.map((e) => SingleEvent.fromCalendar(e)).toList()).toList(),
        ),
      );
    }
    return list;
  }

  bool eventIsInTimeFrame(double startTimeFrame, double endTimeFrame, SingleCalendarEvent event) {
    final eventStartTimeFrame = event.eventStart.minute + event.eventStart.hour * 60;
    final eventEndTimeFrame = event.eventEnd.minute + event.eventEnd.hour * 60;
    return (eventStartTimeFrame >= startTimeFrame && eventStartTimeFrame <= endTimeFrame ||
        eventEndTimeFrame >= startTimeFrame && eventEndTimeFrame <= endTimeFrame);
  }
}
