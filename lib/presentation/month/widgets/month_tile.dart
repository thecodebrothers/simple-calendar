import 'package:flutter/material.dart';
import 'package:simple_calendar/constants/calendar_settings.dart';
import 'package:simple_calendar/presentation/models/single_calendar_event.dart';
import 'package:simple_calendar/presentation/month/widgets/month_tile_event_indicators.dart';
import 'package:simple_calendar/presentation/month/widgets/month_tile_expanded_events_part.dart';

class MonthTile extends StatelessWidget {
  final CalendarSettings calendarSettings;
  final String text;
  final List<SingleCalendarEvent> events;
  final List<SingleCalendarEvent> previousDayEvents;
  final List<SingleCalendarEvent> nextDayEvents;
  final Map<String, int> groupPositions;
  final bool isTheSameMonth;
  final VoidCallback onTap;
  final bool isToday;
  final bool isDayName;
  final bool isFirstDayOfTheWeek;
  final bool isLastDayOfTheWeek;
  final double calendarWidth;
  final bool isExpanded;

  const MonthTile({
    required this.events,
    required this.previousDayEvents,
    required this.nextDayEvents,
    required this.calendarSettings,
    required this.text,
    required this.isTheSameMonth,
    required this.onTap,
    required this.isToday,
    required this.isDayName,
    required this.isFirstDayOfTheWeek,
    required this.isLastDayOfTheWeek,
    required this.groupPositions,
    required this.calendarWidth,
    required this.isExpanded,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        border: isExpanded
            ? Border(bottom: BorderSide(color: Colors.grey.shade300))
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: Column(
          children: [
            _buildDateTile(),
            if (!isDayName) Expanded(child: _buildEventIndicators()),
          ],
        ),
      ),
    );
  }

  Widget _buildDateTile() {
    return SizedBox(
      height: 28,
      width: 28,
      child: Material(
        color: isToday
            ? calendarSettings.monthSelectedColor
            : calendarSettings.monthDefaultDayColor,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: onTap,
          child: Center(
            child: Text(
              text,
              textAlign: TextAlign.center,
              maxLines: 1,
              style: _getTextStyle(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEventIndicators() {
    final groupedEvents = _groupEvents();

    print(isExpanded);

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: isExpanded
          ? MonthTileExpandedEventsPart(
              calendarSettings: calendarSettings,
              groupedEvents: groupedEvents,
              groupPositions: groupPositions,
            )
          : MonthTileEventIndicators(
              calendarSettings: calendarSettings,
              groupedEvents: groupedEvents,
              groupPositions: groupPositions,
              previousDayEvents: previousDayEvents,
              nextDayEvents: nextDayEvents,
              isFirstDayOfTheWeek: isFirstDayOfTheWeek,
              isLastDayOfTheWeek: isLastDayOfTheWeek,
              calendarWidth: calendarWidth,
            ),
    );
  }

  Map<String, List<SingleCalendarEvent>> _groupEvents() {
    final groupedEvents = <String, List<SingleCalendarEvent>>{};
    for (final event in events) {
      final groupId = event.groupId ?? 'null';
      if (!groupedEvents.containsKey(groupId)) {
        groupedEvents[groupId] = [];
      }
      groupedEvents[groupId]!.add(event);
    }
    return groupedEvents;
  }

  TextStyle _getTextStyle() {
    if (isDayName) return calendarSettings.calendarMonthDayStyle;
    if (isTheSameMonth) {
      return isToday
          ? calendarSettings.calendarCurrentMonthTileStyle
              .apply(color: Colors.white)
          : calendarSettings.calendarCurrentMonthTileStyle;
    }
    return calendarSettings.calendarNotCurrentMonthTileStyle;
  }
}
