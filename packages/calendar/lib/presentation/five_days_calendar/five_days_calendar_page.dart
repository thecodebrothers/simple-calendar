part of calendar;

class FiveDaysCalendarPage extends StatefulWidget {
  final Map<DateTime, DayWithSingleAndMultipleItems> daysWithEvents;

  const FiveDaysCalendarPage({required this.daysWithEvents, Key? key})
      : super(key: key);

  @override
  State<FiveDaysCalendarPage> createState() => _FiveDaysCalendarPageState();
}

class _FiveDaysCalendarPageState extends State<FiveDaysCalendarPage> {
  late InfiniteScrollController _scrollController;
  final DateTime _dateTime =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        final rowWidth = (constraints.maxWidth -
                kHourCellWidth -
                kFiveDaysPaddingRight -
                kHourCellSpaceRight) /
            kNumberOfDays;
        _scrollController =
            InfiniteScrollController(initialScrollOffset: -2 * rowWidth);
        return Padding(
          padding: const EdgeInsets.only(right: kFiveDaysPaddingRight),
          child: SingleChildScrollView(
              controller: ScrollController(),
              child: Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      FiveDaysNavigationBar(
                          rowWidth: rowWidth,
                          scrollController: _scrollController),
                      _buildCalendar(rowWidth),
                    ],
                  ))),
        );
      }),
    );
  }

  Widget _buildCalendar(double rowWidth) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Hours(),
      Expanded(
        child: SizedBox(
          height: kSizeOfHoursColumn,
          child: InfiniteListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(0),
              scrollDirection: Axis.horizontal,
              itemCount: kListItemCount,
              itemBuilder: (BuildContext context, int index) {
                return SingleDayInFiveDayCalendar(
                  events: widget.daysWithEvents
                          .containsKey(_dateTime.add(Duration(days: index)))
                      ? widget
                          .daysWithEvents[_dateTime.add(Duration(days: index))]
                          ?.singleEvents
                      : null,
                  multipleEvents: widget.daysWithEvents
                          .containsKey(_dateTime.add(Duration(days: index)))
                      ? widget
                          .daysWithEvents[_dateTime.add(Duration(days: index))]
                          ?.multipleEvents
                      : null,
                  date: DateTime.now().add(
                    Duration(days: index),
                  ),
                  rowWidth: rowWidth,
                );
              }),
        ),
      ),
    ]);
  }
}
