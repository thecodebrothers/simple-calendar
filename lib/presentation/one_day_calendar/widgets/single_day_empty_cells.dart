import 'package:flutter/material.dart';
import 'package:simple_calendar/constants/calendar_settings.dart';
import 'package:simple_calendar/constants/constants.dart';

class EmptyCells extends StatelessWidget {
  final DateTime date;
  final int numberOfConstantsTasks;
  final CalendarSettings calendarSettings;

  const EmptyCells({
    required this.date,
    required this.numberOfConstantsTasks,
    required this.calendarSettings,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: numberOfConstantsTasks * calendarSettings.rowHeight),
        for (int i = 0; i < kHoursInCalendar; i++)
          Container(
            height: calendarSettings.rowHeight,
            decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade200)),
          )
      ],
    );
  }
}
