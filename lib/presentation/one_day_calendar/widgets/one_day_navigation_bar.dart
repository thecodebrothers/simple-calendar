part of calendar;

class OneDayNavigationBar extends StatefulWidget {
  final Function() onTapLeft;
  final Function() onTapRight;

  const OneDayNavigationBar(
      {required this.onTapLeft, required this.onTapRight, Key? key})
      : super(key: key);

  @override
  State<OneDayNavigationBar> createState() => _OneDayNavigationBarState();
}

class _OneDayNavigationBarState extends State<OneDayNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
                onTap: widget.onTapLeft,
                child: const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Icon(Icons.keyboard_arrow_left),
                )),
            InkWell(
                onTap: widget.onTapRight,
                child: const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Icon(Icons.keyboard_arrow_right),
                )),
          ],
        ),
      ),
    );
  }
}
