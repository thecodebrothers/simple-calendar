part of calendar;

class FiveDaysDate extends StatelessWidget {
  final DateTime date;
  final double rowWidth;

  const FiveDaysDate({required this.date, required this.rowWidth, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: kFiveDaysDateHeight,
      width: rowWidth,
      child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text:
                "${date.day} ${_getMonth(date.month)} ${date.year}, ${_getDayOfTheWeek(date.weekday)}",
            style: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black),
          )),
    );
  }

  String _getMonth(int month) {
    switch (month) {
      case 1:
        return "Jan";
      case 2:
        return "Feb";
      case 3:
        return "Mar";
      case 4:
        return "Apr";
      case 5:
        return "May";
      case 6:
        return "Jun";
      case 7:
        return "Jul";
      case 8:
        return "Aug";
      case 9:
        return "Sep";
      case 10:
        return "Oct";
      case 11:
        return "Nov";
      case 12:
        return "Dec";
      default:
        return "";
    }
  }

  String _getDayOfTheWeek(int weekday) {
    switch (weekday) {
      case 1:
        return "Mon";
      case 2:
        return "Tue";
      case 3:
        return "Wed";
      case 4:
        return "Thu";
      case 5:
        return "Fri";
      case 6:
        return "Sat";
      case 7:
        return "Sun";
      default:
        return "";
    }
  }
}
