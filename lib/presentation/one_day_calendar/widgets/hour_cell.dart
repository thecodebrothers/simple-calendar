import 'package:flutter/material.dart';
import 'package:simple_calendar/constants/calendar_settings.dart';
import 'package:simple_calendar/constants/constants.dart';

class CalendarHourCell extends StatelessWidget {
  final int hour;
  final CalendarSettings calendarSettings;
  final double? height;
  final String Function(BuildContext, TimeOfDay)? timelineHourFormatter;

  const CalendarHourCell({
    required this.hour,
    required this.calendarSettings,
    this.height,
    this.timelineHourFormatter,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final timeOfDay = TimeOfDay(hour: hour, minute: 0);
    final formattedHour = timelineHourFormatter != null
        ? timelineHourFormatter!(context, timeOfDay)
        : '$hour:00';

    return SizedBox(
      height: height,
      child: Row(
        children: [
          SizedBox(
              width: kHourCellWidth,
              child: Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    formattedHour,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade500,
                    ),
                  ))),
          const SizedBox(width: kHourCellSpaceRight),
        ],
      ),
    );
  }
}
