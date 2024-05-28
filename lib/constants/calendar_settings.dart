import 'package:flutter/material.dart';

class CalendarSettings {
  final TextStyle firstLineTileTextStyle;
  final TextStyle secondLineTileTextStyle;
  final TextStyle topLeftLineTileTextStyle;
  final TextStyle bottomRightLineTileTextStyle;
  final double tileIconSize;
  final double iconSpacingFromText;
  final double iconBackgroundOpacity;
  final TextStyle fiveDaysHeaderTextStyle;
  final TextStyle oneDayHeaderTextStyle;
  final TextStyle calendarCurrentMonthTileStyle;
  final TextStyle calendarNotCurrentMonthTileStyle;
  final TextStyle calendarHeaderStyle;
  final TextStyle calendarMonthDayStyle;
  final double allDayEventHeight;
  final TextStyle expandableTextButtonStyle;
  final Color expandableIconColor;

  // Settings for day switcher
  final bool isDaySwitcherPinned;
  final Color daySwitcherBackgroundColor;

  /// color of a dot below a day in month view if there is any event
  final Color calendarDotColor;

  /// color of a selected day in month view
  final Color monthSelectedColor;

  /// format of a day name in one day calendar view
  final String dayNameFormat;

  /// height of a row in one day and multiple days calendar views
  final double rowHeight;

  /// start hour of a calendar in one day and multiple days calendar views
  /// startHour must be greater or equal to 0 and less than endHour
  /// and between 0 and 23
  final int startHour;

  /// end hour of a calendar in one day and multiple days calendar views
  ///
  /// endHour must be greater than startHour and between 1 and 24
  final int endHour;

  /// minimum height of an event in one day and multiple days calendar views
  final double? minimumEventHeight;

  /// enable drag and drop functionality
  final bool dragEnabled;

  /// enables zooming the calendar in and out
  final bool zoomEnabled;

  const CalendarSettings({
    this.firstLineTileTextStyle = const TextStyle(),
    this.secondLineTileTextStyle = const TextStyle(),
    this.topLeftLineTileTextStyle = const TextStyle(),
    this.bottomRightLineTileTextStyle = const TextStyle(),
    this.fiveDaysHeaderTextStyle = const TextStyle(),
    this.oneDayHeaderTextStyle = const TextStyle(),
    this.calendarCurrentMonthTileStyle = const TextStyle(),
    this.calendarNotCurrentMonthTileStyle = const TextStyle(),
    this.calendarHeaderStyle = const TextStyle(),
    this.calendarMonthDayStyle = const TextStyle(),
    this.expandableTextButtonStyle = const TextStyle(),
    this.expandableIconColor = Colors.black,
    this.tileIconSize = 24.0,
    this.iconSpacingFromText = 8.0,
    this.iconBackgroundOpacity = 0.2,
    this.calendarDotColor = Colors.lightBlue,
    this.startHour = 0,
    this.endHour = 24,
    this.rowHeight = 60.0,
    this.allDayEventHeight = 60,
    this.isDaySwitcherPinned = false,
    this.daySwitcherBackgroundColor = Colors.transparent,
    this.monthSelectedColor = const Color(0xFF0474BB),
    this.dayNameFormat = "dd MMM",
    this.minimumEventHeight,
    this.dragEnabled = false,
    this.zoomEnabled = false,
  })  : assert(startHour >= 0 && startHour < 24),
        assert(endHour > 0 && endHour <= 24),
        assert(startHour < endHour);

  CalendarSettings copyWith({
    TextStyle? firstLineTileTextStyle,
    TextStyle? secondLineTileTextStyle,
    TextStyle? topLeftLineTileTextStyle,
    TextStyle? bottomRightLineTileTextStyle,
    double? tileIconSize,
    double? iconSpacingFromText,
    double? iconBackgroundOpacity,
    TextStyle? fiveDaysHeaderTextStyle,
    TextStyle? oneDayHeaderTextStyle,
    TextStyle? calendarCurrentMonthTileStyle,
    TextStyle? calendarNotCurrentMonthTileStyle,
    TextStyle? calendarHeaderStyle,
    TextStyle? calendarMonthDayStyle,
    TextStyle? expandableTextButtonStyle,
    Color? expandableIconColor,
    Color? calendarDotColor,
    Color? monthSelectedColor,
    String? dayNameFormat,
    double? rowHeight,
    double? allDayEventHeight,
    int? startHour,
    int? endHour,
    double? minimumEventHeight,
    double? hourCustomHeight,
    bool? dragEnabled,
  }) {
    return CalendarSettings(
      firstLineTileTextStyle:
          firstLineTileTextStyle ?? this.firstLineTileTextStyle,
      secondLineTileTextStyle:
          secondLineTileTextStyle ?? this.secondLineTileTextStyle,
      topLeftLineTileTextStyle:
          topLeftLineTileTextStyle ?? this.topLeftLineTileTextStyle,
      bottomRightLineTileTextStyle:
          bottomRightLineTileTextStyle ?? this.bottomRightLineTileTextStyle,
      tileIconSize: tileIconSize ?? this.tileIconSize,
      iconSpacingFromText: iconSpacingFromText ?? this.iconSpacingFromText,
      iconBackgroundOpacity:
          iconBackgroundOpacity ?? this.iconBackgroundOpacity,
      fiveDaysHeaderTextStyle:
          fiveDaysHeaderTextStyle ?? this.fiveDaysHeaderTextStyle,
      oneDayHeaderTextStyle:
          oneDayHeaderTextStyle ?? this.oneDayHeaderTextStyle,
      calendarCurrentMonthTileStyle:
          calendarCurrentMonthTileStyle ?? this.calendarCurrentMonthTileStyle,
      calendarNotCurrentMonthTileStyle: calendarNotCurrentMonthTileStyle ??
          this.calendarNotCurrentMonthTileStyle,
      calendarHeaderStyle: calendarHeaderStyle ?? this.calendarHeaderStyle,
      calendarMonthDayStyle:
          calendarMonthDayStyle ?? this.calendarMonthDayStyle,
      calendarDotColor: calendarDotColor ?? this.calendarDotColor,
      monthSelectedColor: monthSelectedColor ?? this.monthSelectedColor,
      dayNameFormat: dayNameFormat ?? this.dayNameFormat,
      allDayEventHeight: allDayEventHeight ?? this.allDayEventHeight,
      rowHeight: rowHeight ?? this.rowHeight,
      startHour: startHour ?? this.startHour,
      endHour: endHour ?? this.endHour,
      minimumEventHeight: minimumEventHeight ?? this.minimumEventHeight,
      expandableTextButtonStyle:
          expandableTextButtonStyle ?? this.expandableTextButtonStyle,
      dragEnabled: dragEnabled ?? this.dragEnabled,
    );
  }
}
