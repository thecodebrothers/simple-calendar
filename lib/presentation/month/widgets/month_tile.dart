import 'package:flutter/material.dart';
import 'package:simple_calendar/constants/calendar_settings.dart';

class MonthTile extends StatelessWidget {
  final CalendarSettings calendarSettings;
  final String text;
  final bool hasAnyTask;
  final bool isTheSameMonth;
  final VoidCallback onTap;
  final bool isToday;
  final bool isDayName;

  const MonthTile({
    required this.hasAnyTask,
    required this.calendarSettings,
    required this.text,
    required this.isTheSameMonth,
    required this.onTap,
    required this.isToday,
    required this.isDayName,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Column(
        children: [
          ClipOval(
            child: SizedBox(
              height: 32,
              width: 32,
              child: Material(
                color: isToday ? calendarSettings.monthSelectedColor : null,
                child: InkWell(
                  onTap: onTap,
                  child: Center(
                    child: Text(
                      text,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      style: isDayName
                          ? calendarSettings.calendarMonthDayStyle
                          : (isTheSameMonth
                              ? (isToday
                                  ? calendarSettings
                                      .calendarCurrentMonthTileStyle
                                      .apply(color: Colors.white)
                                  : calendarSettings
                                      .calendarCurrentMonthTileStyle)
                              : calendarSettings
                                  .calendarNotCurrentMonthTileStyle),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          ClipOval(
            child: Container(
              height: 8,
              width: 8,
              color: hasAnyTask
                  ? calendarSettings.monthSelectedColor
                  : Colors.transparent,
            ),
          )
        ],
      ),
    );
  }
}
