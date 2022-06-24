import 'package:flutter/material.dart';
import 'package:simple_calendar/constants/calendar_settings.dart';
import 'package:simple_calendar/constants/constants.dart';
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
        SizedBox(height: numberOfConstantsTasks * calendarSettings.rowHeight + 8 + kDayNameHeight),
        for (int i = 1; i < 25; i++)
          CalendarHourCell(
            hour: i,
            calendarSettings: calendarSettings,
          ),
      ],
    );
  }
}
