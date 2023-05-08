import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:simple_calendar/presentation/models/day_with_single_multiple_items.dart';
import 'package:simple_calendar/use_case/one_day_calendar_get_events_use_case.dart';

part 'one_day_calendar_state.dart';

class OneDayCalendarCubit extends Cubit<OneDayCalendarState> {
  final OneDayCalendarGetEventsUseCase _oneDayCalendarGetEventsUseCase;
  final DateTime _initialDate;
  final StreamController? _streamController;

  StreamSubscription? _subscription;

  OneDayCalendarCubit(
    this._oneDayCalendarGetEventsUseCase,
    this._initialDate,
    this._streamController,
  ) : super(OneDayCalendarLoading()) {
    _subscription = _streamController?.stream.listen((event) {
      _reload();
    });
    loadForDate(_initialDate);
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }

  Future loadForDate(DateTime date) async {
    final events =
        await _oneDayCalendarGetEventsUseCase.getOneDayEventsSorted(date);
    emit(OneDayCalendarChanged(events, date));
  }

  Future _reload() async {
    final currentState = state;
    if (currentState is OneDayCalendarChanged) {
      final events = await _oneDayCalendarGetEventsUseCase
          .getOneDayEventsSorted(currentState.date);
      emit(OneDayCalendarChanged(events, currentState.date));
    }
  }
}
