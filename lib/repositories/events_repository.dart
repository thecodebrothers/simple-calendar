import 'package:calendar/calendar.dart';

abstract class EventsRepository {
  Map<DateTime, DayWithSingleAndMultipleItems> getCalendarDays();
}

class EventsRepositoryImpl extends EventsRepository {
  @override
  Map<DateTime, DayWithSingleAndMultipleItems> getCalendarDays() {
    final events = getEvents();
    final List<CalendarItemEvent> singleEvents = [];
    final List<CalendarItemEvent> multipleEvents = [];

    for (final element in events) {
      for (final e in events) {
        if (element.id != e.id &&
            element.eventStart.isSameDate(e.eventStart) &&
            (((element.eventStart.isBefore(e.eventStart) ||
                        element.eventStart.isAtSameMomentAs(e.eventStart)) &&
                    element.eventEnd.isAfter(e.eventStart)) ||
                (element.eventStart.isAfter(e.eventStart) &&
                    element.eventStart.isBefore(e.eventEnd)))) {
          multipleEvents.add(e);
        }
      }
    }

    for (final element in events) {
      if (!multipleEvents.contains(element)) {
        singleEvents.add(element);
      }
    }

    final singleEventsWoDuplicates = singleEvents.toSet().toList();
    final multipleEventsWoDuplicates = multipleEvents.toSet().toList();
    multipleEventsWoDuplicates
        .sort((a, b) => a.eventStart.compareTo(b.eventStart));

    Map<DateTime, DayWithSingleAndMultipleItems> datesWithEvents = {};

    for (final element in events) {
      datesWithEvents.addAll({
        element.eventStart.dateOnly():
            DayWithSingleAndMultipleItems(singleEvents: [], multipleEvents: [])
      });
    }

    for (final element in singleEventsWoDuplicates) {
      if (datesWithEvents.containsKey(element.eventStart.dateOnly())) {
        datesWithEvents[element.eventStart.dateOnly()]?.singleEvents.add(
            SingleEvent(
                name: element.name,
                eventStart: element.eventStart.toMinutes(),
                eventEnd: element.eventEnd.toMinutes()));
      }
    }

    for (final element in multipleEventsWoDuplicates) {
      if (datesWithEvents.containsKey(element.eventStart.dateOnly())) {
        datesWithEvents[element.eventStart.dateOnly()]?.multipleEvents.add(
            SingleEvent(
                name: element.name,
                eventStart: element.eventStart.toMinutes(),
                eventEnd: element.eventEnd.toMinutes()));
      }
    }

    return datesWithEvents;
  }

  List<CalendarItemEvent> getEvents() {
    final datesStart = [
      for (int i = 1; i < 15; i++) DateTime(2021, 11, i, i),
      for (int i = 1; i < 15; i++) DateTime(2021, 11, i, i + 1),
      for (int i = 1; i < 15; i++) DateTime(2021, 11, i, i + 2),
      for (int i = 1; i < 15; i++) DateTime(2021, 11, i, i + 3),
    ];

    final calendarItems = [
      for (int i = 0; i < datesStart.length; i++)
        CalendarItemEvent(
            id: i,
            name: "Adam $i Dlugienazwisko $i",
            eventStart: datesStart[i],
            eventEnd: datesStart[i].add(const Duration(hours: 3)))
    ];
    calendarItems.sort((a, b) => a.eventStart.compareTo(b.eventStart));
    return calendarItems;
  }
}
