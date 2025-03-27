import 'package:simple_calendar/presentation/models/single_event.dart';

class SameStartEventsGroup {
  final int countOfRowsAbove;
  final List<SingleEvent> events;
  final DateTime startTime;

  SameStartEventsGroup(
      {required this.events,
      required this.countOfRowsAbove,
      required this.startTime});
}
