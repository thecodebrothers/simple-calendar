import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:simple_calendar/constants/calendar_settings.dart';
import 'package:simple_calendar/presentation/models/same_start_time_events_container.dart';

class EmptyCellsFlexible extends StatelessWidget {
  final DateTime date;
  final CalendarSettings calendarSettings;
  final Function(DateTime)? onLongPress;
  final double rowHeight;
  final List<SameStartEventsGroup> items;

  const EmptyCellsFlexible({
    required this.date,
    required this.calendarSettings,
    required this.onLongPress,
    required this.rowHeight,
    required this.items,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressEnd: (details) {
        final rowClicked = (details.localPosition.dy.toInt()) ~/ rowHeight;
        final lastApplicable = items.lastWhereOrNull(
            (element) => element.countOfRowsAbove <= rowClicked);
        onLongPress?.call(
          DateTime(
            date.year,
            date.month,
            date.day,
            lastApplicable?.startTime.hour ??
                (details.localPosition.dy.toInt()) ~/ rowHeight,
            lastApplicable?.startTime.minute ?? 0,
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final item in items)
            Container(
              height: rowHeight * max(item.events.length, 1),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade200),
              ),
            ),
        ],
      ),
    );
  }
}
