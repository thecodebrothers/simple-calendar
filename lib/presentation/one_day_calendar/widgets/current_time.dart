import 'package:flutter/material.dart';
import 'package:simple_calendar/constants/calendar_settings.dart';

class CurrentTime extends StatelessWidget {
  final int numberOfConstantsTasks;
  final CalendarSettings calendarSettings;

  const CurrentTime({
    required this.numberOfConstantsTasks,
    required this.calendarSettings,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: numberOfConstantsTasks * calendarSettings.rowHeight +
          DateTime.now().hour * calendarSettings.rowHeight +
          DateTime.now().minute -
          (calendarSettings.endHour - calendarSettings.startHour) * calendarSettings.rowHeight,
      left: 0,
      right: 0,
      child: Container(
        height: 2,
        decoration: const BoxDecoration(color: Colors.black),
      ),
    );
  }
}
