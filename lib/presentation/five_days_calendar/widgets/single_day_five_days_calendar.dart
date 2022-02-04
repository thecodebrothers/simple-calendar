part of calendar;

class SingleDayInFiveDayCalendar extends StatelessWidget {
  final DateTime date;
  final List<SingleEvent>? events;
  final List<SingleEvent>? multipleEvents;
  final double rowWidth;

  const SingleDayInFiveDayCalendar(
      {this.events,
      this.multipleEvents,
      required this.date,
      required this.rowWidth,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FiveDaysEmptyCells(date: date, rowWidth: rowWidth),
        if (events != null) ...events!.map((e) => CalendarEvent(event: e)),
        if (multipleEvents != null) ...[
          for (int i = 0; i < multipleEvents!.length; i++)
            CalendarEvent(
              event: multipleEvents![i],
              rowWidth: rowWidth,
              position: i,
              numberOfEvents:
                  multipleEvents!.length < 6 ? multipleEvents!.length : 5,
            )
        ],
        if (date.isSameDate(DateTime.now())) const CurrentTime(),
      ],
    );
  }
}
