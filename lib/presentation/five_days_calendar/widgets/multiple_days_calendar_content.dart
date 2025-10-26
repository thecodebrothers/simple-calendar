import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_calendar/bloc/multiple_days_calendar_cubit.dart';
import 'package:simple_calendar/bloc/scale_row_height_cubit.dart';
import 'package:simple_calendar/constants/calendar_settings.dart';
import 'package:simple_calendar/constants/constants.dart';
import 'package:simple_calendar/presentation/models/single_event.dart';
import 'package:simple_calendar/presentation/one_day_calendar/widgets/hours_column.dart';
import 'package:simple_calendar/presentation/one_day_calendar/widgets/single_day_date.dart';
import 'package:simple_calendar/presentation/one_day_calendar/widgets/single_day_timeline_with_events.dart';
import 'package:simple_calendar/presentation/one_day_calendar/widgets/whole_day_event.dart';

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
    this.beforeYesterdayDayLabel,
    this.yesterdayDayLabel,
    this.todayDayLabel,
    this.tomorrowDayLabel,
    this.dayAfterTomorrowDayLabel,
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
  final String Function(BuildContext)? beforeYesterdayDayLabel;
  final String Function(BuildContext)? yesterdayDayLabel;
  final String Function(BuildContext)? todayDayLabel;
  final String Function(BuildContext)? tomorrowDayLabel;
  final String Function(BuildContext)? dayAfterTomorrowDayLabel;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          children: [
            _buildDates(),
            _buildWholeDayEvents(),
            _buildShortEvents(),
          ],
        ),
      ),
    );
  }

  Widget _buildDates() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: kHourCellWidth),
        ...calendarState.daysWithEvents.map((e) {
          return SizedBox(
            width: rowWidth,
            child: SingleDayDate(
              date: e.date,
              locale: locale,
              calendarSettings: calendarSettings,
              beforeYesterdayDayLabel: beforeYesterdayDayLabel,
              yesterdayDayLabel: yesterdayDayLabel,
              todayDayLabel: todayDayLabel,
              tomorrowDayLabel: tomorrowDayLabel,
              dayAfterTomorrowDayLabel: dayAfterTomorrowDayLabel,
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildWholeDayEvents() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: kHourCellWidth),
        ...calendarState.daysWithEvents.map((day) {
          return SizedBox(
            width: rowWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: day.allDaysEvents
                  .map(
                    (event) => SizedBox(
                      height: calendarSettings.allDayEventHeight,
                      child: WholeEventTile(
                        calendarSettings: calendarSettings,
                        event: event,
                        rowWidth: rowWidth,
                        action: () => onTap?.call(event),
                      ),
                    ),
                  )
                  .toList(),
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildShortEvents() {
    return BlocBuilder<ScaleRowHeightCubit, ScaleHeightState>(
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
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hours(
                rowHeight: rowHeight,
                calendarSettings: calendarSettings,
                topPadding: kDayNameHeight,
              ),
              ...calendarState.daysWithEvents.map((e) {
                final calendarKey = GlobalKey();
                return SizedBox(
                  width: rowWidth,
                  height:
                      (calendarSettings.endHour - calendarSettings.startHour) *
                          rowHeight,
                  child: SingleDayTimelineWithEvents(
                    rowHeight: rowHeight,
                    onLongPress: onLongPress,
                    key: calendarKey,
                    onDragStarted: onDragStarted,
                    calendarKey: calendarKey,
                    date: e.date,
                    multipleEvents: e.multipleEvents,
                    action: (event) => onTap?.call(event),
                    calendarSettings: calendarSettings,
                    onDragCompleted: onDragCompleted,
                    onDragUpdate: onDragUpdate,
                  ),
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }
}
