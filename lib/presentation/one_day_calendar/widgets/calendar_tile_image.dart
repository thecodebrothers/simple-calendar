import 'package:flutter/material.dart';
import 'package:simple_calendar/presentation/models/single_event.dart';

class CalendarTileImage extends StatelessWidget {
  final SingleEvent event;
  final double size;
  final double iconBackgroundOpacity;

  const CalendarTileImage({
    required this.event,
    required this.size,
    required this.iconBackgroundOpacity,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 2.0, left: 1.0),
      child: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(size / 2)),
          color: event.iconBackgroundColor.withOpacity(iconBackgroundOpacity),
        ),
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: _getImageWidget(),
        ),
      ),
    );
  }

  Widget _getImageWidget() {
    if (event.networkIconName.isNotEmpty) {
      return Image.network(event.networkIconName,
          color: event.iconBackgroundColor, headers: event.imageHeaders);
    } else if (event.localIconName.isNotEmpty) {
      return Image.asset(event.localIconName, color: event.iconBackgroundColor);
    } else {
      return const SizedBox.shrink();
    }
  }
}
