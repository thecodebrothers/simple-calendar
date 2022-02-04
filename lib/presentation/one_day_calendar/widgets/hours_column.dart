part of calendar;

class Hours extends StatelessWidget {
  const Hours({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: kHoursSpaceOnTop,
        ),
        for (int i = 1; i < 25; i++) CalendarHourCell(hour: i),
      ],
    );
  }
}
