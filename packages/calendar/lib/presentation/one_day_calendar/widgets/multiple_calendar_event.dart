part of calendar;

class MultipleCalendarEvent extends StatelessWidget {
  final List<SingleEvent> event;
  final double rowWidth;
  final int position;

  const MultipleCalendarEvent(
      {required this.event,
      required this.rowWidth,
      required this.position,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      width: rowWidth / 2,
      top: event[0].eventStart.toDouble() + 22,
      left: 3,
      // right: 3,
      child: Container(
        height: event[0].eventEnd.toDouble(),
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
          child: Row(
            children: [
              const Icon(Icons.phone_iphone),
              const SizedBox(width: 5),
              RichText(
                  text: const TextSpan(
                text: "event",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
