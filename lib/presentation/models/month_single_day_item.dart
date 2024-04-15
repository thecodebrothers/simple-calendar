import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class MonthSingleDayItem extends Equatable {
  final DateTime date;
  final bool hasAnyEvents;
  final bool isDayName;
  final int? schedulesCount;
  final Color? scheduleColor;

  const MonthSingleDayItem({
    required this.hasAnyEvents,
    required this.date,
    required this.isDayName,
    this.schedulesCount,
    this.scheduleColor,
  });

  @override
  List<Object?> get props => [
        date,
        hasAnyEvents,
        isDayName,
        schedulesCount,
        scheduleColor,
      ];
}
