import 'package:flutter/material.dart';
import 'package:simple_calendar/constants/constants.dart';

class CurrentTime extends StatelessWidget {
  final int numberOfConstantsTasks;

  const CurrentTime({required this.numberOfConstantsTasks, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: numberOfConstantsTasks * kCellHeight +
          DateTime.now().hour * kCellHeight +
          DateTime.now().minute,
      left: 0,
      right: 0,
      child: Container(
        height: 2,
        decoration: const BoxDecoration(color: Colors.black),
      ),
    );
  }
}
