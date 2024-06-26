import 'package:flutter/material.dart';
import 'package:simple_calendar/constants/calendar_settings.dart';
import 'package:simple_calendar/presentation/models/single_event.dart';

class DraggableTile extends StatefulWidget {
  final Widget child;
  final CalendarSettings calendarSettings;
  final Function(int minutes, SingleEvent object)? onDragCompleted;
  final Function(DragUpdateDetails details, SingleEvent object)? onDragUpdate;
  final Function()? onDragStarted;
  final SingleEvent data;
  final double width;
  final double height;
  final double rowHeight;
  final GlobalKey calendarKey;
  DraggableTile({
    required this.child,
    required this.onDragCompleted,
    required this.calendarSettings,
    required this.data,
    required this.width,
    required this.height,
    required this.calendarKey,
    required this.rowHeight,
    this.onDragStarted,
    this.onDragUpdate,
  });

  @override
  State<DraggableTile> createState() => _DraggableTileState();
}

class _DraggableTileState extends State<DraggableTile> {
  @override
  Widget build(BuildContext context) {
    if (widget.calendarSettings.dragEnabled == false) return widget.child;

    return LongPressDraggable<SingleEvent>(
      data: widget.data,
      delay: widget.calendarSettings.dragDelay,
      onDragStarted: () => widget.onDragStarted?.call(),
      onDragUpdate: (details) {
        widget.onDragUpdate?.call(details, widget.data);
      },
      onDragEnd: (details) {
        final dropPosition =
            details.offset.dy - _getGlobalCalendarPosition().dy;
        final rescaled = 60 / widget.rowHeight;

        widget.onDragCompleted
            ?.call((rescaled * dropPosition).toInt(), widget.data);
      },
      childWhenDragging: SizedBox(
        width: widget.width,
        height: widget.height,
      ),
      feedback: SizedBox(
        width: widget.width,
        height: widget.height,
        child: widget.child,
      ),
      child: widget.child,
    );
  }

  Offset _getGlobalCalendarPosition() {
    final renderObject = widget.calendarKey.currentContext?.findRenderObject();
    if (renderObject == null || renderObject is! RenderBox) {
      return Offset.zero;
    }

    return renderObject.localToGlobal(Offset.zero);
  }
}
