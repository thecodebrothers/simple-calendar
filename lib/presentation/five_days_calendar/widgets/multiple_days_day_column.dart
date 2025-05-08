import 'package:flutter/material.dart';
import 'package:simple_calendar/constants/calendar_settings.dart';
import 'package:simple_calendar/presentation/models/day_with_single_multiple_items.dart';
import 'package:simple_calendar/presentation/models/single_event.dart';
import 'package:simple_calendar/presentation/one_day_calendar/widgets/all_day_persistent_header.dart';
import 'package:simple_calendar/presentation/one_day_calendar/widgets/single_day_date.dart';
import 'package:simple_calendar/presentation/one_day_calendar/widgets/single_day_timeline_with_events.dart';

class MultipleDaysDayColumn extends StatelessWidget {
  const MultipleDaysDayColumn({
    required this.item,
    required this.maxNumberOfWholeDayTasks,
    required this.rowHeight,
    required this.rowWidth,
    required this.calendarSettings,
    required this.locale,
    this.onTap,
    this.onLongPress,
    this.onDragCompleted,
    this.onDragUpdate,
    this.onDragStarted,
    this.shouldStickAllDayEvents = false,
    super.key,
  });

  final DayWithSingleAndMultipleItems item;
  final int maxNumberOfWholeDayTasks;
  final double rowHeight;
  final double rowWidth;
  final CalendarSettings calendarSettings;
  final Locale? locale;
  final void Function(SingleEvent)? onTap;
  final void Function(DateTime)? onLongPress;
  final Function(int minutes, SingleEvent object)? onDragCompleted;
  final Function(DragUpdateDetails details, SingleEvent object)? onDragUpdate;
  final Function()? onDragStarted;
  final bool shouldStickAllDayEvents;

  Widget build(BuildContext context) {
    final calendarKey = GlobalKey();

    return SliverMainAxisGroup(
      slivers: [
        SliverToBoxAdapter(
          child: SizedBox(
            width: rowWidth,
            child: SingleDayDate(
              date: item.date,
              locale: locale,
              calendarSettings: calendarSettings,
            ),
          ),
        ),
        if (item.allDaysEvents.isEmpty)
          SliverToBoxAdapter(
            child: SizedBox(
              width: rowWidth,
              height:
                  maxNumberOfWholeDayTasks * calendarSettings.allDayEventHeight,
            ),
          )
        else
          SliverPersistentHeader(
            delegate: AllDayPersistentHeader(
              updateCallback: (val) => () {},
              isExpanded: true,
              calendarSettings: calendarSettings,
              events: item.allDaysEvents,
              onEventTap: (event) => onTap?.call(event),
              minExtent:
                  maxNumberOfWholeDayTasks * calendarSettings.allDayEventHeight,
              maxExtent:
                  maxNumberOfWholeDayTasks * calendarSettings.allDayEventHeight,
              showExpandButton: false,
            ),
            pinned: shouldStickAllDayEvents,
          ),
        SliverToBoxAdapter(
          child: SizedBox(
            width: rowWidth,
            height: (calendarSettings.endHour - calendarSettings.startHour) *
                rowHeight,
            child: SingleDayTimelineWithEvents(
              rowHeight: rowHeight,
              onLongPress: onLongPress,
              key: calendarKey,
              onDragStarted: onDragStarted,
              calendarKey: calendarKey,
              date: item.date,
              multipleEvents: item.multipleEvents,
              action: (event) => onTap?.call(event),
              calendarSettings: calendarSettings,
              onDragCompleted: onDragCompleted,
              onDragUpdate: onDragUpdate,
            ),
          ),
        ),
      ],
    );
  }
}
