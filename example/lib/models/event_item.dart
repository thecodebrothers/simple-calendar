class EventItem {
  final int id;
  final String name;
  final DateTime eventStart;
  final DateTime eventEnd;
  final bool isAllDay;
  final String? secondLine;
  final String? topLeftLine;
  final String? bottomRightLine;

  EventItem({
    required this.id,
    required this.name,
    required this.eventStart,
    required this.eventEnd,
    required this.isAllDay,
    this.secondLine,
    this.topLeftLine,
    this.bottomRightLine,
  });
}
