import 'package:simple_calendar/presentation/models/single_calendar_event.dart';

class SingleCalendarEventInternal extends SingleCalendarEvent {
  final double eventHeightThreshold;
  SingleCalendarEventInternal({
    required singleLine,
    required eventStart,
    required eventEnd,
    required isAllDay,
    required localIconName,
    required networkIconName,
    required iconBackgroundColor,
    required object,
    required dotTileColor,
    required tileBackgroundColor,
    required this.eventHeightThreshold,
    imageHeaders,
    id,
    secondLine,
    topLeftLine,
    bottomRightLine,
  }) : super(
          id: id,
          singleLine: singleLine,
          eventStart: eventStart,
          eventEnd: eventEnd,
          isAllDay: isAllDay,
          object: object,
          localIconName: localIconName,
          networkIconName: networkIconName,
          iconBackgroundColor: iconBackgroundColor,
          dotTileColor: dotTileColor,
          tileBackgroundColor: tileBackgroundColor,
          secondLine: secondLine,
          imageHeaders: imageHeaders,
          topLeftLine: topLeftLine,
          bottomRightLine: bottomRightLine,
        );
}
