import 'package:flutter/material.dart';
import 'package:simple_calendar/constants/calendar_settings.dart';
import 'package:simple_calendar/presentation/one_day_calendar/widgets/hour_cell.dart';

class Hours extends StatelessWidget {
  final int numberOfConstantsTasks;
  final CalendarSettings calendarSettings;
  final double topPadding;
  final double rowHeight;

  const Hours({
    required this.numberOfConstantsTasks,
    required this.calendarSettings,
    required this.rowHeight,
    this.topPadding = 0,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: topPadding),
        for (int i = calendarSettings.startHour;
            i < calendarSettings.endHour + 1;
            i++)
          CalendarHourCell(
            hour: i,
            height: rowHeight,
            calendarSettings: calendarSettings,
          ),
      ],
    );
  }
}
