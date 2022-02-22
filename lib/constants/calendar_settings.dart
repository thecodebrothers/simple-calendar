import 'package:flutter/cupertino.dart';

class CalendarSettings {
  final TextStyle firstLineTileTextStyle;
  final TextStyle secondLineTileTextStyle;
  final TextStyle fiveDaysHeaderTextStyle;
  final TextStyle oneDayHeaderTextStyle;
  final TextStyle calendarCurrentMonthTileStyle;
  final TextStyle calendarNotCurrentMonthTileStyle;
  final TextStyle calendarHeaderStyle;
  final Color calendarDotColor;
  final String dayBeforeYesterdayTranslation;
  final String yesterdayTranslation;
  final String todayTranslation;
  final String tomorrowTranslation;
  final String dayAfterTomorrowTranslation;

  CalendarSettings({
    required this.firstLineTileTextStyle,
    required this.secondLineTileTextStyle,
    required this.fiveDaysHeaderTextStyle,
    required this.oneDayHeaderTextStyle,
    required this.calendarCurrentMonthTileStyle,
    required this.calendarNotCurrentMonthTileStyle,
    required this.calendarHeaderStyle,
    required this.calendarDotColor,
    required this.dayBeforeYesterdayTranslation,
    required this.yesterdayTranslation,
    required this.todayTranslation,
    required this.tomorrowTranslation,
    required this.dayAfterTomorrowTranslation,
  });
}
