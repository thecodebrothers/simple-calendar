part of 'multiple_days_calendar_cubit.dart';

abstract class MultipleDaysCalendarState extends Equatable {
  @override
  List<Object> get props => [];
}

class MultipleDaysCalendarLoading extends MultipleDaysCalendarState {}

class MultipleDaysCalendarLoaded extends MultipleDaysCalendarState {
  final List<DayWithSingleAndMultipleItems> daysWithEvents;
  final DateTime date;

  MultipleDaysCalendarLoaded(this.daysWithEvents, this.date);

  @override
  List<Object> get props => [daysWithEvents, date];
}
