library calendar;

import 'package:simple_calendar/presentation/five_days_calendar/widgets/five_days_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:infinite_listview/infinite_listview.dart';
import 'package:easy_localization/easy_localization.dart';

import 'generated/locale_keys.g.dart';

part 'constants/constants.dart';
part 'extensions/datetime_extension.dart';
part 'presentation/five_days_calendar/five_days_calendar_page.dart';
part 'presentation/five_days_calendar/widgets/five_days_date.dart';
part 'presentation/five_days_calendar/widgets/five_days_empty_cells.dart';
part 'presentation/five_days_calendar/widgets/single_day_five_days_calendar.dart';
part 'presentation/models/calendar_item_event.dart';
part 'presentation/models/day_with_single_multiple_items.dart';
part 'presentation/models/event.dart';
part 'presentation/one_day_calendar/one_day_calendar_page.dart';
part 'presentation/one_day_calendar/widgets/calendar_event.dart';
part 'presentation/one_day_calendar/widgets/current_time.dart';
part 'presentation/one_day_calendar/widgets/hour_cell.dart';
part 'presentation/one_day_calendar/widgets/hours_column.dart';
part 'presentation/one_day_calendar/widgets/multiple_calendar_event.dart';
part 'presentation/one_day_calendar/widgets/one_day_navigation_bar.dart';
part 'presentation/one_day_calendar/widgets/single_day_calendar.dart';
part 'presentation/one_day_calendar/widgets/single_day_date.dart';
part 'presentation/one_day_calendar/widgets/single_day_empty_cells.dart';
part 'presentation/one_day_calendar/widgets/single_day_timeline_with_events.dart';
