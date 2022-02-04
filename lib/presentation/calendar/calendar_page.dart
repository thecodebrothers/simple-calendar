import 'package:calendar/calendar.dart';
import 'package:custom_calendar/presentation/calendar/calendar_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<CalendarCubit>(context).loadEvents();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalendarCubit, CalendarState>(
      builder: (context, state) {
        if (state is CalendarLoaded) {
          return OneDayCalendarPage(
            daysWithEvents: state.daysWithEvents,
            scrollController: _scrollController,
          );
          // return FiveDaysCalendarPage(daysWithEvents: state.daysWithEvents);
        }
        return const SizedBox.shrink();
      },
    );
  }
}
