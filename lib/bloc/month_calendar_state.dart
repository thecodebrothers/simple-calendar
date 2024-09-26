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
  final DateTime? selectedDate;
  final List<MonthSingleDayItem> weekItems;

  const MonthCalendarChanged(
    this.items,
    this.date,
    this.selectedDate,
    this.weekItems,
  );

  @override
  List<Object> get props => [items, date, selectedDate ?? Object(), weekItems];
}
