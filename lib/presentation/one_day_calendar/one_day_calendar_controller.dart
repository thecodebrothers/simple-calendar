import 'package:flutter/material.dart';

class OneDayCalendarController {
  final ValueNotifier<DateTime> _dateNotifier;

  OneDayCalendarController({DateTime? initialDate})
      : _dateNotifier = ValueNotifier<DateTime>(initialDate ?? DateTime.now());

  ValueNotifier<DateTime> get dateNotifier => _dateNotifier;

  void updateDate(DateTime newDate) {
    _dateNotifier.value = newDate;
  }

  void addListener(VoidCallback listener) {
    _dateNotifier.addListener(listener);
  }

  void removeListener(VoidCallback listener) {
    _dateNotifier.removeListener(listener);
  }
}
