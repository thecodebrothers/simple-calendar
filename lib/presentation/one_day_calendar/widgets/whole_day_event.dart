import 'package:flutter/material.dart';
import 'package:simple_calendar/constants/calendar_settings.dart';
import 'package:simple_calendar/presentation/models/single_event.dart';

class WholeEventTile extends StatelessWidget {
  final SingleEvent event;
  final int position;
  final double rowWidth;
  final VoidCallback action;
  final CalendarSettings calendarSettings;

  const WholeEventTile({
    required this.event,
    required this.position,
    required this.rowWidth,
    required this.action,
    required this.calendarSettings,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final minWidth = calendarSettings.tileIconSize +
        calendarSettings.iconSpacingFromText * 4 +
        16;
    final calculatedRowWidth = (rowWidth) / (1);
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Material(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        color: Colors.white,
        elevation: 6,
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: action,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              children: [
                SizedBox(width: calendarSettings.iconSpacingFromText),
                Expanded(
                  child: Text(
                    event.singleLine,
                    overflow: TextOverflow.fade,
                    style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                  ),
                ),
                if (calculatedRowWidth > minWidth)
                  SizedBox(width: calendarSettings.iconSpacingFromText),
                if (calculatedRowWidth > minWidth)
                  Container(
                    width: 10,
                    height: 10,
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
}
