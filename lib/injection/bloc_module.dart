import 'package:custom_calendar/presentation/calendar/calendar_cubit.dart';
import 'package:get_it/get_it.dart';

void registerBlocModule(GetIt injector) {
  injector.registerFactory(() => CalendarCubit(injector.get()));
}
