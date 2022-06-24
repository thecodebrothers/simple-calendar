import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:simple_calendar/constants/calendar_settings.dart';

class MonthHeader extends StatelessWidget {
  final Function() onTapLeft;
  final Function() onTapRight;
  final DateTime dayFromMonth;
  final CalendarSettings calendarSettings;

  const MonthHeader({
    required this.onTapLeft,
    required this.onTapRight,
    required this.dayFromMonth,
    required this.calendarSettings,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: () => onTapLeft(),
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.keyboard_arrow_left),
          ),
        ),
        Text(
          _monthName(),
          style: calendarSettings.calendarHeaderStyle,
        ),
        InkWell(
          onTap: () => onTapRight(),
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.keyboard_arrow_right),
          ),
        ),
      ],
    );
  }

  String _monthName() {
    final format = DateFormat.yMMMM();
    return format.format(dayFromMonth);
  }
}
