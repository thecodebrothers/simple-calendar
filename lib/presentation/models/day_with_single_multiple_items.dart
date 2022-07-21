import 'package:simple_calendar/presentation/models/single_event.dart';

class DayWithSingleAndMultipleItems {
  DateTime date;
  List<SingleEvent> singleEvents;
  List<List<SingleEvent>> multipleEvents;
  List<SingleEvent> allDaysEvents;

  DayWithSingleAndMultipleItems({
    required this.date,
    required this.singleEvents,
    required this.multipleEvents,
    required this.allDaysEvents,
  });
}
