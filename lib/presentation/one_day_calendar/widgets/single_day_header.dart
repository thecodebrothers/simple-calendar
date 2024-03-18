import 'package:flutter/material.dart';
import 'package:simple_calendar/bloc/one_day_calendar_cubit.dart';
import 'package:simple_calendar/constants/calendar_settings.dart';
import 'package:simple_calendar/presentation/one_day_calendar/widgets/one_day_navigation_bar.dart';

class SingleDayHeader extends StatelessWidget {
  const SingleDayHeader({
    super.key,
    required this.calendarSettings,
    this.locale,
    this.tomorrowDayLabel,
    this.todayDayLabel,
    this.yesterdayDayLabel,
    this.beforeYesterdayDayLabel,
    this.dayAfterTomorrowDayLabel,
    required this.state,
    required this.onTapLeft,
    required this.onTapRight,
  });

  final Function() onTapLeft;
  final Function() onTapRight;
  final CalendarSettings calendarSettings;
  final Locale? locale;
  final String Function(BuildContext)? tomorrowDayLabel;
  final String Function(BuildContext)? todayDayLabel;
  final String Function(BuildContext)? yesterdayDayLabel;
  final String Function(BuildContext)? beforeYesterdayDayLabel;
  final String Function(BuildContext)? dayAfterTomorrowDayLabel;
  final OneDayCalendarChanged state;

  @override
  Widget build(BuildContext context) {
    if (calendarSettings.isDaySwitcherPinned) {
      return SliverPersistentHeader(
          pinned: true,
          delegate: SingleDayPersistentHeader(
            _buildContent(),
          ));
    } else {
      return SliverToBoxAdapter(
        child: _buildContent(),
      );
    }
  }

  Widget _buildContent() {
    return OneDayNavigationBar(
      locale: locale,
      tomorrowDayLabel: tomorrowDayLabel,
      todayDayLabel: todayDayLabel,
      yesterdayDayLabel: yesterdayDayLabel,
      beforeYesterdayDayLabel: beforeYesterdayDayLabel,
      dayAfterTomorrowDayLabel: dayAfterTomorrowDayLabel,
      onTapLeft: onTapLeft,
      onTapRight: onTapRight,
      date: state.date,
      calendarSettings: calendarSettings,
    );
  }
}

class SingleDayPersistentHeader extends SliverPersistentHeaderDelegate {
  const SingleDayPersistentHeader(this.child);

  final Widget child;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return child;
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }

  @override
  double get maxExtent => 44;

  @override
  double get minExtent => 44;
}
