import 'package:equatable/equatable.dart';
import 'package:simple_calendar/presentation/models/single_calendar_event.dart';

class MonthSingleDayItem extends Equatable {
  final DateTime date;
  final List<SingleCalendarEvent> events;
  final bool isDayName;

  MonthSingleDayItem({
    required this.date,
    required this.events,
    required this.isDayName,
  });

  @override
  List<Object> get props => [date, events, isDayName];
}
