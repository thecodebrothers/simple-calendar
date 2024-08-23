import 'package:flutter/material.dart';
import 'package:simple_calendar/constants/calendar_settings.dart';

class EmptyCells extends StatelessWidget {
  final DateTime date;
  final int numberOfConstantsTasks;
  final CalendarSettings calendarSettings;
  final Function(DateTime)? onLongPress;
  final double rowHeight;

  const EmptyCells({
    required this.date,
    required this.numberOfConstantsTasks,
    required this.calendarSettings,
    required this.onLongPress,
    required this.rowHeight,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressEnd: (details) {
        onLongPress?.call(
          DateTime(
            date.year,
            date.month,
            date.day,
            (details.localPosition.dy.toInt() +
                    (calendarSettings.startHour * 60)) ~/
                rowHeight,
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: numberOfConstantsTasks * rowHeight),
          for (int i = 0;
              i < (calendarSettings.endHour - calendarSettings.startHour);
              i++)
            Container(
              height: rowHeight,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade200),
              ),
            )
        ],
      ),
    );
  }
}
