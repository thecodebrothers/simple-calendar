import 'package:flutter/material.dart';
import 'package:simple_calendar/constants/constants.dart';
import 'package:simple_calendar/presentation/five_days_calendar/widgets/five_days_date.dart';

class FiveDaysEmptyCells extends StatelessWidget {
  final DateTime date;
  final double rowWidth;

  const FiveDaysEmptyCells({required this.date, required this.rowWidth, Key? key}) : super(key: key);

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
            height: kCellHeight,
            width: rowWidth,
            decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade200)),
          )
      ],
    );
  }
}
