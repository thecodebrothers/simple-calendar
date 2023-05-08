import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:simple_calendar/presentation/models/day_with_single_multiple_items.dart';
import 'package:simple_calendar/use_case/multiple_days_calendar_get_events_use_case.dart';

part 'multiple_days_calendar_state.dart';

class MultipleDaysCalendarCubit extends Cubit<MultipleDaysCalendarState> {
  final MultipleDaysCalendarGetEventsUseCase
      _multipleDaysCalendarGetEventsUseCase;
  final DateTime _initialDate;
  final int _daysAround;
  final StreamController? _streamController;
  final bool isMinimumEventHeightEnabled;
  final double? minimumEventHeight;
  StreamSubscription? _subscription;

  MultipleDaysCalendarCubit(
    this._multipleDaysCalendarGetEventsUseCase,
    this._initialDate,
    this._daysAround,
    this._streamController,
    this.isMinimumEventHeightEnabled,
    this.minimumEventHeight,
  )   : assert(isMinimumEventHeightEnabled ? minimumEventHeight != null : true,
            "minimumEventHeight must not be null when isMinimumHeightEnabled is true"),
        super(MultipleDaysCalendarLoading()) {
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
        await _multipleDaysCalendarGetEventsUseCase.getMultipleDayEventsSorted(
            date, _daysAround, isMinimumEventHeightEnabled, minimumEventHeight);
    emit(MultipleDaysCalendarLoaded(events, date));
  }

  Future _reload() async {
    final currentState = state;
    if (currentState is MultipleDaysCalendarLoaded) {
      final events = await _multipleDaysCalendarGetEventsUseCase
          .getMultipleDayEventsSorted(currentState.date, _daysAround,
              isMinimumEventHeightEnabled, minimumEventHeight);
      emit(MultipleDaysCalendarLoaded(events, currentState.date));
    }
  }
}
