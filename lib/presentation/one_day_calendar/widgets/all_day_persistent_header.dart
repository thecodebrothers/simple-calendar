import 'package:flutter/material.dart';
import 'package:simple_calendar/constants/calendar_settings.dart';
import 'package:simple_calendar/presentation/models/single_event.dart';
import 'package:simple_calendar/presentation/one_day_calendar/widgets/whole_day_event.dart';

class AllDayPersistentHeader extends SliverPersistentHeaderDelegate {
  final CalendarSettings calendarSettings;
  final List<SingleEvent> events;
  final Function(SingleEvent)? onEventTap;
  final bool isExpanded;
  final Function(bool) updateCallback;

  AllDayPersistentHeader({
    required this.calendarSettings,
    required this.events,
    required this.onEventTap,
    required this.isExpanded,
    required this.updateCallback,
  });

  @override
  double get minExtent => _calculateHeight();
  @override
  double get maxExtent => _calculateHeight();

  double _calculateHeight() {
    final visibleCount = (events.length <= 2 || isExpanded) ? events.length : 2;
    final needsButton = events.length > 2 ? 1 : 0;
    return (visibleCount + needsButton) * calendarSettings.allDayEventHeight;
  }

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final showExpandable = events.length > 2;
    final visibleEvents =
        showExpandable && !isExpanded ? events.take(2).toList() : events;

    final itemCount = visibleEvents.length + (showExpandable ? 1 : 0);

    return SizedBox(
      height: _calculateHeight(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: itemCount,
          itemBuilder: (context, index) {
            if (index < visibleEvents.length) {
              final event = visibleEvents[index];
              return SizedBox(
                height: calendarSettings.allDayEventHeight,
                child: WholeEventTile(
                  calendarSettings: calendarSettings,
                  event: event,
                  rowWidth: MediaQuery.of(context).size.width,
                  action: () => onEventTap?.call(event),
                ),
              );
            } else {
              return SizedBox(
                height: calendarSettings.allDayEventHeight,
                child: InkWell(
                  onTap: () => updateCallback(!isExpanded),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        isExpanded
                            ? 'Ukryj'
                            : 'jeszcze ${events.length - visibleEvents.length}',
                        style: calendarSettings.expandableTextButtonStyle,
                      ),
                      Icon(
                        isExpanded ? Icons.expand_less : Icons.expand_more,
                        color: calendarSettings.expandableIconColor,
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant AllDayPersistentHeader oldDelegate) {
    return events != oldDelegate.events || isExpanded != oldDelegate.isExpanded;
  }
}
