import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class MonthSingleDayItem extends Equatable {
  final DateTime date;
  final bool hasAnyEvents;
  final bool isDayName;
  final int? schedulesCount;
  final List<Color>? scheduleColors;

  const MonthSingleDayItem({
    required this.hasAnyEvents,
    required this.date,
    required this.isDayName,
    this.schedulesCount,
    this.scheduleColors,
  });

  @override
  List<Object?> get props => [
        date,
        hasAnyEvents,
        isDayName,
        schedulesCount,
        scheduleColors,
      ];
}
