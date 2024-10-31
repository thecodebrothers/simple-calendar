import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_calendar/bloc/one_day_calendar_cubit.dart';
import 'package:simple_calendar/bloc/scale_row_height_cubit.dart';
import 'package:simple_calendar/constants/calendar_settings.dart';
import 'package:simple_calendar/presentation/models/single_event.dart';
import 'package:simple_calendar/presentation/one_day_calendar/widgets/single_day.dart';
import 'package:simple_calendar/repositories/calendar_events_repository.dart';
import 'package:simple_calendar/use_case/one_day_calendar_get_events_use_case.dart';

/// Calendar widget that shows events for one day
class OneDayCalendarView extends StatelessWidget {
  final ScrollController scrollController;

  /// Repository that provides events for this calendar
  final CalendarEventsRepository calendarEventsRepository;

  /// Provides ability to reload events
  final StreamController? reloadController;

  /// Indicates which day should be shown first
  ///
  /// Defaults to `DateTime.now`
  final DateTime? initialDate;

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
  final Function(SingleEvent)? onEventTap;

  /// Called when user long presses on hour
  final Function(DateTime)? onLongPress;

  /// Called when user selects new date
  final Function(DateTime)? onSelected;

  /// Called when user drags event to new position
  final Function(int minutes, SingleEvent object)? onDragCompleted;

  /// Called when user drags event
  final Function(
    DragUpdateDetails details,
    SingleEvent object,
  )? onDragUpdate;

  /// Called when user starts dragging event
  final Function()? onDragStarted;

  /// Optional label after tomorrow date, ex. 25 May, `label`
  final String Function(BuildContext)? tomorrowDayLabel;

  /// Optional label after today date, ex. 24 May, `label`
  final String Function(BuildContext)? todayDayLabel;

  /// Optional label after yesterday date, ex. 23 May, `label`
  final String Function(BuildContext)? yesterdayDayLabel;

  /// Optional label after day before yesterday date, ex. 22 May, `label`
  final String Function(BuildContext)? beforeYesterdayDayLabel;

  /// Optional label after day after tomorrow date, ex. 26 May, `label`
  final String Function(BuildContext)? dayAfterTomorrowDayLabel;

  /// Whether to keep navigation bar and list of whole day events
  /// always visible with usage of CustomScrollView and slivers
  final bool useSlivers;

  /// Whether to enable reloading data when user pulls down the calendar
  ///
  /// Make sure to set [isScrollable] in [calendarSettings] to true to make it work
  final bool isPullToRefreshEnabled;

  const OneDayCalendarView({
    required this.scrollController,
    required this.calendarEventsRepository,
    this.onDragStarted,
    this.initialDate,
    this.calendarSettings = const CalendarSettings(),
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
    this.useSlivers = false,
    this.isPullToRefreshEnabled = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<OneDayCalendarCubit>(
          create: (_) => OneDayCalendarCubit(
            OneDayCalendarGetEventsUseCase(calendarEventsRepository),
            initialDate ?? DateTime.now(),
            reloadController,
            calendarSettings.minimumEventHeight,
          ),
        ),
        BlocProvider<ScaleRowHeightCubit>(
          create: (_) => ScaleRowHeightCubit(calendarSettings.rowHeight),
        ),
      ],
      child: Builder(builder: (context) {
        return Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: SingleDay(
            locale: locale,
            tomorrowDayLabel: tomorrowDayLabel,
            todayDayLabel: todayDayLabel,
            yesterdayDayLabel: yesterdayDayLabel,
            beforeYesterdayDayLabel: beforeYesterdayDayLabel,
            dayAfterTomorrowDayLabel: dayAfterTomorrowDayLabel,
            calendarSettings: calendarSettings,
            scrollController: scrollController,
            onEventTap: onEventTap ?? (_) {},
            onLongPress: onLongPress,
            onChanged: (date) {
              onSelected?.call(date);
              context.read<OneDayCalendarCubit>().loadForDate(date);
            },
            onDragCompleted: onDragCompleted,
            onDragUpdate: onDragUpdate,
            onDragStarted: onDragStarted,
            useSlivers: useSlivers,
            isPullToRefreshEnabled: isPullToRefreshEnabled,
          ),
        );
      }),
    );
  }
}
