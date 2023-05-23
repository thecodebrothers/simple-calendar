import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simple_calendar/constants/calendar_settings.dart';

class MonthHeader extends StatelessWidget {
  final Function() onTapLeft;
  final Function() onTapRight;
  final DateTime dayFromMonth;
  final CalendarSettings calendarSettings;
  final Locale? locale;

  const MonthHeader({
    required this.onTapLeft,
    required this.onTapRight,
    required this.dayFromMonth,
    required this.calendarSettings,
    this.locale,
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
          _monthName(locale),
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

  String _monthName(Locale? locale) {
    final format = locale != null
        ? DateFormat.yMMMM(locale.toLanguageTag())
        : DateFormat.yMMMM();

    return format.format(dayFromMonth);
  }
}
