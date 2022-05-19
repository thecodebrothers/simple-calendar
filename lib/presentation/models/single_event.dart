import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:simple_calendar/extensions/datetime_extension.dart';
import 'package:simple_calendar/presentation/models/single_calendar_event.dart';

class SingleEvent extends Equatable {
  final String singleLine;
  final String? secondLine;
  final int eventStart;
  final int eventEnd;
  final String localIconName;
  final String networkIconName;
  final Color iconBackgroundColor;
  final Color dotTileColor;
  final Color tileBackgroundColor;
  final int? id;
  final dynamic object;

  const SingleEvent({
    required this.singleLine,
    required this.eventStart,
    required this.eventEnd,
    required this.localIconName,
    required this.networkIconName,
    required this.iconBackgroundColor,
    required this.secondLine,
    required this.dotTileColor,
    required this.object,
    required this.id,
    required this.tileBackgroundColor,
  });

  SingleEvent.fromCalendar(SingleCalendarEvent element)
      : singleLine = element.singleLine,
        secondLine = element.secondLine,
        eventStart = element.eventStart.toMinutes(),
        eventEnd = element.eventEnd.toMinutes(),
        iconBackgroundColor = element.iconBackgroundColor,
        localIconName = element.localIconName,
        networkIconName = element.networkIconName,
        dotTileColor = element.dotTileColor,
        object = element.object,
        tileBackgroundColor = element.tileBackgroundColor,
        id = element.id;

  @override
  List<Object?> get props => [
        singleLine,
        secondLine,
        eventStart,
        eventEnd,
        localIconName,
        networkIconName,
        iconBackgroundColor,
        dotTileColor,
        tileBackgroundColor,
        id,
        object,
      ];
}
