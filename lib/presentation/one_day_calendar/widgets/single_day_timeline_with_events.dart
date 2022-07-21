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
  final List<List<SingleEvent>> multipleEvents;
  final List<SingleEvent> allDayEvents;
  final int maxNumberOfWholeDayTasks;
  final Function(SingleEvent) action;
  final CalendarSettings calendarSettings;

  const SingleDayTimelineWithEvents({
    required this.date,
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
            EmptyCells(
              date: date,
              numberOfConstantsTasks: maxNumberOfWholeDayTasks,
              calendarSettings: calendarSettings,
            ),
            if (date.isSameDate(DateTime.now()))
              CurrentTime(numberOfConstantsTasks: maxNumberOfWholeDayTasks, calendarSettings: calendarSettings),
            ..._getMultiple(constraints),
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

  List<Widget> _getMultiple(BoxConstraints constraints) {
    final List<Widget> widgets = [];
    for (final events in multipleEvents) {
      for (int i = 0; i < events.length; i++) {
        widgets.add(CalendarEventTile(
          numberOfAllDayEvents: maxNumberOfWholeDayTasks,
          event: events[i],
          rowWidth: constraints.maxWidth,
          position: i,
          numberOfEvents: events.length < 6 ? events.length : 5,
          action: () => action(events[i]),
          calendarSettings: calendarSettings,
        ));
      }
    }
    return widgets;
  }
}
