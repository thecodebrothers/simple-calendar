import 'package:flutter/material.dart';
import 'package:simple_calendar/constants/calendar_settings.dart';
import 'package:simple_calendar/presentation/models/single_calendar_event.dart';

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
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: Column(
        children: [
          _buildDateTile(),
          if (!isDayName) Expanded(child: _buildEventIndicators()),
        ],
      ),
    );
  }

  Widget _buildDateTile() {
    return SizedBox(
      height: 28,
      width: 28,
      child: Material(
        color: isToday ? calendarSettings.monthSelectedColor : null,
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

    return Stack(
      children: groupedEvents.entries.map((entry) {
        final event = entry.value.first;
        final extendLeft = shouldExtendEventToPreviousDay(event);
        final extendRight = shouldExtendEventToNextDay(event);
        final position = groupPositions[entry.key] ?? 0;

        return Positioned(
          left: 0,
          right: 0,
          top: position * 6.0 + 2,
          height: 4,
          child: Stack(
            children: [
              if (extendLeft) _buildLeftOverlapLine(event),
              _buildEventIndicator(event, extendLeft, extendRight),
              if (extendRight) _buildRightOverlapLine(event),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildEventIndicator(
      SingleCalendarEvent event,
      bool extendLeft,
      bool extendRight,
      ) {
    return Center(
      child: Container(
        width: 16,
        height: 4,
        decoration: BoxDecoration(
          color: event.groupColor ?? calendarSettings.monthSelectedColor,
          borderRadius: BorderRadius.horizontal(
            left: extendLeft ? Radius.zero : const Radius.circular(2),
            right: extendRight ? Radius.zero : const Radius.circular(2),
          ),
        ),
      ),
    );
  }

  Widget _buildRightOverlapLine(SingleCalendarEvent event) {
    return Align(
      alignment: Alignment.centerRight,
      child: Transform.translate(
        offset: Offset(calendarWidth / 16, 0),
        child: _buildEventIndicatorOverlapLine(event),
      ),
    );
  }

  Widget _buildLeftOverlapLine(SingleCalendarEvent event) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Transform.translate(
        offset: Offset(-calendarWidth / 16, 0),
        child: _buildEventIndicatorOverlapLine(event),
      ),
    );
  }

  Widget _buildEventIndicatorOverlapLine(SingleCalendarEvent event) {
    return Container(
      decoration: BoxDecoration(
        color: event.groupColor ?? calendarSettings.monthSelectedColor,
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

  bool shouldExtendEventToPreviousDay(SingleCalendarEvent event) {
    if (isFirstDayOfTheWeek) return false;
    return previousDayEvents.any((e) => e.groupId == event.groupId);
  }

  bool shouldExtendEventToNextDay(SingleCalendarEvent event) {
    if (isLastDayOfTheWeek) return false;
    return nextDayEvents.any((e) => e.groupId == event.groupId);
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
