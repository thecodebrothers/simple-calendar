import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:simple_calendar/presentation/models/day_with_single_multiple_items.dart';
import 'package:simple_calendar/use_case/multiple_days_calendar_get_events_use_case.dart';

part 'multiple_days_calendar_state.dart';

class MultipleDaysCalendarCubit extends Cubit<MultipleDaysCalendarState> {
  final MultipleDaysCalendarGetEventsUseCase _multipleDaysCalendarGetEventsUseCase;
  final DateTime _initialDate;
  final int _daysAround;

  MultipleDaysCalendarCubit(
    this._multipleDaysCalendarGetEventsUseCase,
    this._initialDate,
    this._daysAround,
  ) : super(MultipleDaysCalendarLoading()) {
    loadForDate(_initialDate);
  }

  Future loadForDate(DateTime date) async {
    final events = await _multipleDaysCalendarGetEventsUseCase.getMultipleDayEventsSorted(date, _daysAround);
    emit(MultipleDaysCalendarLoaded(events, date));
  }

  Future reload() async {
    final currentState = state;
    if (currentState is MultipleDaysCalendarLoaded) {
      final events = await _multipleDaysCalendarGetEventsUseCase.getMultipleDayEventsSorted(currentState.date, _daysAround);
      emit(MultipleDaysCalendarLoaded(events, currentState.date));
    }
  }
}
