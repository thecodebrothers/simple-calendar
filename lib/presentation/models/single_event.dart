import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:simple_calendar/extensions/datetime_extension.dart';
import 'package:simple_calendar/presentation/models/single_calendar_event.dart';

class SingleEvent extends Equatable {
  final String name;
  final int eventStart;
  final int eventEnd;
  final String localIconName;
  final String networkIconName;
  final Color iconBackgroundColor;

  const SingleEvent({
    required this.name,
    required this.eventStart,
    required this.eventEnd,
    required this.localIconName,
    required this.networkIconName,
    required this.iconBackgroundColor,
  });

  SingleEvent.fromCalendar(SingleCalendarEvent element)
      : name = element.name,
        eventStart = element.eventStart.toMinutes(),
        eventEnd = element.eventEnd.toMinutes(),
        iconBackgroundColor = element.iconBackgroundColor,
        localIconName = element.localIconName,
        networkIconName = element.networkIconName;

  @override
  List<Object> get props => [name, eventStart, eventEnd, iconBackgroundColor, localIconName, networkIconName];
}
