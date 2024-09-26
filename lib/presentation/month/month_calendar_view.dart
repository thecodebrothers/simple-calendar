import 'dart:async';
import 'package:collection/collection.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:simple_calendar/bloc/month_calendar_cubit.dart';
import 'package:simple_calendar/constants/calendar_settings.dart';
import 'package:simple_calendar/extensions/datetime_extension.dart';
import 'package:simple_calendar/presentation/models/month_single_day_item.dart';
import 'package:simple_calendar/presentation/models/single_calendar_event.dart';
import 'package:simple_calendar/presentation/month/widgets/month_header.dart';
import 'package:simple_calendar/presentation/month/widgets/month_tile.dart';
import 'package:simple_calendar/repositories/calendar_events_repository.dart';
import 'package:simple_calendar/use_case/month_calendar_get_events_use_case.dart';

/// Calendar widget that shows events for a whole month
class MonthCalendarView extends StatefulWidget {
  /// Repository that provides events for calendar
  final CalendarEventsRepository calendarEventsRepository;

  /// Provides ability to reload events
  final StreamController? reloadController;

  /// Indicates which month should be shown initially
  /// If not provided, then current month will be shown
  ///
  /// Defaults to `DateTime.now`
  final DateTime? initialDate;

  /// Settings for calendar
  final CalendarSettings calendarSettings;

  /// Called when user taps on a day
  final void Function(DateTime)? onSelected;

  /// Called when user taps on a event
  final void Function(SingleCalendarEvent)? onEventSelected;

  /// Custom header widget that will be shown above calendar
  final Widget Function(BuildContext)? monthPicker;

  /// Locale for calendar, if not provided, then system locale will be used
  ///
  /// If you want to use 'locale' parameter in calendar widgets
  /// and do not have provided GlobalMaterialLocalizations.delegate
  /// you should call [initializeDateFormatting]
  /// at least once at the beginning of your app
  final Locale? locale;

  /// Custom weekday abbreviation in weekdays row, ex. 'Mon.' for Monday
  /// If not provided, default abbreviation will be used
  final String? Function(BuildContext, int)? customWeekdayAbbreviation;

  final bool isExpandable;

  final bool isWeekModeEnabled;

  final bool isWeekViewInitially;

  MonthCalendarView({
    required this.calendarEventsRepository,
    this.reloadController,
    this.initialDate,
    this.calendarSettings = const CalendarSettings(),
    this.onSelected,
    this.onEventSelected,
    this.monthPicker,
    this.locale,
    this.customWeekdayAbbreviation,
    this.isExpandable = false,
    this.isWeekModeEnabled = false,
    this.isWeekViewInitially = false,
    Key? key,
  }) : super(key: key);

  @override
  State<MonthCalendarView> createState() => _MonthCalendarViewState();
}

