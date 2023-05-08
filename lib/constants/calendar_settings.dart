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
  final String? dayBeforeYesterdayTranslation;
  final String? yesterdayTranslation;
  final String? todayTranslation;
  final String? tomorrowTranslation;
  final String? dayAfterTomorrowTranslation;
  final String dayNameFormat;
  final double rowHeight;
  final int startHour;
  final int endHour;
  final double? minimumEventHeight;

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
    required this.startHour,
    required this.endHour,
    this.dayBeforeYesterdayTranslation,
    this.yesterdayTranslation,
    this.todayTranslation,
    this.tomorrowTranslation,
    this.dayAfterTomorrowTranslation,
    this.rowHeight = 60.0,
    this.monthSelectedColor = const Color(0xFF0474BB),
    this.dayNameFormat = "dd MMM",
    this.minimumEventHeight,
  });
}
