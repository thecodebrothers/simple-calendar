import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_calendar/bloc/multiple_days_calendar_cubit.dart';
import 'package:simple_calendar/constants/calendar_settings.dart';
import 'package:simple_calendar/constants/constants.dart';
import 'package:simple_calendar/presentation/five_days_calendar/widgets/five_days_navigation_bar.dart';
import 'package:simple_calendar/presentation/models/single_event.dart';
import 'package:simple_calendar/presentation/one_day_calendar/widgets/hours_column.dart';
import 'package:simple_calendar/presentation/one_day_calendar/widgets/single_day_date.dart';
import 'package:simple_calendar/presentation/one_day_calendar/widgets/single_day_timeline_with_events.dart';
import 'package:simple_calendar/repositories/calendar_events_repository.dart';
import 'package:simple_calendar/use_case/multiple_days_calendar_get_events_use_case.dart';

class MultipleDaysCalendarView extends StatefulWidget {
  final ScrollController scrollController;
  final CalendarEventsRepository calendarEventsRepository;
  final DateTime? initialDate;
  final int daysAround;
  final CalendarSettings calendarSettings;
  final Function(SingleEvent) onTap;
  final StreamController reloadController;

  const MultipleDaysCalendarView({
    required this.scrollController,
    required this.initialDate,
    required this.calendarEventsRepository,
    required this.daysAround,
    required this.calendarSettings,
    required this.onTap,
    required this.reloadController,
    Key? key,
  }) : super(key: key);

  @override
  State<MultipleDaysCalendarView> createState() => _MultipleDaysCalendarViewState();
}

class _MultipleDaysCalendarViewState extends State<MultipleDaysCalendarView> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MultipleDaysCalendarCubit>(
      create: (context) => MultipleDaysCalendarCubit(
        MultipleDaysCalendarGetEventsUseCase(widget.calendarEventsRepository),
        widget.initialDate ?? DateTime.now(),
        widget.daysAround,
        widget.reloadController,
      ),
      child: BlocBuilder<MultipleDaysCalendarCubit, MultipleDaysCalendarState>(
        builder: (context, state) {
          if (state is MultipleDaysCalendarLoaded) {
            return _buildPage(state);
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
      ),
    );
  }

  Widget _buildPage(MultipleDaysCalendarLoaded state) {
    return Scaffold(
      body: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
        final rowWidth = (constraints.maxWidth - kHourCellWidth - kDayNameHeight - kHourCellSpaceRight) /
            state.daysWithEvents.length;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FiveDaysNavigationBar(
              onTapLeft: () {
                BlocProvider.of<MultipleDaysCalendarCubit>(context)
                    .loadForDate(state.date.add(Duration(days: -(widget.daysAround * 2 + 1))));
              },
              onTapRight: () {
                BlocProvider.of<MultipleDaysCalendarCubit>(context)
                    .loadForDate(state.date.add(Duration(days: widget.daysAround * 2 + 1)));
              },
              rowWidth: rowWidth,
            ),
            _buildCalendar(state, rowWidth),
          ],
        );
      }),
    );
  }

  Widget _buildCalendar(MultipleDaysCalendarLoaded state, double rowWidth) {
    final maxNumberOfWholeDayTasks = state.daysWithEvents.map((e) => e.allDaysEvents.length).reduce(max);
    return Expanded(
      child: SingleChildScrollView(
        controller: widget.scrollController,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hours(numberOfConstantsTasks: maxNumberOfWholeDayTasks),
            ...state.daysWithEvents
                .map(
                  (e) => Column(
                    children: [
                      SizedBox(
                        width: rowWidth,
                        child: SingleDayDate(
                          date: e.date,
                          calendarSettings: widget.calendarSettings,
                        ),
                      ),
                      SizedBox(
                        width: rowWidth,
                        height: kHoursInCalendar * kCellHeight + maxNumberOfWholeDayTasks * kCellHeight,
                        child: SingleDayTimelineWithEvents(
                          date: e.date,
                          events: e.singleEvents,
                          multipleEvents: e.multipleEvents,
                          allDayEvents: e.allDaysEvents,
                          maxNumberOfWholeDayTasks: maxNumberOfWholeDayTasks,
                          action: widget.onTap,
                          calendarSettings: widget.calendarSettings,
                        ),
                      ),
                    ],
                  ),
                )
                .toList(),
          ],
        ),
      ),
    );
  }
}
