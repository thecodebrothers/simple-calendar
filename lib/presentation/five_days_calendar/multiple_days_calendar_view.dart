import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
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

/// Calendar widget that shows events for multiple days
///
/// Typically used to show events for whole week
class MultipleDaysCalendarView extends StatefulWidget {
  final ScrollController scrollController;

  /// Repository that provides events for this calendar
  final CalendarEventsRepository calendarEventsRepository;

  /// Provides ability to reload events
  final StreamController? reloadController;

  /// Indicates which day should be shown in the center of the screen
  ///
  /// Defaults to `DateTime.now`
  final DateTime? initialDate;

  /// Indicates how many days should be shown between center day.
  ///
  /// Defaults to a whole week => `3`
  final int daysAround;

  /// Settings for calendar
  /// that allow you to customize spacings, text styles, colors etc.
  final CalendarSettings calendarSettings;

  /// Locale for calendar, if not provided, then system locale will be used
  ///
  /// If you want to use 'locale' parameter in calendar widgets
  /// and do not have provided GlobalMaterialLocalizations.delegate
  /// you should call [initializeDateFormatting]
  /// at least once at the beginning of your app
  final Locale? locale;

  /// Called when user taps on event
  final void Function(SingleEvent)? onTap;

  /// Called when user long presses on event
  final void Function(DateTime)? onLongPress;

  const MultipleDaysCalendarView({
    required this.scrollController,
    required this.calendarEventsRepository,
    this.initialDate,
    this.daysAround = 3,
    this.calendarSettings = const CalendarSettings(),
    this.locale,
    this.onTap,
    this.onLongPress,
    this.reloadController,
    Key? key,
  }) : super(key: key);

  @override
  State<MultipleDaysCalendarView> createState() =>
      _MultipleDaysCalendarViewState();
}

class _MultipleDaysCalendarViewState extends State<MultipleDaysCalendarView> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<MultipleDaysCalendarCubit>(
      create: (context) => MultipleDaysCalendarCubit(
        MultipleDaysCalendarGetEventsUseCase(widget.calendarEventsRepository),
        widget.initialDate ?? DateTime.now(),
        widget.daysAround,
        widget.reloadController,
        widget.calendarSettings.minimumEventHeight,
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
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        final rowWidth = (constraints.maxWidth -
                kHourCellWidth -
                kDayNameHeight -
                kHourCellSpaceRight) /
            state.daysWithEvents.length;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FiveDaysNavigationBar(
              onTapLeft: () {
                BlocProvider.of<MultipleDaysCalendarCubit>(context)
                    .loadForDate(state.date.add(const Duration(days: -1)));
              },
              onTapRight: () {
                BlocProvider.of<MultipleDaysCalendarCubit>(context)
                    .loadForDate(state.date.add(const Duration(days: 1)));
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
    final maxNumberOfWholeDayTasks =
        state.daysWithEvents.map((e) => e.allDaysEvents.length).reduce(max);
    return Expanded(
      child: SingleChildScrollView(
        controller: widget.scrollController,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hours(
                numberOfConstantsTasks: maxNumberOfWholeDayTasks,
                calendarSettings: widget.calendarSettings),
            ...state.daysWithEvents
                .map(
                  (e) => Column(
                    children: [
                      SizedBox(
                        width: rowWidth,
                        child: SingleDayDate(
                          date: e.date,
                          locale: widget.locale,
                          calendarSettings: widget.calendarSettings,
                        ),
                      ),
                      SizedBox(
                        width: rowWidth,
                        height: (widget.calendarSettings.endHour -
                                    widget.calendarSettings.startHour) *
                                widget.calendarSettings.rowHeight +
                            maxNumberOfWholeDayTasks *
                                widget.calendarSettings.rowHeight,
                        child: GestureDetector(
                          onLongPressEnd: (details) {
                            final date = state.date;
                            widget.onLongPress?.call(DateTime(
                                date.year,
                                date.month,
                                date.day,
                                details.localPosition.dy.toInt() ~/ 60));
                          },
                          child: SingleDayTimelineWithEvents(
                            date: e.date,
                            multipleEvents: e.multipleEvents,
                            allDayEvents: e.allDaysEvents,
                            maxNumberOfWholeDayTasks: maxNumberOfWholeDayTasks,
                            action: (event) => widget.onTap?.call(event),
                            calendarSettings: widget.calendarSettings,
                          ),
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
