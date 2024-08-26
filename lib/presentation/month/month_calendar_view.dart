import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:simple_calendar/bloc/month_calendar_cubit.dart';
import 'package:simple_calendar/constants/calendar_settings.dart';
import 'package:simple_calendar/extensions/datetime_extension.dart';
import 'package:simple_calendar/presentation/month/widgets/month_header.dart';
import 'package:simple_calendar/presentation/month/widgets/month_tile.dart';
import 'package:simple_calendar/repositories/calendar_events_repository.dart';
import 'package:simple_calendar/use_case/month_calendar_get_events_use_case.dart';

/// Calendar widget that shows events for a whole month
class MonthCalendarView extends StatelessWidget {
  /// Repository that provides events for calendar
  final CalendarEventsRepository calendarEventsRepository;

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
      ),
      child: BlocBuilder<MonthCalendarCubit, MonthCalendarState>(
        builder: (ctx, state) {
          if (state is MonthCalendarChanged) {
            return _buildPage(ctx, state);
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

  Widget _buildPage(BuildContext context, MonthCalendarChanged state) {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: Column(
        children: [
          monthPicker?.call(context) ??
              MonthHeader(
                locale: locale,
                calendarSettings: calendarSettings,
                onTapLeft: () {
                  BlocProvider.of<MonthCalendarCubit>(context).loadForDate(
                      DateTime(state.date.year, state.date.month - 1,
                          state.date.day));
                },
                onTapRight: () {
                  BlocProvider.of<MonthCalendarCubit>(context).loadForDate(
                      DateTime(state.date.year, state.date.month + 1,
                          state.date.day));
                },
                dayFromMonth: state.date,
              ),
          const SizedBox(height: 24.0),
          Expanded(
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return GridView.count(
                  physics: !calendarSettings.isScrollable
                      ? const NeverScrollableScrollPhysics()
                      : null,
                  crossAxisCount: 7,
                  children: state.items
                      .map(
                        (e) => MonthTile(
                          onTap: e.isDayName
                              ? null
                              : () {
                                  onSelected?.call(e.date);
                                  if (state.date != e.date)
                                    BlocProvider.of<MonthCalendarCubit>(context)
                                        .loadForDate(e.date);
                                },
                          calendarSettings: calendarSettings,
                          text: e.isDayName
                              ? _dayName(context, e.date, locale)
                              : e.date.day.toString(),
                          hasAnyTask: !e.isDayName && e.hasAnyEvents,
                          isTheSameMonth:
                              e.isDayName || state.date.isSameMonth(e.date),
                          isToday:
                              !e.isDayName && e.date.isSameDate(DateTime.now()),
                          isDayName: e.isDayName,
                          scheduleColors: e.scheduleColors,
                          scheduleCount: e.schedulesCount,
                        ),
                      )
                      .toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _dayName(BuildContext context, DateTime date, Locale? locale) {
    final weekdayAbbreviation =
        customWeekdayAbbreviation?.call(context, date.weekday);

    if (weekdayAbbreviation != null) {
      return weekdayAbbreviation;
    }

    final format = DateFormat("EEE", locale?.toLanguageTag());
    return format.format(date);
  }
}
