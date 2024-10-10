import 'package:flutter/material.dart';

class SingleDayPersistentHeader extends SliverPersistentHeaderDelegate {
  const SingleDayPersistentHeader(this.child);

  final Widget child;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return child;
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }

  @override
  double get maxExtent => 44;

  @override
  double get minExtent => 44;
}
