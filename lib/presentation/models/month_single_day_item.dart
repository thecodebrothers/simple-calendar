import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class MonthSingleDayItem extends Equatable {
  final DateTime date;
  final bool hasAnyEvents;
  final bool isDayName;
  final List<Color> eventColors;

  const MonthSingleDayItem({
    required this.hasAnyEvents,
    required this.date,
    required this.isDayName,
    this.eventColors = const [],
  });

  @override
  List<Object?> get props => [date, hasAnyEvents, isDayName, eventColors];
}
