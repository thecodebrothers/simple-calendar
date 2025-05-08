import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_calendar/bloc/multiple_days_calendar_cubit.dart';
import 'package:simple_calendar/bloc/scale_row_height_cubit.dart';
import 'package:simple_calendar/constants/calendar_settings.dart';
import 'package:simple_calendar/constants/constants.dart';
import 'package:simple_calendar/presentation/five_days_calendar/widgets/multiple_days_day_column.dart';
import 'package:simple_calendar/presentation/models/single_event.dart';
import 'package:simple_calendar/presentation/one_day_calendar/widgets/hours_column.dart';

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
    this.shouldStickAllDayEvents = false,
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
  final bool shouldStickAllDayEvents;

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
            child: CustomScrollView(
              controller: scrollController,
              slivers: [
                SliverCrossAxisGroup(slivers: [
                  SliverConstrainedCrossAxis(
                    maxExtent: kHourCellWidth + kHourCellSpaceRight,
                    sliver: SliverToBoxAdapter(
                      child: Hours(
                        rowHeight: rowHeight,
                        calendarSettings: calendarSettings,
                        topPadding: kDayNameHeight +
                            maxNumberOfWholeDayTasks *
                                calendarSettings.allDayEventHeight,
                      ),
                    ),
                  ),
                  ...calendarState.daysWithEvents
                      .map((e) => MultipleDaysDayColumn(
                            item: e,
                            maxNumberOfWholeDayTasks: maxNumberOfWholeDayTasks,
                            rowHeight: rowHeight,
                            rowWidth: rowWidth,
                            calendarSettings: calendarSettings,
                            locale: locale,
                            onTap: onTap,
                            onLongPress: onLongPress,
                            onDragCompleted: onDragCompleted,
                            onDragUpdate: onDragUpdate,
                            onDragStarted: onDragStarted,
                            shouldStickAllDayEvents: shouldStickAllDayEvents,
                          ))
                      .toList(),
                ]),
              ],
            ),
          );
        },
      ),
    );
  }
}
