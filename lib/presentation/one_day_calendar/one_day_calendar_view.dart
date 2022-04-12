import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_calendar/bloc/one_day_calendar_cubit.dart';
import 'package:simple_calendar/constants/calendar_settings.dart';
import 'package:simple_calendar/presentation/models/single_event.dart';
import 'package:simple_calendar/presentation/one_day_calendar/widgets/single_day.dart';
import 'package:simple_calendar/repositories/calendar_events_repository.dart';
import 'package:simple_calendar/use_case/one_day_calendar_get_events_use_case.dart';

class OneDayCalendarView extends StatefulWidget {
  final ScrollController scrollController;
  final CalendarEventsRepository calendarEventsRepository;
  final DateTime? initialDate;
  final CalendarSettings calendarSettings;
  final Function(SingleEvent) onEventTap;
  final StreamController? reloadController;
  final Function(DateTime) onLongPress;

  const OneDayCalendarView({
    required this.scrollController,
    required this.calendarEventsRepository,
    required this.initialDate,
    required this.calendarSettings,
    required this.onEventTap,
    required this.onLongPress,
    this.reloadController,
    Key? key,
  }) : super(key: key);

  @override
  _OneDayCalendarViewState createState() => _OneDayCalendarViewState();
}

class _OneDayCalendarViewState extends State<OneDayCalendarView> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<OneDayCalendarCubit>(
      create: (context) => OneDayCalendarCubit(
        OneDayCalendarGetEventsUseCase(widget.calendarEventsRepository),
        widget.initialDate ?? DateTime.now(),
        widget.reloadController,
      ),
      child: BlocBuilder<OneDayCalendarCubit, OneDayCalendarState>(
        builder: (context, state) {
          return _buildPage(context);
        },
      ),
    );
  }

  Widget _buildPage(BuildContext pageContext) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.only(top: 15.0),
        child: SingleDay(
          calendarSettings: widget.calendarSettings,
          scrollController: widget.scrollController,
          onEventTap: widget.onEventTap,
          onLongPress: widget.onLongPress,
          onChanged: (date) {
            BlocProvider.of<OneDayCalendarCubit>(pageContext).loadForDate(date);
          },
        ),
      ),
    );
  }
}
