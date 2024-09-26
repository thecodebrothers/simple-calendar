import 'package:flutter/material.dart';
import 'package:simple_calendar/constants/calendar_settings.dart';
import 'package:simple_calendar/presentation/models/single_calendar_event.dart';

class MonthTileExpandedEventsPart extends StatelessWidget {
  const MonthTileExpandedEventsPart({
    required this.calendarSettings,
    required this.groupedEvents,
    required this.groupPositions,
    this.onTap,
    super.key,
  });

  final Function(SingleCalendarEvent)? onTap;
  final CalendarSettings calendarSettings;
  final Map<String, List<SingleCalendarEvent>> groupedEvents;
  final Map<String, int> groupPositions;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        final entry = groupedEvents.entries.elementAt(index);
        final event = entry.value.first;

        return InkWell(
          onTap: () => onTap?.call(event),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 2.0),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  Container(
                    width: 3,
                    color:
                        event.groupColor ?? calendarSettings.monthSelectedColor,
                  ),
                  const SizedBox(width: 1),
                  Expanded(
                    child: Text(
                      event.singleLine,
                      style: calendarSettings.firstLineTileTextStyle
                          .copyWith(fontSize: 11),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      itemCount: groupedEvents.length,
      physics: const ClampingScrollPhysics(),
    );
  }
}
