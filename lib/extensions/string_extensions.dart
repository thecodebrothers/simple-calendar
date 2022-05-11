import 'package:easy_localization/src/public_ext.dart';
import 'package:simple_calendar/generated/locale_keys.g.dart';

extension StringExtensions on String {
  String dayName() {
    switch (this) {
      case "pon.":
        return LocaleKeys.calendar_monday.tr();
      case "wt.":
        return LocaleKeys.calendar_tuesday.tr();
      case "śr.":
        return LocaleKeys.calendar_wednesday.tr();
      case "czw.":
        return LocaleKeys.calendar_thursday.tr();
      case "pt.":
        return LocaleKeys.calendar_friday.tr();
      case "sob.":
        return LocaleKeys.calendar_saturday.tr();
      case "niedz.":
        return LocaleKeys.calendar_sunday.tr();
      default:
        return "";
    }
  }
}
