part of calendar;

class EmptyCells extends StatelessWidget {
  final DateTime date;
  const EmptyCells({required this.date, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SingleDayDate(date: date),
        for (int i = 1; i < 25; i++)
          Container(
            height: 60,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade200, width: 1)),
          )
      ],
    );
  }
}
