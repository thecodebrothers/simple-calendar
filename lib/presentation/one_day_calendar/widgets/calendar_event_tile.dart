import 'package:flutter/material.dart';
import 'package:simple_calendar/constants/calendar_settings.dart';
import 'package:simple_calendar/constants/constants.dart';
import 'package:simple_calendar/presentation/models/single_event.dart';
import 'package:simple_calendar/presentation/one_day_calendar/widgets/calendar_tile_image.dart';

class CalendarEventTile extends StatelessWidget {
  final SingleEvent event;
  final int numberOfAllDayEvents;
  final int? position;
  final int? numberOfEvents;
  final double? rowWidth;
  final VoidCallback action;
  final CalendarSettings calendarSettings;

  const CalendarEventTile({
    required this.event,
    required this.numberOfAllDayEvents,
    required this.action,
    required this.calendarSettings,
    this.position,
    this.numberOfEvents,
    this.rowWidth,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: event.eventStart.toDouble() + numberOfAllDayEvents * kCellHeight,
      left: rowWidth != null ? _getPositionLeft(position ?? 0) : 3,
      right: rowWidth != null ? null : 3,
      width: rowWidth != null ? (rowWidth ?? 0) / (numberOfEvents ?? 1) : null,
      height: event.eventEnd.toDouble() - event.eventStart.toDouble(),
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Material(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          color: Colors.white,
          elevation: 6,
          clipBehavior: Clip.hardEdge,
          child: InkWell(
            onTap: action,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CalendarTileImage(event: event),
                if (event.networkIconName.isNotEmpty || event.localIconName.isNotEmpty) const SizedBox(width: 2),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        event.singleLine,
                        overflow: TextOverflow.fade,
                        style: calendarSettings.firstLineTileTextStyle,
                      ),
                      if (event.secondLine != null)
                        Text(
                          event.secondLine!,
                          overflow: TextOverflow.fade,
                          style: calendarSettings.secondLineTileTextStyle,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  double _getPositionLeft(int position) {
    switch (position) {
      case 0:
        return 3;
      case 1:
        return 3 + (rowWidth ?? 0) / (numberOfEvents ?? 1);
      case 2:
        return 3 + ((rowWidth ?? 0) / (numberOfEvents ?? 1) * 2);
      case 3:
        return 3 + ((rowWidth ?? 0) / (numberOfEvents ?? 1) * 3);
      case 4:
        return 3 + ((rowWidth ?? 0) / (numberOfEvents ?? 1) * 4);
      default:
        return 0;
    }
  }
}
