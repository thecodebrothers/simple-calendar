import 'package:flutter/material.dart';
import 'package:simple_calendar/constants/calendar_settings.dart';
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
    final minWidth = calendarSettings.tileIconSize +
        calendarSettings.iconSpacingFromText * 4 +
        16;
    final calculatedRowWidth = (rowWidth ?? 0) / (numberOfEvents ?? 1);
    final eventWidth =
        rowWidth != null ? (rowWidth ?? 0) / (numberOfEvents ?? 1) : null;
    return Positioned(
      top: event.eventStart.toDouble() -
          calendarSettings.startHour * calendarSettings.rowHeight +
          numberOfAllDayEvents * calendarSettings.rowHeight,
      left: rowWidth != null ? _getPositionLeft(position ?? 0) : 3,
      right: rowWidth != null ? null : 3,
      width: eventWidth,
      height:
          event.eventHeightThreshold.toDouble() - event.eventStart.toDouble(),
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Material(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          color: event.tileBackgroundColor,
          elevation: 6,
          clipBehavior: Clip.hardEdge,
          child: InkWell(
            onTap: action,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (calculatedRowWidth > minWidth)
                  SizedBox(width: calendarSettings.iconSpacingFromText),
                if (eventWidth == null ||
                    eventWidth > calendarSettings.tileIconSize)
                  CalendarTileImage(
                      event: event,
                      size: calendarSettings.tileIconSize,
                      iconBackgroundOpacity:
                          calendarSettings.iconBackgroundOpacity),
                if (calculatedRowWidth > minWidth)
                  SizedBox(width: calendarSettings.iconSpacingFromText),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          event.singleLine,
                          maxLines: event.secondLine == null ? 3 : 1,
                          overflow: TextOverflow.fade,
                          style: calendarSettings.firstLineTileTextStyle,
                        ),
                      ),
                      if (event.secondLine != null) const SizedBox(height: 4),
                      if (event.secondLine != null)
                        Flexible(
                          child: Text(
                            event.secondLine!,
                            maxLines: 1,
                            overflow: TextOverflow.fade,
                            style: calendarSettings.secondLineTileTextStyle,
                          ),
                        ),
                    ],
                  ),
                ),
                if (calculatedRowWidth > minWidth)
                  SizedBox(width: calendarSettings.iconSpacingFromText),
                if (calculatedRowWidth > minWidth)
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: event.dotTileColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                if (calculatedRowWidth > minWidth)
                  SizedBox(width: calendarSettings.iconSpacingFromText),
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
