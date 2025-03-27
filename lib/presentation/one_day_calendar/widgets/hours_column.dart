import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simple_calendar/constants/calendar_settings.dart';
import 'package:simple_calendar/presentation/models/same_start_time_events_container.dart';
import 'package:simple_calendar/presentation/one_day_calendar/widgets/hour_cell.dart';

class Hours extends StatelessWidget {
  const Hours({
    required this.calendarSettings,
    required this.rowHeight,
    this.itemsGroupedByTime,
    this.topPadding = 0,
    Key? key,
  }) : super(key: key);

  final CalendarSettings calendarSettings;
  final List<SameStartEventsGroup>? itemsGroupedByTime;
  final double topPadding;
  final double rowHeight;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: topPadding),
        if (calendarSettings.flexibleHoursMode && itemsGroupedByTime != null)
          ...getCellsforFlexibleMode()
        else
          ...getCellsforEqualMode()
      ],
    );
  }

  List<Widget> getCellsforEqualMode() {
    return [
      for (int i = calendarSettings.startHour;
          i < calendarSettings.endHour + 1;
          i++)
        CalendarHourCell(
          hour: '$i:00',
          height: rowHeight,
          calendarSettings: calendarSettings,
        ),
    ];
  }

  List<Widget> getCellsforFlexibleMode() {
    return [
      for (final item in itemsGroupedByTime!)
        CalendarHourCell(
          hour: DateFormat('HH:mm').format(item.startTime),
          height: rowHeight * max(item.events.length, 1),
          calendarSettings: calendarSettings,
        ),
    ];
  }
}
