import 'package:flutter/material.dart';
import 'package:simple_calendar/constants/calendar_settings.dart';

class MonthTile extends StatelessWidget {
  final CalendarSettings calendarSettings;
  final String text;
  final bool hasAnyTask;
  final bool isTheSameMonth;

  const MonthTile({
    required this.hasAnyTask,
    required this.calendarSettings,
    required this.text,
    required this.isTheSameMonth,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: () {},
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              textAlign: TextAlign.center,
              maxLines: 1,
              style: isTheSameMonth
                  ? calendarSettings.calendarCurrentMonthTileStyle
                  : calendarSettings.calendarNotCurrentMonthTileStyle,
            ),
            const SizedBox(height: 8),
            Container(
              height: 6,
              width: 6,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                color: hasAnyTask ? calendarSettings.calendarDotColor : Colors.transparent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
