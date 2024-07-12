import 'package:example/repositories/mock_calendar_events_repository.dart';
import 'package:example/services/mock_events_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:simple_calendar/presentation/one_day_calendar/one_day_calendar_controller.dart';
import 'package:simple_calendar/simple_calendar.dart';

class CalendarState {}

void main() async {
  final MockEventsService eventsService = MockEventsService();
  final MockCalendarEventsRepository calendarRepository =
      MockCalendarEventsRepository(eventsService);

  // if you want to use 'locale' parameter in calendar widgets
  // and do not have provided GlobalMaterialLocalizations.delegate
  // you should call it at least once at the beginning of your app
  await initializeDateFormatting();

  runApp(MyApp(
    calendarRepository: calendarRepository,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.calendarRepository,
  });

  final CalendarEventsRepository calendarRepository;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Calendar Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(
        calendarRepository: calendarRepository,
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({
    super.key,
    required this.calendarRepository,
  });

  final CalendarEventsRepository calendarRepository;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          appBar: AppBar(
            title: const Text("Simple Calendar"),
            bottom: const TabBar(
              tabs: [
                Tab(
                  icon: Text(
                    "One Day Calendar",
                    textAlign: TextAlign.center,
                  ),
                ),
                Tab(
                  icon: Text(
                    "Many-days Calendar",
                    textAlign: TextAlign.center,
                  ),
                ),
                Tab(
                  icon: Text(
                    "Month Calendar",
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              OneDayCalendarTab(calendarRepository: calendarRepository),
              MultipleDaysCalendarTab(calendarRepository: calendarRepository),
              MonthCalendarTab(calendarRepository: calendarRepository)
            ],
          )),
    );
  }
}

class OneDayCalendarTab extends StatefulWidget {
  OneDayCalendarTab({
    super.key,
    required this.calendarRepository,
  });

  final CalendarEventsRepository calendarRepository;

  @override
  State<OneDayCalendarTab> createState() => _OneDayCalendarTabState();
}

class _OneDayCalendarTabState extends State<OneDayCalendarTab> {
  final ScrollController scrollController = ScrollController();
  final OneDayCalendarController calendarController =
      OneDayCalendarController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: OneDayCalendarView(
        scrollController: scrollController,
        controller: calendarController,
        calendarEventsRepository: widget.calendarRepository,
        calendarSettings: CalendarSettings(
          isDaySwitcherPinned: true,
          daySwitcherBackgroundColor: Colors.blue,
          dragEnabled: true,
          rowHeight: 45,
          zoomEnabled: true,
        ),

        // Optional locale for translations
        // locale: <your current locale>,

        // Optionally, you can customize calendar settings - text styles, etc.
        // calendarSettings: <CalendarSettings>,

        // Here you can pass additional optional day labels
        // that will be shown after the date in the header.
        // Mostly used for translations but you can also show some custom labels
        tomorrowDayLabel: (_) => 'Tomorrow',
        todayDayLabel: (_) => 'Today',
        yesterdayDayLabel: (_) => 'Yesterday',
        onDragCompleted: (minutes, event) {
          print('Event ${event.singleLine} was dragged to $minutes minutes');
        },
        onDragUpdate: (
          details,
          event,
        ) {
          print(
              'Event ${event.singleLine} is hovering above ${details.globalPosition.dy} y coordinate');
        },
        // Optional callbacks
        onEventTap: (event) => calendarController.updateDate(DateTime.now().add(Duration(days: 2))),
        onLongPress: (date) => ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
              SnackBar(content: Text("Hour ${date.hour} long pressed"))),
      ),
    );
  }
}

class MultipleDaysCalendarTab extends StatelessWidget {
  MultipleDaysCalendarTab({
    super.key,
    required this.calendarRepository,
  });

  final CalendarEventsRepository calendarRepository;
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: MultipleDaysCalendarView(
        scrollController: scrollController,
        daysAround: 1,
        calendarEventsRepository: calendarRepository,
        calendarSettings: CalendarSettings(
          isDaySwitcherPinned: true,
          dragEnabled: true,
          rowHeight: 45,
          zoomEnabled: true,
        ),
        // Optionally, you can customize calendar settings - text styles, etc.
        // calendarSettings: <CalendarSettings>,

        // Optional locale for translations
        // locale: <your current locale>,

        // Optional callbacks
        onTap: (event) => ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text("${event.singleLine} tapped"))),
        onLongPress: (date) => ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text("Day ${date.day} long pressed"),
            ),
          ),
        onDragCompleted: (minutes, event) {
          print('Event ${event.singleLine} was dragged to $minutes minutes');
        },
        onDragUpdate: (
          details,
          event,
        ) {
          print(
              'Event ${event.singleLine} is hovering above ${details.globalPosition.dy} y coordinate');
        },
      ),
    );
  }
}

class MonthCalendarTab extends StatelessWidget {
  MonthCalendarTab({
    super.key,
    required this.calendarRepository,
  });

  final CalendarEventsRepository calendarRepository;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: MonthCalendarView(
      calendarEventsRepository: calendarRepository,
      onSelected: (date) => ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text("Day ${date.day} tapped"))),

      // Optional locale for translations
      // locale: <your current locale>,

      // Optionally, you can customize weekdays abbreviations
      // By default there will be default abbreviations for your locale
      // customWeekdayAbbreviation: (context, dayNumber){
      //   final locale = Localizations.localeOf(context);
      //
      //   switch(dayNumber){
      //     case DateTime.monday: return 'MON';
      //     case DateTime.tuesday: return 'TUE';
      //     case DateTime.wednesday: return 'WED';
      //     case DateTime.thursday: return 'THU';
      //     case DateTime.friday: return 'FRI';
      //     case DateTime.saturday: return 'SAT';
      //     case DateTime.sunday: return 'SUN';
      //     default: return null;
      //   }
      // },

      // Optionally, you can customize calendar settings - text styles, etc.
      // calendarSettings: <CalendarSettings>,
    ));
  }
}
