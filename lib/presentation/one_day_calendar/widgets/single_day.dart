import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_calendar/bloc/one_day_calendar_cubit.dart';
import 'package:simple_calendar/bloc/scale_row_height_cubit.dart';
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
  final Function()? onDragStarted;
  final String Function(BuildContext, TimeOfDay)? timelineHourFormatter;
  final bool showHeader;

  const SingleDay({
    required this.onChanged,
    required this.scrollController,
    required this.calendarSettings,
    required this.onEventTap,
    required this.onLongPress,
    this.onDragStarted,
    this.locale,
    this.tomorrowDayLabel,
    this.todayDayLabel,
    this.yesterdayDayLabel,
    this.beforeYesterdayDayLabel,
    this.dayAfterTomorrowDayLabel,
    this.onDragCompleted,
    this.onDragUpdate,
    this.timelineHourFormatter,
    this.showHeader = true,
    Key? key,
  }) : super(key: key);

  @override
  State<SingleDay> createState() => _SingleDayState();
}

class _SingleDayState extends State<SingleDay> {
  bool isExpanded = false;
  int _currentGroupIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OneDayCalendarCubit, OneDayCalendarState>(
      builder: (context, state) {
        if (state is OneDayCalendarChanged) {
          return _buildSinglePage(state);
        } else {
          return widget.calendarSettings.progressIndicatorBuilder != null
              ? widget.calendarSettings.progressIndicatorBuilder!(context)
              : Center(
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

    return CustomScrollView(
      controller: widget.scrollController,
      slivers: [
        if (widget.showHeader)
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
          child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  _buildNavigation(state),
                  Padding(
                    padding: const EdgeInsets.only(left: 50.0),
                    child: _buildGroupHeaders(state),
                  ),
                ],
              ),
              _buildContent(context, state),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNavigation(OneDayCalendarChanged state) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.chevron_left),
            onPressed: _currentGroupIndex > 0
                ? () {
                    setState(() {
                      _currentGroupIndex = max(0, _currentGroupIndex - 3);
                    });
                  }
                : null,
          ),
          IconButton(
            icon: Icon(Icons.chevron_right),
            onPressed: _currentGroupIndex + 3 <
                    state.dayWithEvents.multipleGroupedEvents.length
                ? () {
                    setState(() {
                      _currentGroupIndex = min(
                        state.dayWithEvents.multipleGroupedEvents.length - 3,
                        _currentGroupIndex + 3,
                      );
                    });
                  }
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildGroupHeaders(OneDayCalendarChanged state) {
    final visibleGroups = state.dayWithEvents.multipleGroupedEvents
        .skip(_currentGroupIndex)
        .take(3)
        .toList();

    return Row(
      children: visibleGroups
          .map((group) => Expanded(
                child: Column(
                  children: [
                    Center(
                      child: Text(
                        group.first.groupName ?? '',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: group.first.groupColor ?? Colors.black,
                        ),
                      ),
                    ),
                    if (group.first.groupId != null)
                      Divider(
                        height: 4,
                        thickness: 1,
                        color: group.first.groupColor ?? Colors.black,
                      ),
                  ],
                ),
              ))
          .toList(),
    );
  }

  Widget _buildContent(BuildContext context, OneDayCalendarChanged state) {
    final calendarKey = GlobalKey();

    return BlocBuilder<ScaleRowHeightCubit, ScaleHeightState>(
      builder: (context, rowState) {
        final rowHeight = rowState.height;
        return GestureDetector(
          onScaleUpdate: widget.calendarSettings.zoomEnabled
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
                numberOfConstantsTasks:
                    state.dayWithEvents.allDaysEvents.length,
                calendarSettings: widget.calendarSettings,
                timelineHourFormatter: widget.timelineHourFormatter,
              ),
              Expanded(
                child: SizedBox(
                  height: (widget.calendarSettings.endHour -
                              widget.calendarSettings.startHour) *
                          rowHeight +
                      state.dayWithEvents.allDaysEvents.length * rowHeight,
                  child: SingleDayTimelineWithEvents(
                    rowHeight: rowHeight,
                    singleDayItems: state.dayWithEvents,
                    onDragStarted: widget.onDragStarted,
                    onEmptyCellTap: widget.onLongPress,
                    key: calendarKey,
                    calendarKey: calendarKey,
                    onEventTap: (item) => widget.onEventTap?.call(item),
                    calendarSettings: widget.calendarSettings,
                    onDragCompleted: widget.onDragCompleted,
                    onDragUpdate: widget.onDragUpdate,
                    currentGroupIndex: _currentGroupIndex,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
