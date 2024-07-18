import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:simple_calendar/presentation/models/month_single_day_item.dart';
import 'package:simple_calendar/use_case/month_calendar_get_events_use_case.dart';

part 'month_calendar_state.dart';

class MonthCalendarCubit extends Cubit<MonthCalendarState> {
  final MonthCalendarGetEventsUseCase _monthCalendarGetEventsUseCase;
  final DateTime _initialDate;
  final StreamController? _streamController;
  StreamSubscription? _subscription;

  MonthCalendarCubit(
    this._monthCalendarGetEventsUseCase,
    this._initialDate,
    this._streamController,
  ) : super(MonthCalendarLoading()) {
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
    final events = await _monthCalendarGetEventsUseCase.getItems(date);
    emit(MonthCalendarChanged(events, date));
  }

  Future _reload() async {
    final currentState = state;
    if (currentState is MonthCalendarChanged) {
      final events =
          await _monthCalendarGetEventsUseCase.getItems(currentState.date);
      emit(MonthCalendarChanged(events, currentState.date));
    }
  }
}
