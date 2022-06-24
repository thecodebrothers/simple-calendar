import 'package:flutter/material.dart';
import 'package:simple_calendar/constants/calendar_settings.dart';
import 'package:simple_calendar/presentation/models/single_event.dart';
import 'package:simple_calendar/presentation/one_day_calendar/widgets/calendar_tile_image.dart';

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
    return Positioned(
      top: position * calendarSettings.rowHeight,
      width: rowWidth,
      height: calendarSettings.rowHeight,
      child: Padding(
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CalendarTileImage(event: event, size: 16, iconBackgroundOpacity: 0.2),
                  if (event.networkIconName.isNotEmpty || event.localIconName.isNotEmpty) const SizedBox(width: 2),
                  Expanded(
                    child: Text(
                      event.singleLine,
                      overflow: TextOverflow.fade,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
