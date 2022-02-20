import 'package:flutter/material.dart';
import 'package:simple_calendar/constants/constants.dart';

class EmptyCells extends StatelessWidget {
  final DateTime date;
  final int numberOfConstantsTasks;

  const EmptyCells({
    required this.date,
    required this.numberOfConstantsTasks,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: numberOfConstantsTasks * kCellHeight),
        for (int i = 0; i < kHoursInCalendar; i++)
          Container(
            height: kCellHeight,
            decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade200)),
          )
      ],
    );
  }
}
