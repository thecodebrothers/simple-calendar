import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:simple_calendar/presentation/models/day_with_single_multiple_items.dart';
import 'package:simple_calendar/use_case/one_day_calendar_get_events_use_case.dart';

part 'one_day_calendar_state.dart';

class OneDayCalendarCubit extends Cubit<OneDayCalendarState> {
  final OneDayCalendarGetEventsUseCase _oneDayCalendarGetEventsUseCase;
  final DateTime _initialDate;

  OneDayCalendarCubit(
    this._oneDayCalendarGetEventsUseCase,
    this._initialDate,
  ) : super(OneDayCalendarLoading()) {
    loadForDate(_initialDate);
  }

  Future loadForDate(DateTime date) async {
    final events = await _oneDayCalendarGetEventsUseCase.getOneDayEventsSorted(date);
    emit(OneDayCalendarChanged(events, date));
  }
}
