import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simple_calendar/constants/calendar_settings.dart';
import 'package:simple_calendar/constants/constants.dart';
import 'package:simple_calendar/extensions/datetime_extension.dart';

class SingleDayDate extends StatelessWidget {
  final DateTime date;
  final CalendarSettings calendarSettings;
  final Locale? locale;
  final String Function(BuildContext)? tomorrowDayLabel;
  final String Function(BuildContext)? todayDayLabel;
  final String Function(BuildContext)? yesterdayDayLabel;
  final String Function(BuildContext)? beforeYesterdayDayLabel;
  final String Function(BuildContext)? dayAfterTomorrowDayLabel;

  const SingleDayDate({
    required this.date,
    required this.calendarSettings,
    this.locale,
    this.tomorrowDayLabel,
    this.todayDayLabel,
    this.yesterdayDayLabel,
    this.beforeYesterdayDayLabel,
    this.dayAfterTomorrowDayLabel,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: kDayNameHeight,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Text(
          _getHeader(context, locale),
          maxLines: 1,
          textAlign: TextAlign.center,
          style: calendarSettings.oneDayHeaderTextStyle,
        ),
      ),
    );
  }

  String _getHeader(BuildContext context, Locale? locale) {
    final format =
        DateFormat(calendarSettings.dayNameFormat, locale?.toLanguageTag());
    final today = DateTime.now();

    String formattedDate = format.format(date);

    if (date.isSameDate(today)) {
      return _getHeaderString(formattedDate, todayDayLabel?.call(context));
    } else if (date.isSameMonth(today) && date.day == today.day + 1) {
      return _getHeaderString(formattedDate, tomorrowDayLabel?.call(context));
    } else if (date.isSameMonth(today) && date.day == today.day + 2) {
      return _getHeaderString(
          formattedDate, dayAfterTomorrowDayLabel?.call(context));
    } else if (date.isSameMonth(today) && date.day == today.day - 1) {
      return _getHeaderString(formattedDate, yesterdayDayLabel?.call(context));
    } else if (date.isSameMonth(today) && date.day == today.day - 2) {
      return _getHeaderString(
          formattedDate, beforeYesterdayDayLabel?.call(context));
    } else {
      return formattedDate;
    }
  }

  String _getHeaderString(String formattedDate, String? translation) {
    return translation != null
        ? "${formattedDate}, $translation"
        : formattedDate;
  }
}
