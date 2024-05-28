import 'package:flutter/material.dart';
import 'package:simple_calendar/constants/calendar_settings.dart';
import 'package:simple_calendar/presentation/five_days_calendar/widgets/five_days_date.dart';

class FiveDaysEmptyCells extends StatelessWidget {
  final DateTime date;
  final double rowWidth;
  final CalendarSettings calendarSettings;
  final double rowHeight;

  const FiveDaysEmptyCells({
    required this.date,
    required this.rowWidth,
    required this.calendarSettings,
    required this.rowHeight,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FiveDaysDate(
          date: date,
          rowWidth: rowWidth,
        ),
        for (int i = 0; i < 24; i++)
          Container(
            height: rowHeight,
            width: rowWidth,
            decoration:
                BoxDecoration(border: Border.all(color: Colors.grey.shade200)),
          )
      ],
    );
  }
}
