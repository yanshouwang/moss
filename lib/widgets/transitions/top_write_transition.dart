import 'package:flutter/material.dart';

class TopWriteTransition extends StatelessWidget {
  final Animation<double> animation;
  final Widget child;
  const TopWriteTransition({
    super.key,
    required this.animation,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final widthTween = Tween(
      begin: 0.0,
      end: 1.0,
    );
    final widthAnimation = CurvedAnimation(
      parent: animation,
      curve: const Interval(
        0 / 5,
        5 / 5,
        curve: Curves.easeInOutCubicEmphasized,
      ),
    ).drive(widthTween);
    final slideTween = Tween(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    );
    final slideAnimation = CurvedAnimation(
      parent: animation,
      curve: const Interval(
        3 / 5,
        5 / 5,
        curve: Curves.easeInOutCubicEmphasized,
      ),
    ).drive(slideTween);
    return SizeTransition(
      axis: Axis.horizontal,
      sizeFactor: widthAnimation,
      axisAlignment: 1.0,
      child: SlideTransition(
        position: slideAnimation,
        child: child,
      ),
    );
  }
}
