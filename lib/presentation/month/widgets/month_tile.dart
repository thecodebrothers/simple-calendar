import 'package:flutter/material.dart';
import 'package:simple_calendar/constants/calendar_settings.dart';

class MonthTile extends StatelessWidget {
  final CalendarSettings calendarSettings;
  final String text;
  final bool hasAnyTask;
  final bool isTheSameMonth;
  final VoidCallback? onTap;
  final bool isToday;
  final bool isDayName;
  final List<Color> eventColors;

  const MonthTile({
    required this.hasAnyTask,
    required this.calendarSettings,
    required this.text,
    required this.isTheSameMonth,
    required this.onTap,
    required this.isToday,
    required this.isDayName,
    this.eventColors = const [],
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Column(
        children: [
          Row(
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
              if (calendarSettings.areMonthTileDotsOnTheRight && hasAnyTask)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (var i = 0; i < eventColors.length; i++) ...[
                      ClipOval(
                        child: Container(
                          height: 5,
                          width: 5,
                          color: eventColors[i],
                        ),
                      ),
                      const SizedBox(height: 2),
                    ],
                  ],
                ),
            ],
          ),
          if (!calendarSettings.areMonthTileDotsOnTheRight) ...[
            const SizedBox(height: 4),
            ClipOval(
              child: Container(
                height: 8,
                width: 8,
                color: hasAnyTask
                    ? calendarSettings.calendarDotColor
                    : Colors.transparent,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
