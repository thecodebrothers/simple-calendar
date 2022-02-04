part of calendar;

class SingleDayTimelineWithEvents extends StatelessWidget {
  final DateTime date;
  final List<SingleEvent>? events;
  final List<SingleEvent>? multipleEvents;

  const SingleDayTimelineWithEvents(
      {required this.date, this.events, this.multipleEvents, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Stack(
          children: [
            EmptyCells(date: date),
            if (date.isSameDate(DateTime.now())) const CurrentTime(),
            if (events != null) ...events!.map((e) => CalendarEvent(event: e)),
            if (multipleEvents != null) ...[
              for (int i = 0; i < multipleEvents!.length; i++)
                CalendarEvent(
                  event: multipleEvents![i],
                  rowWidth: constraints.maxWidth,
                  position: i,
                  numberOfEvents:
                      multipleEvents!.length < 6 ? multipleEvents!.length : 5,
                )
            ],
          ],
        );
      },
    );
  }
}
