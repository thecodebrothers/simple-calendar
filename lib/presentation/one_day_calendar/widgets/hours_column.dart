import 'package:flutter/material.dart';
import 'package:simple_calendar/constants/calendar_settings.dart';
import 'package:simple_calendar/presentation/one_day_calendar/widgets/hour_cell.dart';

class Hours extends StatelessWidget {
  final int numberOfConstantsTasks;
  final CalendarSettings calendarSettings;

  const Hours({
    required this.numberOfConstantsTasks,
    required this.calendarSettings,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = calendarSettings.startHour;
            i < calendarSettings.endHour + 1;
            i++)
          CalendarHourCell(
            hour: i,
            height: calendarSettings.rowHeight,
            calendarSettings: calendarSettings,
          ),
      ],
    );
  }
}
