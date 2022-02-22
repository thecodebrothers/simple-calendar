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
          ),
        )
        .toList();

    final List<DayWithSingleAndMultipleItems> list = [];

    for (final item in selectedDays) {
      final eventsForSelectedDay = allEvents.where((element) => element.eventStart.isSameDate(item));
      final List<SingleCalendarEvent> singleEvents = [];
      final List<SingleCalendarEvent> multipleEvents = [];
      final List<SingleCalendarEvent> allDayEvents = [];

      for (final element in eventsForSelectedDay) {
        if (element.isAllDay) {
          allDayEvents.add(element);
        }
      }

      for (final element in eventsForSelectedDay) {
        for (final e in eventsForSelectedDay) {
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

      for (final element in eventsForSelectedDay) {
        if (!multipleEvents.contains(element) && !allDayEvents.contains(element)) {
          singleEvents.add(element);
        }
      }

      final singleEventsWoDuplicates = singleEvents.where((element) => !element.isAllDay).toSet().toList();
      final multipleEventsWoDuplicates = multipleEvents.where((element) => !element.isAllDay).toSet().toList();
      multipleEventsWoDuplicates.sort((a, b) => a.eventStart.compareTo(b.eventStart));

      list.add(
        DayWithSingleAndMultipleItems(
          date: item,
          allDaysEvents: allDayEvents
              .map((element) => SingleEvent.fromCalendar(element))
              .toList(),
          multipleEvents: multipleEventsWoDuplicates
              .map((element) => SingleEvent.fromCalendar(element))
              .toList(),
          singleEvents: singleEventsWoDuplicates
              .map((element) => SingleEvent.fromCalendar(element))
              .toList(),
        ),
      );
    }
    return list;
  }
}
