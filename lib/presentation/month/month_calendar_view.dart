import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:simple_calendar/bloc/month_calendar_cubit.dart';
import 'package:simple_calendar/constants/calendar_settings.dart';
import 'package:simple_calendar/extensions/datetime_extension.dart';
import 'package:simple_calendar/presentation/models/month_single_day_item.dart';
import 'package:simple_calendar/presentation/models/single_calendar_event.dart';
import 'package:simple_calendar/presentation/month/widgets/month_header.dart';
import 'package:simple_calendar/presentation/month/widgets/month_tile.dart';
import 'package:simple_calendar/repositories/calendar_events_repository.dart';
import 'package:simple_calendar/use_case/month_calendar_get_events_use_case.dart';

/// Calendar widget that shows events for a whole month
class MonthCalendarView extends StatelessWidget {
  /// Repository that provides events for calendar
  final CalendarEventsRepository calendarEventsRepository;

  /// Provides ability to reload events
  final StreamController? reloadController;

  /// Indicates which month should be shown initially
  /// If not provided, then current month will be shown
  ///
  /// Defaults to `DateTime.now`
  final DateTime? initialDate;

  /// Settings for calendar
  final CalendarSettings calendarSettings;

  /// Called when user taps on a day
  final void Function(DateTime)? onSelected;

  /// Custom header widget that will be shown above calendar
  final Widget Function(BuildContext)? monthPicker;

  /// Locale for calendar, if not provided, then system locale will be used
  ///
  /// If you want to use 'locale' parameter in calendar widgets
  /// and do not have provided GlobalMaterialLocalizations.delegate
  /// you should call [initializeDateFormatting]
  /// at least once at the beginning of your app
  final Locale? locale;

  /// Custom weekday abbreviation in weekdays row, ex. 'Mon.' for Monday
  /// If not provided, default abbreviation will be used
  final String? Function(BuildContext, int)? customWeekdayAbbreviation;

  MonthCalendarView({
    required this.calendarEventsRepository,
    this.reloadController,
    this.initialDate,
    this.calendarSettings = const CalendarSettings(),
    this.onSelected,
    this.monthPicker,
    this.locale,
    this.customWeekdayAbbreviation,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MonthCalendarCubit>(
      create: (context) => MonthCalendarCubit(
        MonthCalendarGetEventsUseCase(calendarEventsRepository),
        initialDate ?? DateTime.now(),
        reloadController,
      ),
      child: BlocBuilder<MonthCalendarCubit, MonthCalendarState>(
        builder: (ctx, state) {
          if (state is MonthCalendarChanged) {
            final groupPositions = _calculateGroupPositions(state.items);
            return _buildPage(ctx, state, groupPositions);
          } else {
            return calendarSettings.progressIndicatorBuilder != null
                ? calendarSettings.progressIndicatorBuilder!(context)
                : Center(
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

  Widget _buildPage(
    BuildContext context,
    MonthCalendarChanged state,
    Map<String, int> groupPositions,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: Column(
        children: [
          _buildMonthHeader(context, state),
          const SizedBox(height: 24.0),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    childAspectRatio: calendarSettings.monthViewAspectRatio,
                  ),
                  itemCount: state.items.length,
                  itemBuilder: (context, index) {
                    final item = state.items[index];
                    final isFirstDayOfWeek = index % 7 == 0;
                    final isLastDayOfWeek = index % 7 == 6;
                    final previousDayEvents = index > 0
                        ? state.items[index - 1].events
                        : <SingleCalendarEvent>[];
                    final nextDayEvents = index < state.items.length - 1
                        ? state.items[index + 1].events
                        : <SingleCalendarEvent>[];

                    return MonthTile(
                      onTap: () => onSelected?.call(item.date),
                      calendarSettings: calendarSettings,
                      text: item.isDayName
                          ? _dayName(context, item.date, locale)
                          : item.date.day.toString(),
                      events: item.events,
                      previousDayEvents: previousDayEvents,
                      nextDayEvents: nextDayEvents,
                      isTheSameMonth:
                          item.isDayName || state.date.isSameMonth(item.date),
                      isToday: !item.isDayName &&
                          item.date.isSameDate(DateTime.now()),
                      isDayName: item.isDayName,
                      isFirstDayOfTheWeek: isFirstDayOfWeek,
                      isLastDayOfTheWeek: isLastDayOfWeek,
                      groupPositions: groupPositions,
                      calendarWidth: constraints.maxWidth,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthHeader(BuildContext context, MonthCalendarChanged state) {
    return monthPicker?.call(context) ??
        MonthHeader(
          locale: locale,
          calendarSettings: calendarSettings,
          onTapLeft: () => _changeMonth(context, state, -1),
          onTapRight: () => _changeMonth(context, state, 1),
          dayFromMonth: state.date,
        );
  }

  void _changeMonth(
      BuildContext context, MonthCalendarChanged state, int monthDelta) {
    BlocProvider.of<MonthCalendarCubit>(context).loadForDate(
      DateTime(state.date.year, state.date.month + monthDelta, 1),
    );
  }

  String _dayName(BuildContext context, DateTime date, Locale? locale) {
    final weekdayAbbreviation =
        customWeekdayAbbreviation?.call(context, date.weekday);
    if (weekdayAbbreviation != null) return weekdayAbbreviation;
    final format = DateFormat("EEE", locale?.toLanguageTag());
    return format.format(date);
  }

  Map<String, int> _calculateGroupPositions(List<MonthSingleDayItem> items) {
    final groupPositions = <String, int>{};
    var currentPosition = 0;

    for (var i = 0; i < items.length; i++) {
      final item = items[i];
      if (item.isDayName) continue;

      for (var event in item.events) {
        final groupId = event.groupId ?? 'null';
        if (!groupPositions.containsKey(groupId)) {
          groupPositions[groupId] = currentPosition;
          currentPosition++;
        }
      }
    }

    return groupPositions;
  }
}
