import 'package:equatable/equatable.dart';

class MonthSingleDayItem extends Equatable {
  final DateTime date;
  final bool hasAnyEvents;
  final bool isDayName;

  const MonthSingleDayItem({
    required this.hasAnyEvents,
    required this.date,
    required this.isDayName,
  });

  @override
  List<Object> get props => [date, hasAnyEvents, isDayName];
}
