import 'package:equatable/equatable.dart';
import 'package:simple_calendar/presentation/models/single_event.dart';

class SameStartEventsGroup extends Equatable {
  final int countOfRowsAbove;
  final List<SingleEvent> events;
  final DateTime startTime;

  @override
  List<Object?> get props => [countOfRowsAbove, events, startTime];

 const  SameStartEventsGroup({
    required this.events,
    required this.countOfRowsAbove,
    required this.startTime,
  });
}
