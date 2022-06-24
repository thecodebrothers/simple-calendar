import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_calendar/bloc/one_day_calendar_cubit.dart';
import 'package:simple_calendar/constants/calendar_settings.dart';
import 'package:simple_calendar/constants/constants.dart';
import 'package:simple_calendar/presentation/models/single_event.dart';
import 'package:simple_calendar/presentation/one_day_calendar/widgets/hours_column.dart';
import 'package:simple_calendar/presentation/one_day_calendar/widgets/one_day_navigation_bar.dart';
import 'package:simple_calendar/presentation/one_day_calendar/widgets/single_day_timeline_with_events.dart';

class SingleDay extends StatefulWidget {
  final Function(DateTime) onChanged;
  final ScrollController scrollController;
  final CalendarSettings calendarSettings;
  final Function(SingleEvent) onEventTap;
  final Function(DateTime) onLongPress;

  const SingleDay({
    required this.onChanged,
    required this.scrollController,
    required this.calendarSettings,
    required this.onEventTap,
    required this.onLongPress,
    Key? key,
  }) : super(key: key);

  @override
  State<SingleDay> createState() => _SingleDayState();
}

class _SingleDayState extends State<SingleDay> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OneDayCalendarCubit, OneDayCalendarState>(
      builder: (context, state) {
        if (state is OneDayCalendarChanged) {
          return _buildSinglePage(state);
        } else {
          return const Center(
            child: SizedBox(
              height: 50,
              width: 50,
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }

  Widget _buildSinglePage(OneDayCalendarChanged state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OneDayNavigationBar(
          onTapLeft: () {
            widget.onChanged(state.date.add(const Duration(days: -1)));
          },
          onTapRight: () {
            widget.onChanged(state.date.add(const Duration(days: 1)));
          },
          date: state.date,
          calendarSettings: widget.calendarSettings,
        ),
        Expanded(
          child: SingleChildScrollView(
            controller: widget.scrollController,
            child: Row(children: [
              Hours(numberOfConstantsTasks: state.dayWithEvents.allDaysEvents.length, calendarSettings: widget.calendarSettings),
              Expanded(
                child: SizedBox(
                  height: kHoursInCalendar * widget.calendarSettings.rowHeight + state.dayWithEvents.allDaysEvents.length * widget.calendarSettings.rowHeight,
                  child: GestureDetector(
                    onLongPressEnd: (details) {
                      final date = state.date;
                      widget.onLongPress(DateTime(date.year, date.month, date.day, details.localPosition.dy.toInt() ~/ 60));
                    },
                    child: SingleDayTimelineWithEvents(
                      events: state.dayWithEvents.singleEvents,
                      multipleEvents: state.dayWithEvents.multipleEvents,
                      allDayEvents: state.dayWithEvents.allDaysEvents,
                      date: state.date,
                      maxNumberOfWholeDayTasks: state.dayWithEvents.allDaysEvents.length,
                      action: (item) => widget.onEventTap(item),
                      calendarSettings: widget.calendarSettings,
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ),
      ],
    );
  }
}
