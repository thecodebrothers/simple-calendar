import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_calendar/bloc/one_day_calendar_cubit.dart';
import 'package:simple_calendar/bloc/scale_row_height_cubit.dart';
import 'package:simple_calendar/constants/calendar_settings.dart';
import 'package:simple_calendar/presentation/models/single_event.dart';
import 'package:simple_calendar/presentation/one_day_calendar/widgets/all_day_persistent_header.dart';
import 'package:simple_calendar/presentation/one_day_calendar/widgets/hours_column.dart';
import 'package:simple_calendar/presentation/one_day_calendar/widgets/one_day_navigation_bar.dart';
import 'package:simple_calendar/presentation/one_day_calendar/widgets/single_day_persistent_header.dart';
import 'package:simple_calendar/presentation/one_day_calendar/widgets/single_day_timeline_with_events.dart';
import 'package:simple_calendar/presentation/one_day_calendar/widgets/swapp_able_wrapper.dart';

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
  final bool shouldStickAllDayEvents;
  final bool isPullToRefreshEnabled;
  final bool isSwipeEnabled;

  const SingleDay({
    required this.onChanged,
    required this.scrollController,
    required this.calendarSettings,
    required this.onEventTap,
    required this.onLongPress,
    required this.shouldStickAllDayEvents,
    required this.isPullToRefreshEnabled,
    required this.isSwipeEnabled,
    this.onDragStarted,
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
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OneDayCalendarCubit, OneDayCalendarState>(
      builder: (context, state) {
        if (state is OneDayCalendarChanged) {
          return widget.isPullToRefreshEnabled
              ? RefreshIndicator(
                  onRefresh: () => context
                      .read<OneDayCalendarCubit>()
                      .loadForDate(state.date),
                  child: _buildSinglePage(context, state),
                )
              : _buildSinglePage(context, state);
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

  Widget _buildSinglePage(
    BuildContext context,
    OneDayCalendarChanged state,
  ) {
    final height = (!_isExpanded && state.dayWithEvents.allDaysEvents.length > 2
        ? 3
        : state.dayWithEvents.allDaysEvents.length.toDouble());

    return CustomScrollView(
      controller: !widget.isSwipeEnabled ? widget.scrollController : null,
      slivers: [
        if (widget.calendarSettings.isDaySwitcherPinned)
          SliverPersistentHeader(
            delegate: SingleDayPersistentHeader(_buildHeader(context, state)),
            pinned: true,
          )
        else
          SliverToBoxAdapter(child: _buildHeader(context, state)),
        if (state.dayWithEvents.allDaysEvents.isNotEmpty)
          SliverPersistentHeader(
            delegate: AllDayPersistentHeader(
              updateCallback: (val) => setState(() => _isExpanded = val),
              isExpanded: _isExpanded,
              calendarSettings: widget.calendarSettings,
              events: state.dayWithEvents.allDaysEvents,
              onEventTap: (event) => widget.onEventTap?.call(event),
              minExtent: (widget.calendarSettings.allDayEventHeight * height),
              maxExtent: (widget.calendarSettings.allDayEventHeight * height),
            ),
            pinned: widget.shouldStickAllDayEvents,
          ),
        SliverToBoxAdapter(child: SizedBox(height: 12)),
        if (widget.isSwipeEnabled)
          SliverFillRemaining(child: _buildShortEvents(context, state))
        else
          SliverToBoxAdapter(child: _buildShortEvents(context, state)),
      ],
    );
  }

  OneDayNavigationBar _buildHeader(
    BuildContext context,
    OneDayCalendarChanged state,
  ) {
    return OneDayNavigationBar(
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
      date: state.date,
    );
  }

  Widget _buildShortEvents(
    BuildContext context,
    OneDayCalendarChanged state,
  ) {
    Widget child = BlocBuilder<ScaleRowHeightCubit, ScaleHeightState>(
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
                calendarSettings: widget.calendarSettings,
              ),
              Expanded(
                child: SizedBox(
                  height: (widget.calendarSettings.endHour -
                          widget.calendarSettings.startHour) *
                      rowHeight,
                  child: SingleDayTimelineWithEvents(
                    rowHeight: rowHeight,
                    onDragStarted: widget.onDragStarted,
                    onLongPress: widget.onLongPress,
                    multipleEvents: state.dayWithEvents.multipleEvents,
                    date: state.date,
                    action: (item) => widget.onEventTap?.call(item),
                    calendarSettings: widget.calendarSettings,
                    onDragCompleted: widget.onDragCompleted,
                    onDragUpdate: widget.onDragUpdate,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    if (widget.isSwipeEnabled) {
      child = SwappAbleWrapper(
        calendarSettings: widget.calendarSettings,
        date: state.date,
        child: child,
        scrollController: widget.scrollController,
        onChanged: (offset) {
          final newDate = state.date.add(Duration(days: offset));
          widget.onChanged?.call(newDate);
        },
      );
    }

    return child;
  }
}
