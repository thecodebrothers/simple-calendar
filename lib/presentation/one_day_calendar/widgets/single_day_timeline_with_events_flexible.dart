import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:simple_calendar/constants/calendar_settings.dart';
import 'package:simple_calendar/extensions/datetime_extension.dart';
import 'package:simple_calendar/presentation/models/same_start_time_events_container.dart';
import 'package:simple_calendar/presentation/models/single_event.dart';
import 'package:simple_calendar/presentation/one_day_calendar/widgets/calendar_event_tile.dart';
import 'package:simple_calendar/presentation/one_day_calendar/widgets/current_time.dart';
import 'package:simple_calendar/presentation/one_day_calendar/widgets/single_day_empty_cells_flexible.dart';

class SingleDayTimelineWithEventsFlexible extends StatefulWidget {
  final DateTime date;
  final void Function(SingleEvent) action;
  final CalendarSettings calendarSettings;
  final GlobalKey? calendarKey;
  final double rowHeight;
  final Function(int minutes, SingleEvent object)? onDragCompleted;
  final Function(
    DragUpdateDetails details,
    SingleEvent object,
  )? onDragUpdate;

  final Function(DateTime)? onLongPress;
  final Function()? onDragStarted;
  final List<SameStartEventsGroup> items;

  const SingleDayTimelineWithEventsFlexible({
    required this.date,
    required this.action,
    required this.calendarSettings,
    required this.onLongPress,
    required this.rowHeight,
    required this.items,
    this.calendarKey,
    this.onDragStarted,
    this.onDragCompleted,
    this.onDragUpdate,
    Key? key,
  }) : super(key: key);

  @override
  State<SingleDayTimelineWithEventsFlexible> createState() =>
      _SingleDayTimelineWithEventsFlexibleState();
}

class _SingleDayTimelineWithEventsFlexibleState
    extends State<SingleDayTimelineWithEventsFlexible> {
  late GlobalKey calendarKey;

  @override
  void initState() {
    super.initState();
    calendarKey = widget.calendarKey ?? GlobalKey();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      key: calendarKey,
      builder: (BuildContext context, BoxConstraints constraints) {
        return Stack(
          children: [
            EmptyCellsFlexible(
              rowHeight: widget.rowHeight,
              date: widget.date,
              calendarSettings: widget.calendarSettings,
              onLongPress: widget.onLongPress,
              items: widget.items,
            ),
            if (widget.date.isSameDate(DateTime.now()))
              CurrentTime(
                rowHeight: widget.rowHeight,
                startHour: widget.calendarSettings.startHour,
              ),
            ..._getTiles(constraints),
          ],
        );
      },
    );
  }

  List<Widget> _getTiles(BoxConstraints constraints) {
    final List<Widget> widgets = [];
    for (final group in widget.items) {
      for (int i = 0; i < group.events.length; i++) {
        final item = group.events[i];
        widgets.add(CalendarEventTile(
          rowHeight: widget.rowHeight,
          onDragStarted: widget.onDragStarted,
          event: item,
          calendarKey: calendarKey,
          rowWidth: constraints.maxWidth,
          position: 0,
          numberOfEvents: 1,
          action: () => widget.action(item),
          calendarSettings: widget.calendarSettings,
          date: widget.date,
          onDragCompleted: widget.onDragCompleted,
          onDragUpdate: widget.onDragUpdate,
          flexibleMode: true,
          rowNumberForFlexibleMode: group.countOfRowsAbove + i,
          getDateOfDroppedRow: (rowNumber) {
            return widget.items
                .lastWhereOrNull(
                    (element) => element.countOfRowsAbove < rowNumber)
                ?.startTime;
          },
        ));
      }
    }
    return widgets;
  }
}
