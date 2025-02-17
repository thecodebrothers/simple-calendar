import 'package:flutter/material.dart';
import 'package:simple_calendar/constants/calendar_constants.dart';
import 'package:simple_calendar/constants/calendar_settings.dart';
import 'package:simple_calendar/extensions/datetime_extension.dart';

class SwappAbleWrapper extends StatefulWidget {
  const SwappAbleWrapper({
    super.key,
    required this.calendarSettings,
    required this.date,
    required this.child,
    required this.scrollController,
    required this.onChanged,
  });

  final CalendarSettings calendarSettings;
  final DateTime date;
  final Widget child;
  final ScrollController scrollController;
  final Function(int offset)? onChanged;

  @override
  State<SwappAbleWrapper> createState() => _SwappAbleWrapperState();
}

class _SwappAbleWrapperState extends State<SwappAbleWrapper> {
  late PageController _pageController;
  late int _currentIndex;
  late DateTime _currentDate;

  DateTime get _maxDate =>
      widget.calendarSettings.maxDay ?? CalendarConstants.maxDate;
  DateTime get _minDate =>
      widget.calendarSettings.minDay ?? CalendarConstants.epochDate;
  int get _totalDays => _maxDate.getDayDifference(_minDate);

  @override
  void initState() {
    super.initState();
    _currentDate = widget.date;

    _regulateCurrentDate();

    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildContent(
      context,
      CustomScrollView(
        controller: widget.scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: widget.child,
          )
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, Widget child) {
    return PageView.builder(
      controller: _pageController,
      itemCount: _totalDays,
      itemBuilder: (context, index) {
        return child;
      },
      onPageChanged: _onPageChanged,
    );
  }

  void _regulateCurrentDate() {
    if (_currentDate.isBefore(_minDate)) {
      _currentDate = _minDate;
    } else if (_currentDate.isAfter(_maxDate)) {
      _currentDate = _maxDate;
    }

    _currentIndex = _currentDate.getDayDifference(_minDate);
  }

  void _onPageChanged(int index) {
    widget.onChanged?.call(index - _currentIndex);
    _currentIndex = index;
  }
}
