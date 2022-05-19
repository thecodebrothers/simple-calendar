import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CalendarSettings {
  final TextStyle firstLineTileTextStyle;
  final TextStyle secondLineTileTextStyle;
  final double tileIconSize;
  final double iconSpacingFromText;
  final double iconBackgroundOpacity;
  final TextStyle fiveDaysHeaderTextStyle;
  final TextStyle oneDayHeaderTextStyle;
  final TextStyle calendarCurrentMonthTileStyle;
  final TextStyle calendarNotCurrentMonthTileStyle;
  final TextStyle calendarHeaderStyle;
  final TextStyle calendarMonthDayStyle;
  final Color calendarDotColor;
  final Color monthSelectedColor;
  final Color tileBackgroundColor;
  final String dayBeforeYesterdayTranslation;
  final String yesterdayTranslation;
  final String todayTranslation;
  final String tomorrowTranslation;
  final String dayAfterTomorrowTranslation;

  CalendarSettings({
    required this.firstLineTileTextStyle,
    required this.secondLineTileTextStyle,
    required this.tileIconSize,
    required this.iconSpacingFromText,
    required this.iconBackgroundOpacity,
    required this.fiveDaysHeaderTextStyle,
    required this.oneDayHeaderTextStyle,
    required this.calendarCurrentMonthTileStyle,
    required this.calendarNotCurrentMonthTileStyle,
    required this.calendarHeaderStyle,
    required this.calendarMonthDayStyle,
    required this.calendarDotColor,
    required this.dayBeforeYesterdayTranslation,
    required this.yesterdayTranslation,
    required this.todayTranslation,
    required this.tomorrowTranslation,
    required this.dayAfterTomorrowTranslation,
    this.monthSelectedColor = const Color(0xFF0474BB),
    this.tileBackgroundColor = Colors.white,
  });
}
