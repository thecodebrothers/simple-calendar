part of 'calendar_cubit.dart';

abstract class CalendarState extends Equatable {
  const CalendarState();

  @override
  List<Object> get props => [];
}

class CalendarInitial extends CalendarState {}

class CalendarLoaded extends CalendarState {
  final Map<DateTime, DayWithSingleAndMultipleItems> daysWithEvents;

  const CalendarLoaded(this.daysWithEvents);
}

class CalendarError extends CalendarState {
  final String error;

  const CalendarError(this.error);
}