class _MonthCalendarViewState extends State<MonthCalendarView>
    with TickerProviderStateMixin {
  final ValueNotifier<bool> _isExpanded = ValueNotifier(false);
  final ValueNotifier<bool> _isWeekMode = ValueNotifier(false);
  late final AnimationController _expandedAnimationController;
  late final AnimationController _weekModeAnimationController;

  late final Animation<double> _weekModeScaleAnimation;
  late final Animation<double> _weekModeOpacityAnimation;

  double width = 0;

  @override
  void initState() {
    super.initState();
    _isWeekMode.value = widget.isWeekModeEnabled;
    _expandedAnimationController = AnimationController(
      vsync: this,
      value: 1.1,
      upperBound: 1.1,
      lowerBound: 0.7,
      duration: const Duration(milliseconds: 400),
    );

    _weekModeAnimationController = AnimationController(
      vsync: this,
      value: widget.isWeekModeEnabled && widget.isWeekViewInitially ? 1 : 0,
      duration: const Duration(milliseconds: 400),
    );

    _weekModeScaleAnimation = Tween<double>(begin: 1.0, end: 0.3)
        .animate(_weekModeAnimationController);
    _weekModeOpacityAnimation = Tween<double>(begin: 1.0, end: 0.0)
        .animate(_weekModeAnimationController);
  }

  @override
  void dispose() {
    _isExpanded.dispose();
    _isWeekMode.dispose();
    _expandedAnimationController.dispose();
    _weekModeAnimationController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      width = context.size?.width ?? 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MonthCalendarCubit>(
      create: (context) => MonthCalendarCubit(
        MonthCalendarGetEventsUseCase(widget.calendarEventsRepository),
        widget.initialDate ?? DateTime.now(),
        widget.reloadController,
      ),
      child: BlocBuilder<MonthCalendarCubit, MonthCalendarState>(
        builder: (ctx, state) {
          if (state is MonthCalendarChanged) {
            final groupPositions = _calculateGroupPositions(state.items);
            return _buildContent(ctx, state, groupPositions);
          } else {
            return widget.calendarSettings.progressIndicatorBuilder != null
                ? widget.calendarSettings.progressIndicatorBuilder!(context)
                : Center(
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

  Widget _buildContent(
    BuildContext context,
    MonthCalendarChanged state,
    Map<String, int> groupPositions,
  ) {
    return GestureDetector(
      onTap: () => _exitWeekMode(),
      child: Padding(
        padding: const EdgeInsets.only(top: 24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildMonthHeader(context, state),
            GestureDetector(
              onVerticalDragEnd: (details) {
                final velocity = details.primaryVelocity;

                if (velocity == null) return;

                if (velocity < 0 && !_isExpanded.value) {
                  _enterWeekMode();
                  return;
                }

                if (velocity > 0 && _isWeekMode.value) {
                  _exitWeekMode();
                  return;
                }

                if (!widget.isExpandable) return;

                if (velocity > 0) {
                  _expandView();
                } else {
                  _collapseView();
                }
              },
              child: ValueListenableBuilder<bool>(
                valueListenable: _isExpanded,
                builder: (context, isExpanded, child) {
                  return AnimatedBuilder(
                    animation: _expandedAnimationController,
                    builder: (context, child) {
                      return Column(
                        children: [
                          Row(
                            children: [
                              for (var i = 1; i <= 7; i++)
                                Expanded(
                                  child: Container(
                                    height: 24,
                                    alignment: Alignment.center,
                                    child: Text(
                                      _dayName(
                                        context,
                                        state.date.add(Duration(days: i)),
                                        widget.locale,
                                      ),
                                      style: widget.calendarSettings
                                          .calendarMonthDayStyle,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          SizedBox(height: 8),
                          _buildDays(state, groupPositions),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDays(
    MonthCalendarChanged state,
    Map<String, int> groupPositions,
  ) {
    return AnimatedBuilder(
      animation: _weekModeAnimationController,
      builder: (context, child) {
        return Stack(
          children: [
            if (_weekModeAnimationController.value < 1)
              SizeTransition(
                sizeFactor: _weekModeScaleAnimation,
                child: FadeTransition(
                  opacity: _weekModeOpacityAnimation,
                  child: _buildMonthView(state, groupPositions),
                ),
              ),
            if (_weekModeAnimationController.value > 0)
              FadeTransition(
                opacity: ReverseAnimation(_weekModeOpacityAnimation),
                child: _buildWeekView(state, groupPositions),
              ),
          ],
        );
      },
    );
  }

  Widget _buildWeekView(
    MonthCalendarChanged state,
    Map<String, int> groupPositions,
  ) {
    final calendarSettings = widget.calendarSettings;
    DateTime selectedDate = state.selectedDate ?? state.date;
    DateTime firstDayOfWeek =
        selectedDate.subtract(Duration(days: selectedDate.weekday - 1));

    List<MonthSingleDayItem> weekItems = [];
    for (int i = 0; i < 7; i++) {
      DateTime date = firstDayOfWeek.add(Duration(days: i));
      MonthSingleDayItem? item = state.weekItems.firstWhereOrNull(
        (item) => item.date.isSameDate(date),
      );
      if (item != null) {
        weekItems.add(item);
      }
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: _expandedAnimationController.value,
      ),
      itemCount: weekItems.length,
      itemBuilder: (context, index) {
        final item = weekItems[index];
        final isFirstDayOfWeek = index == 0;
        final isLastDayOfWeek = index == 6;
        final previousDayEvents =
            index > 0 ? weekItems[index - 1].events : <SingleCalendarEvent>[];
        final nextDayEvents = index < weekItems.length - 1
            ? weekItems[index + 1].events
            : <SingleCalendarEvent>[];

        return MonthTile(
          onTap: () => _exitWeekMode(),
          calendarSettings: calendarSettings.copyWith(
            monthSelectedColor: calendarSettings.weekSelectedColor ??
                calendarSettings.monthSelectedColor,
          ),
          text: item.isDayName
              ? _dayName(context, item.date, widget.locale)
              : item.date.day.toString(),
          events: item.events,
          previousDayEvents: previousDayEvents,
          nextDayEvents: nextDayEvents,
          isTheSameMonth: item.isDayName || state.date.isSameMonth(item.date),
          isToday: !item.isDayName && item.date.isSameDate(selectedDate),
          isDayName: item.isDayName,
          isFirstDayOfTheWeek: isFirstDayOfWeek,
          isLastDayOfTheWeek: isLastDayOfWeek,
          groupPositions: groupPositions,
          calendarWidth: width,
          isExpanded: false,
        );
      },
    );
  }

  Widget _buildMonthView(
    MonthCalendarChanged state,
    Map<String, int> groupPositions,
  ) {
    return ValueListenableBuilder<bool>(
      valueListenable: _isExpanded,
      builder: (context, isExpanded, child) {
        return GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: _expandedAnimationController.value,
          ),
          itemCount: state.items.length,
          itemBuilder: (context, index) {
            final item = state.items[index];
            final isFirstDayOfWeek = index % 7 == 0;
            final isLastDayOfWeek = index % 7 == 6;
            final previousDayEvents = index > 0
                ? state.items[index - 1].events
                : <SingleCalendarEvent>[];
            final nextDayEvents = index < state.items.length - 1
                ? state.items[index + 1].events
                : <SingleCalendarEvent>[];

            return MonthTile(
              onTap: () {
                widget.onSelected?.call(item.date);
                context.read<MonthCalendarCubit>().onDaySelected(item.date);
                if (widget.isWeekModeEnabled && widget.isWeekViewInitially) {
                  _enterWeekMode();
                  _collapseView();
                }
              },
              onEventTap: widget.onEventSelected,
              calendarSettings: widget.calendarSettings,
              text: item.isDayName
                  ? _dayName(context, item.date, widget.locale)
                  : item.date.day.toString(),
              events: item.events,
              previousDayEvents: previousDayEvents,
              nextDayEvents: nextDayEvents,
              isTheSameMonth:
                  item.isDayName || state.date.isSameMonth(item.date),
              isToday: !item.isDayName && item.date.isSameDate(DateTime.now()),
              isDayName: item.isDayName,
              isFirstDayOfTheWeek: isFirstDayOfWeek,
              isLastDayOfTheWeek: isLastDayOfWeek,
              groupPositions: groupPositions,
              calendarWidth: width,
              isExpanded: isExpanded,
            );
          },
        );
      },
    );
  }

  Widget _buildMonthHeader(BuildContext context, MonthCalendarChanged state) {
    return ValueListenableBuilder<bool>(
      valueListenable: _isWeekMode,
      builder: (context, isWeekMode, child) {
        if (isWeekMode) {
          return SizedBox.shrink();
        }

        return widget.monthPicker?.call(context) ??
            MonthHeader(
              locale: widget.locale,
              calendarSettings: widget.calendarSettings,
              onTapLeft: () => _changeMonth(context, state, -1),
              onTapRight: () => _changeMonth(context, state, 1),
              dayFromMonth: state.date,
            );
      },
    );
  }

  void _changeMonth(
      BuildContext context, MonthCalendarChanged state, int monthDelta) {
    BlocProvider.of<MonthCalendarCubit>(context).loadForDate(
      DateTime(state.date.year, state.date.month + monthDelta, 1),
    );
  }

  String _dayName(BuildContext context, DateTime date, Locale? locale) {
    final weekdayAbbreviation =
        widget.customWeekdayAbbreviation?.call(context, date.weekday);
    if (weekdayAbbreviation != null) return weekdayAbbreviation;
    final format = DateFormat("EEE", locale?.toLanguageTag());
    return format.format(date);
  }

  Map<String, int> _calculateGroupPositions(List<MonthSingleDayItem> items) {
    final groupPositions = <String, int>{};
    var currentPosition = 0;

    for (var i = 0; i < items.length; i++) {
      final item = items[i];
      if (item.isDayName) continue;

      for (var event in item.events) {
        final groupId = event.groupId ?? 'null';
        if (!groupPositions.containsKey(groupId)) {
          groupPositions[groupId] = currentPosition;
          currentPosition++;
        }
      }
    }

    return groupPositions;
  }

  void _enterWeekMode() {
    if (!widget.isWeekModeEnabled) {
      return;
    }

    _isWeekMode.value = true;
    _weekModeAnimationController.forward();
  }

  void _exitWeekMode() {
    if (!widget.isWeekModeEnabled) {
      return;
    }

    _isWeekMode.value = false;
    _weekModeAnimationController.reverse();
  }

  void _expandView() {
    if (!widget.isExpandable) {
      return;
    }

    _isExpanded.value = true;
    _expandedAnimationController.reverse();
  }

  void _collapseView() {
    if (!widget.isExpandable) {
      return;
    }

    _isExpanded.value = false;
    _expandedAnimationController.forward();
  }
}
