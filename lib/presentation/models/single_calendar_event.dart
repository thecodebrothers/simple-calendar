import 'package:flutter/material.dart';

class SingleCalendarEvent {
  final int? id;
  final String singleLine;
  final String? secondLine;
  final DateTime eventStart;
  final DateTime eventEnd;
  final bool isAllDay;
  final String localIconName;
  final String networkIconName;
  final Color iconBackgroundColor;
  final Color dotTileColor;
  final dynamic object;

  SingleCalendarEvent({
    required this.singleLine,
    required this.eventStart,
    required this.eventEnd,
    required this.isAllDay,
    required this.localIconName,
    required this.networkIconName,
    required this.iconBackgroundColor,
    required this.object,
    required this.dotTileColor,
    this.id,
    this.secondLine,
  });
}
