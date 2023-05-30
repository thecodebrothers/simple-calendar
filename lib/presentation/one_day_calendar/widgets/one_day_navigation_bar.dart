import 'package:flutter/material.dart';
import 'package:simple_calendar/constants/calendar_settings.dart';
import 'package:simple_calendar/presentation/one_day_calendar/widgets/single_day_date.dart';

class OneDayNavigationBar extends StatefulWidget {
  final Function() onTapLeft;
  final Function() onTapRight;
  final DateTime date;
  final CalendarSettings calendarSettings;
  final Locale? locale;

  final String Function(BuildContext)? tomorrowDayLabel;
  final String Function(BuildContext)? todayDayLabel;
  final String Function(BuildContext)? yesterdayDayLabel;
  final String Function(BuildContext)? beforeYesterdayDayLabel;
  final String Function(BuildContext)? dayAfterTomorrowDayLabel;

  const OneDayNavigationBar({
    required this.onTapLeft,
    required this.onTapRight,
    required this.date,
    required this.calendarSettings,
    this.locale,
    this.tomorrowDayLabel,
    this.todayDayLabel,
    this.yesterdayDayLabel,
    this.beforeYesterdayDayLabel,
    this.dayAfterTomorrowDayLabel,
    Key? key,
  }) : super(key: key);

  @override
  State<OneDayNavigationBar> createState() => _OneDayNavigationBarState();
}

class _OneDayNavigationBarState extends State<OneDayNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: widget.onTapLeft,
            child: const Padding(
              padding: EdgeInsets.all(10.0),
              child: Icon(Icons.keyboard_arrow_left),
            ),
          ),
          Expanded(
            child: SingleDayDate(
              locale: widget.locale,
              tomorrowDayLabel: widget.tomorrowDayLabel,
              todayDayLabel: widget.todayDayLabel,
              yesterdayDayLabel: widget.yesterdayDayLabel,
              beforeYesterdayDayLabel: widget.beforeYesterdayDayLabel,
              dayAfterTomorrowDayLabel: widget.dayAfterTomorrowDayLabel,
              date: widget.date,
              calendarSettings: widget.calendarSettings,
            ),
          ),
          InkWell(
            onTap: widget.onTapRight,
            child: const Padding(
              padding: EdgeInsets.all(10.0),
              child: Icon(Icons.keyboard_arrow_right),
            ),
          ),
        ],
      ),
    );
  }
}
