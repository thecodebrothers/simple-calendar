import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_calendar/bloc/multiple_days_calendar_cubit.dart';
import 'package:simple_calendar/bloc/scale_row_height_cubit.dart';
import 'package:simple_calendar/constants/calendar_settings.dart';
import 'package:simple_calendar/constants/constants.dart';
import 'package:simple_calendar/presentation/five_days_calendar/widgets/five_days_navigation_bar.dart';
import 'package:simple_calendar/presentation/five_days_calendar/widgets/multiple_days_calendar_content.dart';
import 'package:simple_calendar/presentation/models/single_event.dart';
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

  /// Indicates the number of days to be displayed around the central day.
  ///
  /// Defaults to 3, meaning 3 days before and 3 days after the central day,
  /// totaling 7 days - a full week.
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

  /// Called when user drags event to new position
  final Function(int minutes, SingleEvent object)? onDragCompleted;

  /// Called when user changes day
  final Function(DateTime)? onDayChanged;

  /// Called when user drags event
  final Function(
    DragUpdateDetails details,
    SingleEvent object,
  )? onDragUpdate;

  /// Called when user starts dragging event
  final Function()? onDragStarted;

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
    this.onDragCompleted,
    this.onDragUpdate,
    this.onDragStarted,
    this.onDayChanged,
    Key? key,
  }) : super(key: key);

  @override
  State<MultipleDaysCalendarView> createState() =>
      _MultipleDaysCalendarViewState();
}

class _MultipleDaysCalendarViewState extends State<MultipleDaysCalendarView> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MultipleDaysCalendarCubit>(
          create: (context) => MultipleDaysCalendarCubit(
            MultipleDaysCalendarGetEventsUseCase(
                widget.calendarEventsRepository),
            widget.initialDate ?? DateTime.now(),
            widget.daysAround,
            widget.reloadController,
            widget.calendarSettings.minimumEventHeight,
          ),
        ),
        BlocProvider<ScaleRowHeightCubit>(
          create: (context) =>
              ScaleRowHeightCubit(widget.calendarSettings.rowHeight),
        ),
      ],
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
                final dateToAdd = state.date.add(const Duration(days: -1));
                BlocProvider.of<MultipleDaysCalendarCubit>(context)
                    .loadForDate(dateToAdd);
                widget.onDayChanged?.call(dateToAdd);
              },
              onTapRight: () {
                final dateToAdd = state.date.add(const Duration(days: 1));
                BlocProvider.of<MultipleDaysCalendarCubit>(context)
                    .loadForDate(dateToAdd);
                widget.onDayChanged?.call(dateToAdd);
              },
              rowWidth: rowWidth,
            ),
            _buildCalendar(state, rowWidth, context),
          ],
        );
      }),
    );
  }

  Widget _buildCalendar(
    MultipleDaysCalendarLoaded state,
    double rowWidth,
    BuildContext context,
  ) {
    return MultipleDaysCalendarContent(
      calendarState: state,
      rowWidth: rowWidth,
      scrollController: widget.scrollController,
      calendarSettings: widget.calendarSettings,
      locale: widget.locale,
      onLongPress: widget.onLongPress,
      onDragStarted: widget.onDragStarted,
      onDragCompleted: widget.onDragCompleted,
      onDragUpdate: widget.onDragUpdate,
    );
  }
}
