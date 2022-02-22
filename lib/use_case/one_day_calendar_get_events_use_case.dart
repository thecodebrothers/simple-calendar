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
            eventStart: element.eventStart,
            id: element.id,
            isAllDay: element.isAllDay,
            localIconName: element.localIconName,
            networkIconName: element.networkIconName,
            iconBackgroundColor: element.iconBackgroundColor,
          ),
        )
        .toList();

    final List<SingleCalendarEvent> singleEvents = [];
    final List<SingleCalendarEvent> multipleEvents = [];
    final List<SingleCalendarEvent> allDayEvents = [];

    for (final element in events) {
      if (element.isAllDay) {
        allDayEvents.add(element);
      }
    }

    for (final element in events) {
      for (final e in events) {
        if (!allDayEvents.contains(element) &&
            element.id != e.id &&
            element.eventStart.isSameDate(e.eventStart) &&
            (((element.eventStart.isBefore(e.eventStart) || element.eventStart.isAtSameMomentAs(e.eventStart)) &&
                    element.eventEnd.isAfter(e.eventStart)) ||
                (element.eventStart.isAfter(e.eventStart) && element.eventStart.isBefore(e.eventEnd)))) {
          multipleEvents.add(e);
        }
      }
    }

    for (final element in events) {
      if (!multipleEvents.contains(element) && !allDayEvents.contains(element)) {
        singleEvents.add(element);
      }
    }

    final singleEventsWoDuplicates = singleEvents.where((element) => !element.isAllDay).toSet().toList();
    final multipleEventsWoDuplicates = multipleEvents.where((element) => !element.isAllDay).toSet().toList();
    multipleEventsWoDuplicates.sort((a, b) => a.eventStart.compareTo(b.eventStart));

    return DayWithSingleAndMultipleItems(
      date: date,
      allDaysEvents: allDayEvents.map((element) => SingleEvent.fromCalendar(element)).toList(),
      multipleEvents: multipleEventsWoDuplicates.map((element) => SingleEvent.fromCalendar(element)).toList(),
      singleEvents: singleEventsWoDuplicates.map((element) => SingleEvent.fromCalendar(element)).toList(),
    );
  }
}
