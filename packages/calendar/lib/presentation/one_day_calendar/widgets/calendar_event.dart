part of calendar;

class CalendarEvent extends StatelessWidget {
  final SingleEvent event;
  final double? rowWidth;
  final int? position;
  final int? numberOfEvents;

  const CalendarEvent(
      {required this.event,
      this.rowWidth,
      this.position,
      this.numberOfEvents,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: event.eventStart.toDouble() + kFiveDaysDateHeight,
      left: rowWidth != null ? _getPositionLeft(position ?? 0) : 3,
      right: rowWidth != null ? null : 3,
      width: rowWidth != null ? (rowWidth ?? 0) / (numberOfEvents ?? 1) : null,
      child: Container(
        height: event.eventEnd.toDouble() - event.eventStart.toDouble(),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.white,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.7),
              spreadRadius: 1,
              blurRadius: 2,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Align(
          alignment: Alignment.topLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.phone_iphone),
              const SizedBox(width: 5),
              Expanded(
                child: RichText(
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      text: event.name,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double _getPositionLeft(int position) {
    switch (position) {
      case 0:
        return 3;
      case 1:
        return 3 + (rowWidth ?? 0) / (numberOfEvents ?? 1);
      case 2:
        return 3 + ((rowWidth ?? 0) / (numberOfEvents ?? 1) * 2);
      case 3:
        return 3 + ((rowWidth ?? 0) / (numberOfEvents ?? 1) * 3);
      case 4:
        return 3 + ((rowWidth ?? 0) / (numberOfEvents ?? 1) * 4);
      default:
        return 0;
    }
  }
}
