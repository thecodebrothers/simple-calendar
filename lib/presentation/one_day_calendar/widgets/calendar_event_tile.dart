import 'package:flutter/material.dart';
import 'package:simple_calendar/constants/calendar_settings.dart';
import 'package:simple_calendar/presentation/models/single_event.dart';
import 'package:simple_calendar/presentation/one_day_calendar/widgets/calendar_tile_image.dart';
import 'package:simple_calendar/presentation/one_day_calendar/widgets/draggable_tile.dart';

class CalendarEventTile extends StatelessWidget {
  final SingleEvent event;
  final int numberOfAllDayEvents;
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

  const CalendarEventTile({
    required this.event,
    required this.numberOfAllDayEvents,
    required this.action,
    required this.calendarSettings,
    required this.date,
    required this.calendarKey,
    required this.rowWidth,
    required this.rowHeight,
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
    final rescaleFactor = rowHeight / 60;
    double height = (event.eventEnd - event.eventStart) * rescaleFactor;
    if (height < 0) {
      height = 24.0 * 60.0 - event.eventStart * rescaleFactor;
    }

    final hasIcon =
        event.localIconName.isNotEmpty || event.networkIconName.isNotEmpty;

    return SizedBox(
      width: rowWidth,
      height: height,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: DraggableTile(
          rowHeight: rowHeight,
          data: event,
          width: rowWidth,
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
                  if (rowWidth > minWidth)
                    SizedBox(width: calendarSettings.iconSpacingFromText),
                  if (rowWidth > calendarSettings.tileIconSize && hasIcon)
                    CalendarTileImage(
                        event: event,
                        size: calendarSettings.tileIconSize,
                        iconBackgroundOpacity:
                            calendarSettings.iconBackgroundOpacity),
                  if (rowWidth > minWidth && hasIcon)
                    SizedBox(width: calendarSettings.iconSpacingFromText),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _columnChildren(),
                    ),
                  ),
                  if (rowWidth > minWidth && event.dotTileColor != null)
                    SizedBox(width: calendarSettings.iconSpacingFromText),
                  if (rowWidth > minWidth && event.dotTileColor != null)
                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: event.dotTileColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  if (rowWidth > minWidth)
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
    final textColor = _textColorForBackground(event.tileBackgroundColor);

    return [
      if (event.topLeftLine != null) ...[
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            event.topLeftLine!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: calendarSettings.topLeftLineTileTextStyle
                .copyWith(color: textColor),
          ),
        ),
        const SizedBox(height: 6),
      ],
      Flexible(
        child: Text(
          event.singleLine,
          maxLines: event.secondLine == null ? 3 : 1,
          overflow: TextOverflow.ellipsis,
          style: calendarSettings.firstLineTileTextStyle
              .copyWith(color: textColor),
        ),
      ),
      if (event.secondLine != null) ...[
        const SizedBox(height: 4),
        Flexible(
          child: Text(
            event.secondLine!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: calendarSettings.secondLineTileTextStyle
                .copyWith(color: textColor),
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
            overflow: TextOverflow.ellipsis,
            style: calendarSettings.bottomRightLineTileTextStyle
                .copyWith(color: textColor),
          ),
        ),
      ]
    ];
  }

  Color _textColorForBackground(Color backgroundColor) {
    if (ThemeData.estimateBrightnessForColor(backgroundColor) ==
        Brightness.dark) {
      return Colors.white;
    }

    return Colors.black;
  }
}
