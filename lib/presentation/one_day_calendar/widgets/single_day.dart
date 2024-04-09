import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_calendar/bloc/one_day_calendar_cubit.dart';
import 'package:simple_calendar/constants/calendar_settings.dart';
import 'package:simple_calendar/presentation/models/single_event.dart';
import 'package:simple_calendar/presentation/one_day_calendar/widgets/all_day_persistent_header.dart';
import 'package:simple_calendar/presentation/one_day_calendar/widgets/hours_column.dart';
import 'package:simple_calendar/presentation/one_day_calendar/widgets/single_day_header.dart';
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
  final Function(int minutes, SingleEvent object)? onDragCompleted;
  final Function(
    DragUpdateDetails details,
    SingleEvent object,
  )? onDragUpdate;

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
    this.onDragCompleted,
    this.onDragUpdate,
    Key? key,
  }) : super(key: key);

  @override
  State<SingleDay> createState() => _SingleDayState();
}

class _SingleDayState extends State<SingleDay> {
  bool isExpanded = false;

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
    final height = (!isExpanded && state.dayWithEvents.allDaysEvents.length > 2
        ? 3
        : state.dayWithEvents.allDaysEvents.length.toDouble() + 1);

    final calendarKey = GlobalKey();

    return CustomScrollView(
      controller: widget.scrollController,
      slivers: [
        SingleDayHeader(
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
          calendarSettings: widget.calendarSettings,
          state: state,
        ),
        if (state.dayWithEvents.allDaysEvents.isNotEmpty)
          SliverPersistentHeader(
            delegate: AllDayPersistentHeader(
              updateCallback: (val) {
                setState(() {
                  isExpanded = val;
                });
              },
              isExpanded: isExpanded,
              calendarSettings: widget.calendarSettings,
              events: state.dayWithEvents.allDaysEvents,
              onEventTap: (event) => widget.onEventTap?.call(event),
              minExtent: (widget.calendarSettings.allDayEventHeight * height),
              maxExtent: (widget.calendarSettings.allDayEventHeight * height),
            ),
            pinned: true,
          ),
        if (state.dayWithEvents.allDaysEvents.isEmpty)
          SliverToBoxAdapter(
            child: SizedBox(
              height: 24,
            ),
          ),
        SliverToBoxAdapter(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hours(
                numberOfConstantsTasks:
                    state.dayWithEvents.allDaysEvents.length,
                calendarSettings: widget.calendarSettings,
              ),
              Expanded(
                child: SizedBox(
                  height: (widget.calendarSettings.endHour -
                              widget.calendarSettings.startHour) *
                          widget.calendarSettings.rowHeight +
                      state.dayWithEvents.allDaysEvents.length *
                          widget.calendarSettings.rowHeight,
                  child: SingleDayTimelineWithEvents(
                    onLongPress: widget.onLongPress,
                    key: calendarKey,
                    multipleEvents: state.dayWithEvents.multipleEvents,
                    allDayEvents: state.dayWithEvents.allDaysEvents,
                    date: state.date,
                    calendarKey: calendarKey,
                    maxNumberOfWholeDayTasks:
                        state.dayWithEvents.allDaysEvents.length,
                    action: (item) => widget.onEventTap?.call(item),
                    calendarSettings: widget.calendarSettings,
                    onDragCompleted: widget.onDragCompleted,
                    onDragUpdate: widget.onDragUpdate,
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
