import 'package:custom_calendar/repositories/events_repository.dart';
import 'package:get_it/get_it.dart';

void registerRepositoryModule(GetIt injector) {
  injector
      .registerLazySingleton<EventsRepository>(() => EventsRepositoryImpl());
}
