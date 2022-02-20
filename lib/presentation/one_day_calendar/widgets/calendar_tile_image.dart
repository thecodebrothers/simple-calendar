import 'package:flutter/material.dart';
import 'package:simple_calendar/presentation/models/single_event.dart';

class CalendarTileImage extends StatelessWidget {
  final SingleEvent event;

  const CalendarTileImage({required this.event, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 2.0, left: 1.0),
      child: Container(
        height: 16,
        width: 16,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          color: event.iconBackgroundColor.withOpacity(0.2),
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
      return Image.network(event.networkIconName, color: event.iconBackgroundColor);
    } else if (event.localIconName.isNotEmpty) {
      return Image.asset(event.localIconName, color: event.iconBackgroundColor);
    } else {
      return const SizedBox.shrink();
    }
  }
}
