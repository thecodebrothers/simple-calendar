import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_calendar/bloc/one_day_calendar_cubit.dart';
import 'package:simple_calendar/constants/calendar_settings.dart';
import 'package:simple_calendar/presentation/models/single_event.dart';
import 'package:simple_calendar/presentation/one_day_calendar/widgets/all_day_persistent_header.dart';
import 'package:simple_calendar/presentation/one_day_calendar/widgets/hours_column.dart';
import 'package:simple_calendar/presentation/one_day_calendar/widgets/one_day_navigation_bar.dart';
import 'package:simple_calendar/presentation/one_day_calendar/widgets/single_day_timeline_with_events.dart';

class SingleDay extends StatefulWidget {
  final Function(DateTime)? onChanged;
  final ScrollController scrollController;
  final CalendarSettings calendarSettings;
  final Function(SingleEvent)? onEventTap;
  final Function(DateTime)? onLongPress;
  final Locale? locale;
  final String Function(BuildContext)? tomorrowDayLabel;
  final String Function(BuildContext)? todayDayLabel;
  final String Function(BuildContext)? yesterdayDayLabel;
  final String Function(BuildContext)? beforeYesterdayDayLabel;
  final String Function(BuildContext)? dayAfterTomorrowDayLabel;

  const SingleDay({
    required this.onChanged,
    required this.scrollController,
    required this.calendarSettings,
    required this.onEventTap,
    required this.onLongPress,
    this.locale,
    this.tomorrowDayLabel,
    this.todayDayLabel,
    this.yesterdayDayLabel,
    this.beforeYesterdayDayLabel,
    this.dayAfterTomorrowDayLabel,
    Key? key,
  }) : super(key: key);

  @override
  State<SingleDay> createState() => _SingleDayState();
}

class _SingleDayState extends State<SingleDay> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OneDayCalendarCubit, OneDayCalendarState>(
      builder: (context, state) {
        if (state is OneDayCalendarChanged) {
          return _buildSinglePage(state);
        } else {
          return const Center(
            child: SizedBox(
              height: 50,
              width: 50,
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }

  Widget _buildSinglePage(OneDayCalendarChanged state) {
    final heightVariable = state.dayWithEvents.allDaysEvents.isNotEmpty
        ? widget.calendarSettings.hourCustomHeight
        : 0.0;

    return CustomScrollView(
      controller: widget.scrollController,
      slivers: [
        SliverToBoxAdapter(
          child: OneDayNavigationBar(
            locale: widget.locale,
            tomorrowDayLabel: widget.tomorrowDayLabel,
            todayDayLabel: widget.todayDayLabel,
            yesterdayDayLabel: widget.yesterdayDayLabel,
            beforeYesterdayDayLabel: widget.beforeYesterdayDayLabel,
            dayAfterTomorrowDayLabel: widget.dayAfterTomorrowDayLabel,
            onTapLeft: () {
              final newDate = state.date.add(const Duration(days: -1));
              widget.onChanged?.call(newDate);
            },
            onTapRight: () {
              final newDate = state.date.add(const Duration(days: 1));
              widget.onChanged?.call(newDate);
            },
            date: state.date,
            calendarSettings: widget.calendarSettings,
          ),
        ),
        if (state.dayWithEvents.allDaysEvents.isNotEmpty)
          SliverPersistentHeader(
            delegate: AllDayPersistentHeader(
              calendarSettings: widget.calendarSettings,
              events: state.dayWithEvents.allDaysEvents,
              onEventTap: (event) => widget.onEventTap?.call(event),
              minExtent: widget.calendarSettings.allDayEventHeight *
                  state.dayWithEvents.allDaysEvents.length.toDouble(),
              maxExtent: widget.calendarSettings.allDayEventHeight *
                  state.dayWithEvents.allDaysEvents.length.toDouble(),
            ),
            pinned: true,
          ),
        SliverToBoxAdapter(
          child: Row(
            children: [
              Hours(
                  containsWholeDayEvent:
                      state.dayWithEvents.allDaysEvents.isNotEmpty,
                  numberOfConstantsTasks:
                      state.dayWithEvents.allDaysEvents.length,
                  calendarSettings: widget.calendarSettings),
              Expanded(
                child: SizedBox(
                  height: (widget.calendarSettings.endHour -
                              widget.calendarSettings.startHour) *
                          widget.calendarSettings.rowHeight +
                      state.dayWithEvents.allDaysEvents.length *
                          widget.calendarSettings.rowHeight +
                      heightVariable,
                  child: GestureDetector(
                    onLongPressEnd: (details) {
                      final date = state.date;
                      widget.onLongPress?.call(DateTime(
                          date.year,
                          date.month,
                          date.day,
                          (details.localPosition.dy.toInt() +
                                  (widget.calendarSettings.startHour * 60)) ~/
                              60));
                    },
                    child: SingleDayTimelineWithEvents(
                      multipleEvents: state.dayWithEvents.multipleEvents,
                      allDayEvents: state.dayWithEvents.allDaysEvents,
                      date: state.date,
                      maxNumberOfWholeDayTasks:
                          state.dayWithEvents.allDaysEvents.length,
                      action: (item) => widget.onEventTap?.call(item),
                      calendarSettings: widget.calendarSettings,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
