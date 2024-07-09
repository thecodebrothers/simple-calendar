import 'package:simple_calendar/presentation/models/single_event.dart';

class SingleDayItems {
  DateTime date;
  List<List<SingleEvent>> multipleGroupedEvents;
  List<SingleEvent> allDaysEvents;

  SingleDayItems({
    required this.date,
    required this.multipleGroupedEvents,
    required this.allDaysEvents,
  });
}
