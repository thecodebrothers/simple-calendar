part of calendar;

class OneDayCalendarPage extends StatefulWidget {
  final Map<DateTime, DayWithSingleAndMultipleItems> daysWithEvents;
  final ScrollController scrollController;

  const OneDayCalendarPage(
      {required this.daysWithEvents, required this.scrollController, Key? key})
      : super(key: key);

  @override
  _OneDayCalendarPageState createState() => _OneDayCalendarPageState();
}

class _OneDayCalendarPageState extends State<OneDayCalendarPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        toolbarHeight: 10,
      ),
      body: SingleChildScrollView(
        controller: widget.scrollController,
        child: Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: SingleDay(daysWithEvents: widget.daysWithEvents)),
      ),
    );
  }
}
