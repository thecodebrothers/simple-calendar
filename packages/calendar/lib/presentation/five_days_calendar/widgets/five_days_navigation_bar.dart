import 'package:flutter/material.dart';

class FiveDaysNavigationBar extends StatelessWidget {
  final ScrollController scrollController;
  final double rowWidth;

  const FiveDaysNavigationBar(
      {required this.scrollController, required this.rowWidth, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
                onTap: () {
                  if (scrollController.offset % rowWidth < 3) {
                    scrollController.animateTo(
                        scrollController.offset - rowWidth,
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeIn);
                  } else {
                    scrollController.animateTo(
                        scrollController.offset -
                            scrollController.offset % rowWidth,
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeIn);
                  }
                },
                child: const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Icon(Icons.keyboard_arrow_left),
                )),
            InkWell(
                onTap: () {
                  if (scrollController.offset % rowWidth < 3 ||
                      scrollController.offset % rowWidth > 116) {
                    scrollController.animateTo(
                        scrollController.offset + rowWidth,
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeIn);
                  } else {
                    scrollController.animateTo(
                        scrollController.offset +
                            (rowWidth - scrollController.offset % rowWidth),
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeIn);
                  }
                },
                child: const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Icon(Icons.keyboard_arrow_right),
                )),
          ],
        ),
      ),
    );
  }
}
