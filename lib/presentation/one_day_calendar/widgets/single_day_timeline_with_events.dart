import 'package:flutter/material.dart';
import 'package:simple_calendar/constants/calendar_settings.dart';
import 'package:simple_calendar/extensions/datetime_extension.dart';
import 'package:simple_calendar/presentation/models/single_event.dart';
import 'package:simple_calendar/presentation/one_day_calendar/widgets/calendar_event_tile.dart';
import 'package:simple_calendar/presentation/one_day_calendar/widgets/current_time.dart';
import 'package:simple_calendar/presentation/one_day_calendar/widgets/single_day_empty_cells.dart';

class SingleDayTimelineWithEvents extends StatelessWidget {
  final DateTime date;
  final List<List<SingleEvent>> multipleEvents;
  final void Function(SingleEvent) action;
  final CalendarSettings calendarSettings;
  final GlobalKey calendarKey;
  final double rowHeight;
  final Function(int minutes, SingleEvent object)? onDragCompleted;
  final Function(
    DragUpdateDetails details,
    SingleEvent object,
  )? onDragUpdate;

  final Function(DateTime)? onLongPress;
  final Function()? onDragStarted;

  const SingleDayTimelineWithEvents({
    required this.date,
    required this.multipleEvents,
    required this.action,
    required this.calendarSettings,
    required this.calendarKey,
    required this.onLongPress,
    required this.rowHeight,
    this.onDragStarted,
    this.onDragCompleted,
    this.onDragUpdate,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Stack(
          children: [
            EmptyCells(
              rowHeight: rowHeight,
              date: date,
              calendarSettings: calendarSettings,
              onLongPress: onLongPress,
            ),
            if (date.isSameDate(DateTime.now()))
              CurrentTime(
                rowHeight: rowHeight,
                startHour: calendarSettings.startHour,
              ),
            ..._getMultiple(constraints),
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
          rowHeight: rowHeight,
          onDragStarted: onDragStarted,
          event: events[i],
          calendarKey: calendarKey,
          rowWidth: constraints.maxWidth,
          position: i,
          numberOfEvents: events.length < 6 ? events.length : 5,
          action: () => action(events[i]),
          calendarSettings: calendarSettings,
          date: date,
          onDragCompleted: onDragCompleted,
          onDragUpdate: onDragUpdate,
        ));
      }
    }
    return widgets;
  }
}
