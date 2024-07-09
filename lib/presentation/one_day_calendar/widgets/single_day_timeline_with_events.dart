import 'package:flutter/material.dart';
import 'package:simple_calendar/constants/calendar_settings.dart';
import 'package:simple_calendar/constants/constants.dart';
import 'package:simple_calendar/presentation/models/single_day_items.dart';
import 'package:simple_calendar/presentation/models/single_event.dart';
import 'package:simple_calendar/presentation/one_day_calendar/widgets/calendar_event_tile.dart';
import 'package:simple_calendar/presentation/one_day_calendar/widgets/single_day_empty_cells.dart';

class SingleDayTimelineWithEvents extends StatefulWidget {
  final SingleDayItems singleDayItems;
  final CalendarSettings calendarSettings;
  final Function(SingleEvent) onEventTap;
  final Function(DateTime)? onEmptyCellTap;
  final GlobalKey calendarKey;
  final double rowHeight;
  final Function(int minutes, SingleEvent object)? onDragCompleted;
  final Function(DragUpdateDetails details, SingleEvent object)? onDragUpdate;
  final Function()? onDragStarted;
  final int currentGroupIndex;

  const SingleDayTimelineWithEvents({
    required this.singleDayItems,
    required this.calendarSettings,
    required this.onEventTap,
    required this.calendarKey,
    required this.rowHeight,
    this.onEmptyCellTap,
    this.onDragCompleted,
    this.onDragUpdate,
    this.onDragStarted,
    required this.currentGroupIndex,
    Key? key,
  }) : super(key: key);

  @override
  _SingleDayTimelineWithEventsState createState() =>
      _SingleDayTimelineWithEventsState();
}

class _SingleDayTimelineWithEventsState
    extends State<SingleDayTimelineWithEvents> {
  @override
  Widget build(BuildContext context) {
    final rowWidth = MediaQuery.of(context).size.width;
    final startMinutes = widget.calendarSettings.startHour * 60;

    final visibleGroups = widget.singleDayItems.multipleGroupedEvents
        .skip(widget.currentGroupIndex)
        .take(3)
        .toList();

    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              EmptyCells(
                date: widget.singleDayItems.date,
                numberOfConstantsTasks:
                    widget.singleDayItems.allDaysEvents.length,
                calendarSettings: widget.calendarSettings,
                onLongPress: widget.onEmptyCellTap,
                rowHeight: widget.rowHeight,
              ),
              ...widget.singleDayItems.allDaysEvents.asMap().entries.map(
                    (e) => Positioned(
                      top: e.key * widget.rowHeight,
                      left: 0,
                      right: 0,
                      child: CalendarEventTile(
                        event: e.value,
                        numberOfAllDayEvents: 0,
                        action: () => widget.onEventTap(e.value),
                        calendarSettings: widget.calendarSettings,
                        date: widget.singleDayItems.date,
                        calendarKey: widget.calendarKey,
                        rowWidth: rowWidth,
                        rowHeight: widget.rowHeight,
                      ),
                    ),
                  ),
              ...visibleGroups.asMap().entries.expand(
                (groupEntry) {
                  final groupIndex = groupEntry.key;
                  final group = groupEntry.value;
                  final groupWidth = rowWidth / visibleGroups.length -
                      (kHourCellWidth / visibleGroups.length);

                  return group.expand(
                    (event) => [
                      Positioned(
                        top: (event.eventStart - startMinutes) *
                                widget.rowHeight /
                                60 +
                            widget.singleDayItems.allDaysEvents.length *
                                widget.rowHeight,
                        left: groupIndex * groupWidth,
                        width: groupWidth,
                        child: CalendarEventTile(
                          event: event,
                          numberOfAllDayEvents:
                              widget.singleDayItems.allDaysEvents.length,
                          action: () => widget.onEventTap(event),
                          calendarSettings: widget.calendarSettings,
                          date: widget.singleDayItems.date,
                          calendarKey: widget.calendarKey,
                          rowWidth: groupWidth,
                          rowHeight: widget.rowHeight,
                          onDragCompleted: widget.onDragCompleted,
                          onDragUpdate: widget.onDragUpdate,
                          onDragStarted: widget.onDragStarted,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
