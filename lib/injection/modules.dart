import 'package:custom_calendar/injection/bloc_module.dart';
import 'package:custom_calendar/injection/repository_module.dart';
import 'package:get_it/get_it.dart';

void registerModules(GetIt injector) {
  registerRepositoryModule(injector);
  registerBlocModule(injector);
}
