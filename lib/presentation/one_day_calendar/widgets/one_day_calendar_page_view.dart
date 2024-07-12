import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_calendar/bloc/one_day_calendar_cubit.dart';
import 'package:simple_calendar/constants/calendar_settings.dart';
import 'package:simple_calendar/presentation/models/single_event.dart';
import 'package:simple_calendar/presentation/one_day_calendar/one_day_calendar_controller.dart';
import 'package:simple_calendar/presentation/one_day_calendar/widgets/single_day.dart';
import 'package:simple_calendar/repositories/calendar_events_repository.dart';

class OneDayCalendarPageView extends StatefulWidget {
  const OneDayCalendarPageView({
    super.key,
    required this.controller,
    required this.scrollController,
    required this.calendarEventsRepository,
    required this.calendarSettings,
    required this.showHeader,
    this.onDragStarted,
    this.onEventTap,
    this.onLongPress,
    this.onSelected,
    this.reloadController,
    this.locale,
    this.tomorrowDayLabel,
    this.todayDayLabel,
    this.yesterdayDayLabel,
    this.beforeYesterdayDayLabel,
    this.dayAfterTomorrowDayLabel,
    this.onDragCompleted,
    this.onDragUpdate,
    this.timelineHourFormatter,
  });

  final ScrollController scrollController;
  final CalendarEventsRepository calendarEventsRepository;
  final StreamController? reloadController;
  final CalendarSettings calendarSettings;
  final Locale? locale;
  final Function(SingleEvent)? onEventTap;
  final Function(DateTime)? onLongPress;
  final Function(DateTime)? onSelected;
  final Function(int minutes, SingleEvent object)? onDragCompleted;
  final Function(
    DragUpdateDetails details,
    SingleEvent object,
  )? onDragUpdate;
  final Function()? onDragStarted;
  final String Function(BuildContext)? tomorrowDayLabel;
  final String Function(BuildContext)? todayDayLabel;
  final String Function(BuildContext)? yesterdayDayLabel;
  final String Function(BuildContext)? beforeYesterdayDayLabel;
  final String Function(BuildContext)? dayAfterTomorrowDayLabel;
  final String Function(BuildContext, TimeOfDay)? timelineHourFormatter;
  final bool showHeader;
  final OneDayCalendarController controller;

  @override
  State<OneDayCalendarPageView> createState() => _OneDayCalendarPageViewState();
}

class _OneDayCalendarPageViewState extends State<OneDayCalendarPageView> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onDateChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onDateChanged);
    super.dispose();
  }

  void _onDateChanged() {
    BlocProvider.of<OneDayCalendarCubit>(context)
        .loadForDate(widget.controller.dateNotifier.value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.only(top: 15.0),
        child: SingleDay(
          locale: widget.locale,
          tomorrowDayLabel: widget.tomorrowDayLabel,
          todayDayLabel: widget.todayDayLabel,
          yesterdayDayLabel: widget.yesterdayDayLabel,
          beforeYesterdayDayLabel: widget.beforeYesterdayDayLabel,
          dayAfterTomorrowDayLabel: widget.dayAfterTomorrowDayLabel,
          calendarSettings: widget.calendarSettings,
          scrollController: widget.scrollController,
          onEventTap: widget.onEventTap ?? (_) {},
          onLongPress: widget.onLongPress,
          onChanged: (date) {
            widget.onSelected?.call(date);
            widget.controller.updateDate(date);
          },
          onDragCompleted: widget.onDragCompleted,
          onDragUpdate: widget.onDragUpdate,
          onDragStarted: widget.onDragStarted,
          timelineHourFormatter: widget.timelineHourFormatter,
          showHeader: widget.showHeader,
        ),
      ),
    );
  }
}
