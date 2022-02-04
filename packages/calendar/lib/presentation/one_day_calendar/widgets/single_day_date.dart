part of calendar;

class SingleDayDate extends StatelessWidget {
  final DateTime date;

  const SingleDayDate({required this.date, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 22,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade200, width: 1)),
      child: Center(
        child: RichText(
            text: TextSpan(
          text:
              "${date.day} ${_getMonth(date.month)} ${date.year}, ${_getDayOfTheWeek(date.weekday)}",
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black),
        )),
      ),
    );
  }

  String _getMonth(int month) {
    switch (month) {
      case 1:
        return LocaleKeys.calendar_january.tr();
      case 2:
        return LocaleKeys.calendar_february.tr();
      case 3:
        return LocaleKeys.calendar_march.tr();
      case 4:
        return LocaleKeys.calendar_april.tr();
      case 5:
        return LocaleKeys.calendar_may.tr();
      case 6:
        return LocaleKeys.calendar_june.tr();
      case 7:
        return LocaleKeys.calendar_july.tr();
      case 8:
        return LocaleKeys.calendar_august.tr();
      case 9:
        return LocaleKeys.calendar_september.tr();
      case 10:
        return LocaleKeys.calendar_october.tr();
      case 11:
        return LocaleKeys.calendar_november.tr();
      case 12:
        return LocaleKeys.calendar_december.tr();
      default:
        return "";
    }
  }

  String _getDayOfTheWeek(int weekday) {
    switch (weekday) {
      case 1:
        return LocaleKeys.calendar_monday.tr();
      case 2:
        return LocaleKeys.calendar_tuesday.tr();
      case 3:
        return LocaleKeys.calendar_wednesday.tr();
      case 4:
        return LocaleKeys.calendar_thursday.tr();
      case 5:
        return LocaleKeys.calendar_friday.tr();
      case 6:
        return LocaleKeys.calendar_saturday.tr();
      case 7:
        return LocaleKeys.calendar_sunday.tr();
      default:
        return "";
    }
  }
}
