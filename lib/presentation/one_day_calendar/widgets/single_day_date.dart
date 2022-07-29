import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:simple_calendar/constants/calendar_settings.dart';
import 'package:simple_calendar/constants/constants.dart';
import 'package:simple_calendar/extensions/datetime_extension.dart';

class SingleDayDate extends StatelessWidget {
  final DateTime date;
  final CalendarSettings calendarSettings;

  const SingleDayDate({
    required this.date,
    required this.calendarSettings,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: kDayNameHeight,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Text(
          _getHeader(),
          maxLines: 1,
          textAlign: TextAlign.center,
          style: calendarSettings.oneDayHeaderTextStyle,
        ),
      ),
    );
  }

  String _getHeader() {
    final format = DateFormat(calendarSettings.dayNameFormat);
    final today = DateTime.now();
    if (date.isSameDate(today)) {
      return "${format.format(date)}, ${calendarSettings.todayTranslation}";
    } else if (date.isSameMonth(today) && date.day == today.day + 1) {
      return "${format.format(date)}, ${calendarSettings.tomorrowTranslation}";
    } else if (date.isSameMonth(today) && date.day == today.day + 2) {
      return "${format.format(date)}, ${calendarSettings.dayAfterTomorrowTranslation}";
    } else if (date.isSameMonth(today) && date.day == today.day - 1) {
      return "${format.format(date)}, ${calendarSettings.yesterdayTranslation}";
    } else if (date.isSameMonth(today) && date.day == today.day - 2) {
      return "${format.format(date)}, ${calendarSettings.dayBeforeYesterdayTranslation}";
    } else {
      return format.format(date);
    }
  }
}
