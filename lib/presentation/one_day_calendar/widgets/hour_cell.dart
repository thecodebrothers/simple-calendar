import 'package:flutter/material.dart';
import 'package:simple_calendar/constants/constants.dart';

class CalendarHourCell extends StatelessWidget {
  final int hour;

  const CalendarHourCell({required this.hour, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: kCellHeight,
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
