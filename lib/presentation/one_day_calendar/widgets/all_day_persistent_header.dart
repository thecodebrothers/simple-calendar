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
  final bool isExpanded;
  final Function(bool) updateCallback;

  AllDayPersistentHeader({
    required this.calendarSettings,
    required this.events,
    required this.onEventTap,
    required this.minExtent,
    required this.maxExtent,
    required this.isExpanded,
    required this.updateCallback,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return events.length < 3
        ? _buildDefault(context)
        : _buildExpandable(context);
  }

  Widget _buildDefault(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < events.length; i++)
          SizedBox(
            height: calendarSettings.allDayEventHeight,
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

  Widget _buildExpandable(BuildContext context) {
    final displayableEvents = isExpanded ? events : events.take(2).toList();

    return Column(
      children: [
        for (int i = 0; i < displayableEvents.length; i++)
          SizedBox(
            height: calendarSettings.allDayEventHeight,
            child: WholeEventTile(
              calendarSettings: calendarSettings,
              event: displayableEvents[i],
              rowWidth: MediaQuery.of(context).size.width,
              position: i,
              action: () => onEventTap?.call(displayableEvents[i]),
            ),
          ),
        !isExpanded
            ? InkWell(
                onTap: () => updateCallback.call(true),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'jeszcze ${events.length - displayableEvents.length}',
                      style: calendarSettings.expandableTextButtonStyle,
                    ),
                    Icon(
                      Icons.expand_more,
                      color: calendarSettings.expandableIconColor,
                    ),
                  ],
                ),
              )
            : InkWell(
                onTap: () => updateCallback.call(false),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Ukryj',
                      style: calendarSettings.expandableTextButtonStyle,
                    ),
                    Icon(
                      Icons.expand_less,
                      color: calendarSettings.expandableIconColor,
                    ),
                  ],
                ),
              ),
      ],
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
