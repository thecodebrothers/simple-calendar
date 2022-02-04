import 'package:bloc/bloc.dart';
import 'package:calendar/calendar.dart';
import 'package:custom_calendar/repositories/events_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:fimber/fimber.dart';

part 'calendar_state.dart';

class CalendarCubit extends Cubit<CalendarState> {
  final EventsRepository _eventsRepository;

  CalendarCubit(this._eventsRepository) : super(CalendarInitial());

  Future<void> loadEvents() async {
    try {
      final daysWithEvents = _eventsRepository.getCalendarDays();
      emit(CalendarLoaded(daysWithEvents));
      // ignore: empty_catches
    } catch (e) {
      Fimber.e('Error fetching events', ex: e);
      emit(CalendarError(e.toString()));
    }
  }
}
