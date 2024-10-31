import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:simple_calendar/bloc/month_calendar_cubit.dart';
import 'package:simple_calendar/constants/calendar_settings.dart';
import 'package:simple_calendar/extensions/datetime_extension.dart';
import 'package:simple_calendar/presentation/models/month_single_day_item.dart';
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
  final Widget Function(
    BuildContext,
    Future<void> Function() refresh,
  )? monthPicker;

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

  /// Whether to reload data when user taps on a different date.
  /// Additional action performed right after onSelected
  final bool shouldReloadIfDayHasChanged;

  /// Whether to enable reloading data when user pulls down the calendar
  ///
  /// Make sure to set [isScrollable] in [calendarSettings] to true to make it work
  final bool isPullToRefreshEnabled;

  MonthCalendarView({
    required this.calendarEventsRepository,
    this.initialDate,
    this.calendarSettings = const CalendarSettings(),
    this.onSelected,
    this.monthPicker,
    this.locale,
    this.customWeekdayAbbreviation,
    this.shouldReloadIfDayHasChanged = false,
    this.isPullToRefreshEnabled = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MonthCalendarCubit>(
      create: (_) => MonthCalendarCubit(
        MonthCalendarGetEventsUseCase(calendarEventsRepository),
        initialDate ?? DateTime.now(),
      ),
      child: BlocBuilder<MonthCalendarCubit, MonthCalendarState>(
        builder: (context, state) {
          if (state is MonthCalendarChanged) {
            return isPullToRefreshEnabled
                ? RefreshIndicator(
                    onRefresh: () async => await _onRefresh(context, state),
                    child: _buildPage(context, state),
                  )
                : _buildPage(context, state);
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
          monthPicker?.call(
                context,
                () async => await _onRefresh(context, state),
              ) ??
              _buildDefaultHeader(context, state),
          const SizedBox(height: 24.0),
          Expanded(child: _buildBody(context, state)),
        ],
      ),
    );
  }

  Widget _buildDefaultHeader(BuildContext context, MonthCalendarChanged state) {
    return MonthHeader(
      locale: locale,
      calendarSettings: calendarSettings,
      onTapLeft: () {
        final cubit = context.read<MonthCalendarCubit>();
        cubit.loadForDate(
          DateTime(state.date.year, state.date.month - 1, state.date.day),
        );
      },
      onTapRight: () {
        final cubit = context.read<MonthCalendarCubit>();
        cubit.loadForDate(
          DateTime(state.date.year, state.date.month + 1, state.date.day),
        );
      },
      dayFromMonth: state.date,
    );
  }

  Widget _buildBody(BuildContext context, MonthCalendarChanged state) {
    return GridView.count(
      physics: !calendarSettings.isScrollable
          ? const NeverScrollableScrollPhysics()
          : null,
      crossAxisCount: 7,
      children: state.items.map((e) => _buildTile(context, state, e)).toList(),
    );
  }

  Widget _buildTile(
    BuildContext context,
    MonthCalendarChanged state,
    MonthSingleDayItem item,
  ) {
    return MonthTile(
      onTap: item.isDayName
          ? null
          : () {
              onSelected?.call(item.date);
              if (shouldReloadIfDayHasChanged && state.date != item.date) {
                context.read<MonthCalendarCubit>().loadForDate(item.date);
              }
            },
      calendarSettings: calendarSettings,
      text: item.isDayName
          ? _dayName(context, item.date, locale)
          : item.date.day.toString(),
      hasAnyTask: !item.isDayName && item.hasAnyEvents,
      isTheSameMonth: item.isDayName || state.date.isSameMonth(item.date),
      isToday: !item.isDayName && item.date.isSameDate(DateTime.now()),
      isDayName: item.isDayName,
      eventColors: item.eventColors,
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

  Future<void> _onRefresh(
    BuildContext context,
    MonthCalendarChanged state,
  ) async {
    await context.read<MonthCalendarCubit>().loadForDate(state.date);
  }
}
