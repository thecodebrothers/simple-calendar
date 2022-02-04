part of calendar;

class SingleDay extends StatefulWidget {
  final Map<DateTime, DayWithSingleAndMultipleItems> daysWithEvents;

  const SingleDay({required this.daysWithEvents, Key? key}) : super(key: key);

  @override
  State<SingleDay> createState() => _SingleDayState();
}

class _SingleDayState extends State<SingleDay> {
  PageController pageController = PageController(initialPage: kInitialPage);
  final DateTime _dateTime =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        OneDayNavigationBar(
          onTapLeft: () {
            setState(() {
              pageController.previousPage(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeIn);
            });
          },
          onTapRight: () {
            setState(() {
              pageController.nextPage(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeIn);
            });
          },
        ),
        SizedBox(
          height: kSizeOfHoursColumn,
          child: Row(children: [
            const Hours(),
            Expanded(
                child: PageView.builder(
                    scrollDirection: Axis.horizontal,
                    controller: pageController,
                    itemCount: kListItemCount,
                    itemBuilder: (context, index) {
                      return SingleDayTimelineWithEvents(
                        events: widget.daysWithEvents.containsKey(_dateTime
                                .add(Duration(days: index - kInitialPage)))
                            ? widget
                                .daysWithEvents[_dateTime
                                    .add(Duration(days: index - kInitialPage))]
                                ?.singleEvents
                            : null,
                        multipleEvents: widget.daysWithEvents.containsKey(
                                _dateTime
                                    .add(Duration(days: index - kInitialPage)))
                            ? widget
                                .daysWithEvents[_dateTime
                                    .add(Duration(days: index - kInitialPage))]
                                ?.multipleEvents
                            : null,
                        date: DateTime.now()
                            .add(Duration(days: index - kInitialPage)),
                      );
                    })),
          ]),
        ),
        const SizedBox(
          height: 40,
        ),
      ],
    );
  }
}
