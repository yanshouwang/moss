import 'package:flutter/material.dart';

class BottomWriteTransition extends StatelessWidget {
  final Animation<double> animation;
  final Widget child;
  const BottomWriteTransition({
    super.key,
    required this.animation,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final slideTween = Tween(
      begin: Offset.zero,
      end: const Offset(0.0, 1.0),
    );
    final slideAnimation = CurvedAnimation(
      parent: animation,
      curve: const Interval(
        0 / 5,
        5 / 5,
        curve: Curves.easeInOutCubicEmphasized,
      ),
    ).drive(slideTween);
    final heightTween = Tween(begin: 1.0, end: 0.0);
    final heightAnimation = CurvedAnimation(
      parent: animation,
      curve: const Interval(
        2 / 5,
        5 / 5,
        curve: Curves.easeInOutCubicEmphasized,
      ),
    ).drive(heightTween);
    return SizeTransition(
      sizeFactor: heightAnimation,
      child: SlideTransition(
        position: slideAnimation,
        child: child,
      ),
    );
  }
}
