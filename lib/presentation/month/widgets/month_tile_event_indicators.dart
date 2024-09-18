import 'package:flutter/material.dart';
import 'package:simple_calendar/constants/calendar_settings.dart';
import 'package:simple_calendar/presentation/models/single_calendar_event.dart';

class MonthTileEventIndicators extends StatelessWidget {
  const MonthTileEventIndicators({
    required this.calendarSettings,
    required this.groupedEvents,
    required this.groupPositions,
    required this.previousDayEvents,
    required this.nextDayEvents,
    required this.isFirstDayOfTheWeek,
    required this.isLastDayOfTheWeek,
    required this.calendarWidth,
    super.key,
  });

  final CalendarSettings calendarSettings;
  final Map<String, List<SingleCalendarEvent>> groupedEvents;
  final Map<String, int> groupPositions;
  final List<SingleCalendarEvent> previousDayEvents;
  final List<SingleCalendarEvent> nextDayEvents;
  final bool isFirstDayOfTheWeek;
  final bool isLastDayOfTheWeek;
  final double calendarWidth;

  @override
  Widget build(BuildContext context) {
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

  bool shouldExtendEventToPreviousDay(SingleCalendarEvent event) {
    if (isFirstDayOfTheWeek) return false;
    return previousDayEvents.any((e) => e.groupId == event.groupId);
  }

  bool shouldExtendEventToNextDay(SingleCalendarEvent event) {
    if (isLastDayOfTheWeek) return false;
    return nextDayEvents.any((e) => e.groupId == event.groupId);
  }
}
