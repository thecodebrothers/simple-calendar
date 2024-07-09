import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_calendar/bloc/multiple_days_calendar_cubit.dart';
import 'package:simple_calendar/bloc/scale_row_height_cubit.dart';
import 'package:simple_calendar/constants/calendar_settings.dart';
import 'package:simple_calendar/constants/constants.dart';
import 'package:simple_calendar/presentation/models/day_with_single_multiple_items.dart';
import 'package:simple_calendar/presentation/models/single_event.dart';
import 'package:simple_calendar/presentation/one_day_calendar/widgets/hours_column.dart';
import 'package:simple_calendar/presentation/one_day_calendar/widgets/multi_day_single_timeline_with_events.dart';
import 'package:simple_calendar/presentation/one_day_calendar/widgets/single_day_date.dart';

class MultipleDaysCalendarContent extends StatelessWidget {
  const MultipleDaysCalendarContent({
    required this.calendarState,
    required this.rowWidth,
    required this.scrollController,
    required this.calendarSettings,
    required this.locale,
    this.onTap,
    this.onLongPress,
    this.onDragCompleted,
    this.onDragUpdate,
    this.onDragStarted,
    super.key,
  });

  final MultipleDaysCalendarLoaded calendarState;
  final double rowWidth;
  final ScrollController scrollController;
  final CalendarSettings calendarSettings;
  final Locale? locale;
  final void Function(SingleEvent)? onTap;
  final void Function(DateTime)? onLongPress;
  final Function(int minutes, SingleEvent object)? onDragCompleted;
  final Function(DragUpdateDetails details, SingleEvent object)? onDragUpdate;
  final Function()? onDragStarted;

  @override
  Widget build(BuildContext context) {
    final maxNumberOfWholeDayTasks = calendarState.daysWithEvents
        .map((e) => e.allDaysEvents.length)
        .reduce(max);
    return Expanded(
      child: BlocBuilder<ScaleRowHeightCubit, ScaleHeightState>(
        builder: (context, rowHeightState) {
          final rowHeight = rowHeightState.height;
          return GestureDetector(
            onScaleUpdate: calendarSettings.zoomEnabled
                ? (details) {
                    final cubit = context.read<ScaleRowHeightCubit>();
                    cubit.setRowHeight(
                      details.scale * cubit.state.baseHeight,
                    );
                  }
                : null,
            onScaleEnd: (details) =>
                context.read<ScaleRowHeightCubit>().onScaleEnd(),
            child: SingleChildScrollView(
              controller: scrollController,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Hours(
                    rowHeight: rowHeight,
                    numberOfConstantsTasks: maxNumberOfWholeDayTasks,
                    calendarSettings: calendarSettings,
                    topPadding: kDayNameHeight,
                  ),
                  ...calendarState.daysWithEvents
                      .map((e) => _buildItemColumn(
                          e, maxNumberOfWholeDayTasks, rowHeight))
                      .toList(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildItemColumn(
    DayWithSingleAndMultipleItems e,
    int maxNumberOfWholeDayTasks,
    double rowHeight,
  ) {
    final calendarKey = GlobalKey();
    return Column(
      children: [
        SizedBox(
          width: rowWidth,
          child: SingleDayDate(
            date: e.date,
            locale: locale,
            calendarSettings: calendarSettings,
          ),
        ),
        SizedBox(
          width: rowWidth,
          height: (calendarSettings.endHour - calendarSettings.startHour) *
                  rowHeight +
              maxNumberOfWholeDayTasks * rowHeight,
          child: MultiDaySingleTimelineWithEvents(
            rowHeight: rowHeight,
            onLongPress: onLongPress,
            key: calendarKey,
            onDragStarted: onDragStarted,
            calendarKey: calendarKey,
            date: e.date,
            multipleEvents: e.multipleEvents,
            allDayEvents: e.allDaysEvents,
            maxNumberOfWholeDayTasks: maxNumberOfWholeDayTasks,
            action: (event) => onTap?.call(event),
            calendarSettings: calendarSettings,
            onDragCompleted: onDragCompleted,
            onDragUpdate: onDragUpdate,
          ),
        ),
      ],
    );
  }
}
