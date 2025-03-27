part of 'one_day_calendar_cubit.dart';

abstract class OneDayCalendarState extends Equatable {
  @override
  List<Object?> get props => [];
}

class OneDayCalendarLoading extends OneDayCalendarState {}

class OneDayCalendarChanged extends OneDayCalendarState {
  final DayWithSingleAndMultipleItems dayWithEvents;
  final List<SameStartEventsGroup>? dayGroupedByStartTime;
  final DateTime date;

  OneDayCalendarChanged(this.dayWithEvents, this.date,
      {this.dayGroupedByStartTime});

  @override
  List<Object?> get props => [dayWithEvents, date, dayGroupedByStartTime];
}
