import 'package:flutter/material.dart';

class FiveDaysNavigationBar extends StatelessWidget {
  final double rowWidth;
  final Function() onTapLeft;
  final Function() onTapRight;

  const FiveDaysNavigationBar({
    required this.rowWidth,
    required this.onTapLeft,
    required this.onTapRight,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: () => onTapLeft(),
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.keyboard_arrow_left),
          ),
        ),
        InkWell(
          onTap: () => onTapRight(),
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.keyboard_arrow_right),
          ),
        ),
      ],
    );
  }
}
