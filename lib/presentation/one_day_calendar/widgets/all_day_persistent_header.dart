import 'package:flutter/material.dart';
import 'package:simple_calendar/constants/calendar_settings.dart';
import 'package:simple_calendar/presentation/models/single_event.dart';
import 'package:simple_calendar/presentation/one_day_calendar/widgets/whole_day_event.dart';

class AllDayPersistentHeader extends SliverPersistentHeaderDelegate {
  final CalendarSettings calendarSettings;
  final List<SingleEvent> events;
  final Function(SingleEvent)? onEventTap;
  final double minExtent;
  final double maxExtent;

  AllDayPersistentHeader({
    required this.calendarSettings,
    required this.events,
    required this.onEventTap,
    required this.minExtent,
    required this.maxExtent,
  });
  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < events.length; i++)
          Padding(
            padding: const EdgeInsets.only(
              left: 50.0,
            ),
            child: WholeEventTile(
              calendarSettings: calendarSettings,
              event: events[i],
              rowWidth: MediaQuery.of(context).size.width,
              position: i,
              action: () => onEventTap?.call(events[i]),
            ),
          ),
      ],
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
