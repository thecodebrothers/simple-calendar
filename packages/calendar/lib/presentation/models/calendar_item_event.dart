part of calendar;

class CalendarItemEvent {
  final int id;
  final String name;
  final DateTime eventStart;
  final DateTime eventEnd;

  CalendarItemEvent({
    required this.id,
    required this.name,
    required this.eventStart,
    required this.eventEnd,
  });
}
