class EventItem {
  final int id;
  final String name;
  final DateTime eventStart;
  final DateTime eventEnd;
  final bool isAllDay;

  EventItem({
    required this.id,
    required this.name,
    required this.eventStart,
    required this.eventEnd,
    required this.isAllDay,
  });
}
