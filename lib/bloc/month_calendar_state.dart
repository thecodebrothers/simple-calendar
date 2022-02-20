part of 'month_calendar_cubit.dart';

abstract class MonthCalendarState extends Equatable {
  const MonthCalendarState();

  @override
  List<Object> get props => [];
}

class MonthCalendarLoading extends MonthCalendarState {}

class MonthCalendarChanged extends MonthCalendarState {
  final List<MonthSingleDayItem> items;
  final DateTime date;

  const MonthCalendarChanged(this.items, this.date);

  @override
  List<Object> get props => [items, date];
}
