import 'package:flutter/material.dart';
import 'package:simple_calendar/constants/calendar_settings.dart';
import 'package:simple_calendar/presentation/models/single_event.dart';
import 'package:simple_calendar/presentation/one_day_calendar/widgets/calendar_tile_image.dart';
import 'package:simple_calendar/presentation/one_day_calendar/widgets/draggable_tile.dart';

class MultiDayCalendarEventTile extends StatelessWidget {
  final SingleEvent event;
  final int numberOfAllDayEvents;
  final int? position;
  final int? numberOfEvents;
  final double rowWidth;
  final double rowHeight;
  final VoidCallback action;
  final CalendarSettings calendarSettings;
  final DateTime date;
  final GlobalKey calendarKey;
  final Function(int minutes, SingleEvent object)? onDragCompleted;
  final Function(
      DragUpdateDetails details,
      SingleEvent object,
      )? onDragUpdate;
  final Function()? onDragStarted;

  const MultiDayCalendarEventTile({
    required this.event,
    required this.numberOfAllDayEvents,
    required this.action,
    required this.calendarSettings,
    required this.date,
    required this.calendarKey,
    required this.rowWidth,
    required this.rowHeight,
    this.position,
    this.numberOfEvents,
    this.onDragCompleted,
    this.onDragUpdate,
    this.onDragStarted,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final minWidth = calendarSettings.tileIconSize +
        calendarSettings.iconSpacingFromText * 4 +
        16;
    final calculatedRowWidth = (rowWidth) / (numberOfEvents ?? 1);
    final eventWidth = (rowWidth) / (numberOfEvents ?? 1);
    final rescaleFactor = rowHeight / 60;
    final height =
        (event.eventHeightThreshold.toDouble() - event.eventStart.toDouble()) *
            rescaleFactor;
    return Positioned(
      top: (event.eventStart.toDouble() * rescaleFactor) -
          calendarSettings.startHour * rowHeight +
          numberOfAllDayEvents * rowHeight,
      left: _getPositionLeft(position ?? 0),
      width: eventWidth,
      height: height,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: DraggableTile(
          rowHeight: rowHeight,
          data: event,
          width: eventWidth,
          onDragStarted: onDragStarted,
          calendarKey: calendarKey,
          height: height,
          calendarSettings: calendarSettings,
          onDragCompleted: onDragCompleted,
          onDragUpdate: onDragUpdate,
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
                  if (eventWidth > calendarSettings.tileIconSize)
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
                      children: _columnChildren(),
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
      ),
    );
  }

  List<Widget> _columnChildren() {
    return [
      if (event.topLeftLine != null) ...[
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            event.topLeftLine!,
            maxLines: 1,
            overflow: TextOverflow.fade,
            style: calendarSettings.topLeftLineTileTextStyle,
          ),
        ),
        const SizedBox(height: 6),
      ],
      Flexible(
        child: Text(
          event.singleLine,
          maxLines: event.secondLine == null ? 3 : 1,
          overflow: TextOverflow.fade,
          style: calendarSettings.firstLineTileTextStyle,
        ),
      ),
      if (event.secondLine != null) ...[
        const SizedBox(height: 4),
        Flexible(
          child: Text(
            event.secondLine!,
            maxLines: 1,
            overflow: TextOverflow.fade,
            style: calendarSettings.secondLineTileTextStyle,
          ),
        ),
      ],
      if (event.bottomRightLine != null) ...[
        const SizedBox(height: 6),
        Align(
          alignment: Alignment.bottomRight,
          child: Text(
            event.bottomRightLine!,
            maxLines: 1,
            overflow: TextOverflow.fade,
            style: calendarSettings.bottomRightLineTileTextStyle,
          ),
        ),
      ]
    ];
  }

  double _getPositionLeft(int position) {
    switch (position) {
      case 0:
        return 3;
      case 1:
        return 3 + rowWidth / (numberOfEvents ?? 1);
      case 2:
        return 3 + (rowWidth / (numberOfEvents ?? 1) * 2);
      case 3:
        return 3 + (rowWidth / (numberOfEvents ?? 1) * 3);
      case 4:
        return 3 + (rowWidth / (numberOfEvents ?? 1) * 4);
      default:
        return 0;
    }
  }
}
