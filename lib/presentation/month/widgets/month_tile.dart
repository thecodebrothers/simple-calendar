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
  final Color? scheduleColor;
  final int? scheduleCount;

  const MonthTile({
    required this.hasAnyTask,
    required this.calendarSettings,
    required this.text,
    required this.isTheSameMonth,
    required this.onTap,
    required this.isToday,
    required this.isDayName,
    this.scheduleCount,
    this.scheduleColor,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
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
              if (scheduleCount != null && hasAnyTask)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (var i = 0; i < scheduleCount!; i++) ...[
                      ClipOval(
                        child: Container(
                          height: 5,
                          width: 5,
                          color: scheduleColor,
                        ),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                    ],
                  ],
                ),
            ],
          ),
          if (scheduleCount == null) ...[
            const SizedBox(height: 4),
            ClipOval(
              child: Container(
                height: 8,
                width: 8,
                color: hasAnyTask
                    ? calendarSettings.monthSelectedColor
                    : Colors.transparent,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
