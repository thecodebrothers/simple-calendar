import 'package:flutter/material.dart';

class CurrentTime extends StatelessWidget {
  final double rowHeight;
  final int startHour;

  const CurrentTime({
    required this.rowHeight,
    required this.startHour,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: DateTime.now().hour * rowHeight +
          DateTime.now().minute -
          startHour * rowHeight,
      left: 0,
      right: 0,
      child: Container(
        height: 2,
        decoration: const BoxDecoration(color: Colors.black),
      ),
    );
  }
}
