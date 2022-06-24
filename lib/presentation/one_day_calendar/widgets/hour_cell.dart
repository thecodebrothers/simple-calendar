import 'package:flutter/material.dart';
import 'package:simple_calendar/constants/calendar_settings.dart';
import 'package:simple_calendar/constants/constants.dart';

class CalendarHourCell extends StatelessWidget {
  final int hour;
  final CalendarSettings calendarSettings;

  const CalendarHourCell({
    required this.hour,
    required this.calendarSettings,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: calendarSettings.rowHeight,
      child: Row(
        children: [
          SizedBox(
              width: kHourCellWidth,
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    '$hour:00',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ))),
          const SizedBox(width: kHourCellSpaceRight),
        ],
      ),
    );
  }
}
