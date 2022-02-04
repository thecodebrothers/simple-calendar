part of calendar;

class CurrentTime extends StatelessWidget {
  const CurrentTime({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: DateTime.now().hour * 60 + DateTime.now().minute + 22,
      left: 0,
      right: 0,
      child: Container(
        height: 2,
        decoration: const BoxDecoration(color: Colors.black),
      ),
    );
  }
}
