import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:simple_calendar/presentation/models/day_with_single_multiple_items.dart';
import 'package:simple_calendar/presentation/models/same_start_time_events_container.dart';
import 'package:simple_calendar/use_case/group_events_by_start_time_use_case.dart';
import 'package:simple_calendar/use_case/one_day_calendar_get_events_use_case.dart';

part 'one_day_calendar_state.dart';

class OneDayCalendarCubit extends Cubit<OneDayCalendarState> {
  OneDayCalendarCubit(
    this._oneDayCalendarGetEventsUseCase,
    this._groupEventsByStartTimeUseCase,
    this._initialDate,
    this._streamController,
    this.minimumEventHeight, {
    required this.flexibleHoursMode,
  }) : super(OneDayCalendarLoading()) {
    _subscription = _streamController?.stream.listen((event) {
      _reload();
    });
    loadForDate(_initialDate);
  }
  final OneDayCalendarGetEventsUseCase _oneDayCalendarGetEventsUseCase;
  final GroupEventsByStartTimeUseCase _groupEventsByStartTimeUseCase;
  final DateTime _initialDate;
  final StreamController? _streamController;
  final double? minimumEventHeight;
  final bool flexibleHoursMode;
  StreamSubscription? _subscription;

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }

  Future loadForDate(DateTime date) async {
    final events = await _oneDayCalendarGetEventsUseCase.getOneDayEventsSorted(
      date,
      minimumEventHeight,
    );
    final groupedByTime = flexibleHoursMode
        ? _groupEventsByStartTimeUseCase(events.multipleEvents)
        : null;

    emit(OneDayCalendarChanged(events, date,
        dayGroupedByStartTime: groupedByTime));
  }

  Future _reload() async {
    final currentState = state;
    if (currentState is OneDayCalendarChanged) {
      final events =
          await _oneDayCalendarGetEventsUseCase.getOneDayEventsSorted(
        currentState.date,
        minimumEventHeight,
      );

      final groupedByTime = flexibleHoursMode
          ? _groupEventsByStartTimeUseCase(events.multipleEvents)
          : null;

      emit(OneDayCalendarChanged(events, currentState.date,
          dayGroupedByStartTime: groupedByTime));
    }
  }
}
