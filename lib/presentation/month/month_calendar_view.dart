import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_calendar/bloc/month_calendar_cubit.dart';
import 'package:simple_calendar/constants/calendar_settings.dart';
import 'package:simple_calendar/extensions/datetime_extension.dart';
import 'package:simple_calendar/presentation/month/widgets/month_header.dart';
import 'package:simple_calendar/presentation/month/widgets/month_tile.dart';
import 'package:simple_calendar/repositories/calendar_events_repository.dart';
import 'package:simple_calendar/use_case/month_calendar_get_events_use_case.dart';

class MonthCalendarView extends StatelessWidget {
  final CalendarEventsRepository calendarEventsRepository;
  final DateTime? initialDate;
  final CalendarSettings calendarSettings;
  final Function(DateTime) onSelected;
  final Widget? monthPicker;

  const MonthCalendarView({
    required this.initialDate,
    required this.calendarSettings,
    required this.calendarEventsRepository,
    required this.onSelected,
    this.monthPicker,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MonthCalendarCubit>(
      create: (context) => MonthCalendarCubit(
        MonthCalendarGetEventsUseCase(calendarEventsRepository),
        initialDate ?? DateTime.now(),
      ),
      child: BlocBuilder<MonthCalendarCubit, MonthCalendarState>(
        builder: (ctx, state) {
          if (state is MonthCalendarChanged) {
            return _buildPage(ctx, state);
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
      ),
    );
  }

  Widget _buildPage(BuildContext context, MonthCalendarChanged state) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 24.0),
        child: Column(
          children: [
            monthPicker ??
                MonthHeader(
                  calendarSettings: calendarSettings,
                  onTapLeft: () {
                    BlocProvider.of<MonthCalendarCubit>(context)
                        .loadForDate(DateTime(state.date.year, state.date.month - 1, state.date.day));
                  },
                  onTapRight: () {
                    BlocProvider.of<MonthCalendarCubit>(context)
                        .loadForDate(DateTime(state.date.year, state.date.month + 1, state.date.day));
                  },
                  dayFromMonth: state.date,
                ),
            const SizedBox(
              height: 24.0,
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return GridView.count(
                    crossAxisCount: 7,
                    children: state.items
                        .map(
                          (e) => MonthTile(
                            onTap: () {
                              onSelected(e.date);
                            },
                            calendarSettings: calendarSettings,
                            text: e.isDayName ? _dayName(e.date) : e.date.day.toString(),
                            hasAnyTask: !e.isDayName && e.hasAnyEvents,
                            isTheSameMonth: e.isDayName || state.date.isSameMonth(e.date),
                            isToday: !e.isDayName && e.date.isSameDate(DateTime.now()),
                          ),
                        )
                        .toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _dayName(DateTime date) {
    final format = DateFormat("EEE");
    return format.format(date);
  }
}
