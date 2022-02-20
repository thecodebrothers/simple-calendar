import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:simple_calendar/presentation/models/month_single_day_item.dart';
import 'package:simple_calendar/use_case/month_calendar_get_events_use_case.dart';

part 'month_calendar_state.dart';

class MonthCalendarCubit extends Cubit<MonthCalendarState> {
  final MonthCalendarGetEventsUseCase _monthCalendarGetEventsUseCase;
  final DateTime _initialDate;

  MonthCalendarCubit(
    this._monthCalendarGetEventsUseCase,
    this._initialDate,
  ) : super(MonthCalendarLoading()) {
    loadForDate(_initialDate);
  }

  Future loadForDate(DateTime date) async {
    final events = await _monthCalendarGetEventsUseCase.getItems(date);
    emit(MonthCalendarChanged(events, date));
  }
}
