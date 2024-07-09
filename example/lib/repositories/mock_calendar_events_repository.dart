import 'package:example/models/event_item.dart';
import 'package:example/services/mock_events_service.dart';
import 'package:flutter/material.dart';
import 'package:simple_calendar/simple_calendar.dart';

class MockCalendarEventsRepository extends CalendarEventsRepository {
  MockCalendarEventsRepository(this._service);

  final MockEventsService _service;

  @override
  Future<List<SingleCalendarEvent>> getEventsForDay(DateTime date) async {
    final events = await _service.getEventsForDay(date);

    return _mapEvents(events);
  }

  @override
  Future<List<SingleCalendarEvent>> getEventsForMultipleDays(
      DateTime fromDate, DateTime toDate) async {
    final fixedFromDate = DateTime(fromDate.year, fromDate.month, fromDate.day);
    final fixedToDate = DateTime(toDate.year, toDate.month, toDate.day);

    final events =
        await _service.getEventsForMultipleDays(fixedFromDate, fixedToDate);

    return _mapEvents(events);
  }

  Future<List<SingleCalendarEvent>> _mapEvents(List<EventItem> events) async {
    return events
        .map(
          (e) => SingleCalendarEvent(
            id: e.id,
            singleLine: e.name,
            isAllDay: e.isAllDay,
            eventStart: e.eventStart,
            eventEnd: e.eventEnd,
            object: e,
            localIconName: '',
            networkIconName: '',
            iconBackgroundColor: Colors.cyan,
            dotTileColor: null,
            tileBackgroundColor: e.groupColor ?? Colors.white,
            secondLine: e.secondLine,
            topLeftLine: e.topLeftLine,
            bottomRightLine: e.bottomRightLine,
            groupId: e.groupId,
            groupOrder: e.groupOrder,
            groupColor: e.groupColor,
          ),
        )
        .toList();
  }
}
