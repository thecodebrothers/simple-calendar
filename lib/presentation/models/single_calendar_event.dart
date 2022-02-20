import 'package:flutter/material.dart';

class SingleCalendarEvent {
  final int? id;
  final String name;
  final DateTime eventStart;
  final DateTime eventEnd;
  final bool isAllDay;
  final String localIconName;
  final String networkIconName;
  final Color iconBackgroundColor;

  SingleCalendarEvent({
    required this.name,
    required this.eventStart,
    required this.eventEnd,
    required this.isAllDay,
    required this.localIconName,
    required this.networkIconName,
    required this.iconBackgroundColor,
    this.id,
  });
}
