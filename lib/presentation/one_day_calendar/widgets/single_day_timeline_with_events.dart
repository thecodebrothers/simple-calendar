import 'package:flutter/material.dart';
import 'package:simple_calendar/constants/calendar_settings.dart';
import 'package:simple_calendar/extensions/datetime_extension.dart';
import 'package:simple_calendar/presentation/models/single_event.dart';
import 'package:simple_calendar/presentation/one_day_calendar/widgets/calendar_event_tile.dart';
import 'package:simple_calendar/presentation/one_day_calendar/widgets/current_time.dart';
import 'package:simple_calendar/presentation/one_day_calendar/widgets/single_day_empty_cells.dart';
import 'package:simple_calendar/presentation/one_day_calendar/widgets/whole_day_event.dart';

class SingleDayTimelineWithEvents extends StatelessWidget {
  final DateTime date;
  final List<SingleEvent> events;
  final List<SingleEvent> multipleEvents;
  final List<SingleEvent> allDayEvents;
  final int maxNumberOfWholeDayTasks;
  final Function(SingleEvent) action;
  final CalendarSettings calendarSettings;

  const SingleDayTimelineWithEvents({
    required this.date,
    required this.events,
    required this.multipleEvents,
    required this.allDayEvents,
    required this.maxNumberOfWholeDayTasks,
    required this.action,
    required this.calendarSettings,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Stack(
          children: [
            EmptyCells(date: date, numberOfConstantsTasks: maxNumberOfWholeDayTasks, calendarSettings: calendarSettings,),
            if (date.isSameDate(DateTime.now())) CurrentTime(numberOfConstantsTasks: maxNumberOfWholeDayTasks, calendarSettings: calendarSettings),
            ...events.map(
              (e) => CalendarEventTile(
                event: e,
                numberOfAllDayEvents: maxNumberOfWholeDayTasks,
                action: () => action(e),
                calendarSettings: calendarSettings,
              ),
            ),
            for (int i = 0; i < multipleEvents.length; i++)
              CalendarEventTile(
                numberOfAllDayEvents: maxNumberOfWholeDayTasks,
                event: multipleEvents[i],
                rowWidth: constraints.maxWidth,
                position: i,
                numberOfEvents: multipleEvents.length < 6 ? multipleEvents.length : 5,
                action: () => action(multipleEvents[i]),
                calendarSettings: calendarSettings,
              ),
            for (int i = 0; i < allDayEvents.length; i++)
              WholeEventTile(
                calendarSettings: calendarSettings,
                event: allDayEvents[i],
                rowWidth: constraints.maxWidth,
                position: i,
                action: () => action(allDayEvents[i]),
              )
          ],
        );
      },
    );
  }
}
