import 'package:flutter/material.dart';

/// 飞行过渡
class FlyTransition extends StatelessWidget {
  const FlyTransition({
    super.key,
    required this.animation,
    required this.axis,
    required this.isMinimumSide,
    this.isHideToVisible = true,
    this.stickySize = 0.0,
    required this.child,
  });

  final Animation<double> animation;
  final Axis axis;

  /// 对于 `Axis.horizontal`，若此值为 ture，运动方向与当前文字方向一致，否则运动方向与当前文字方向相反
  ///
  /// 对于 `Axis.vertical`，若此值为 ture，运动方向为自上而下，否则运动方向为自下而上
  final bool isMinimumSide;

  /// 若此值为 true，执行飞入过渡，否则执行飞出过渡
  final bool isHideToVisible;

  /// 飞出状态下保留的尺寸
  final double stickySize;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final animation =
        isHideToVisible ? this.animation : ReverseAnimation(this.animation);
    final textDirection = Directionality.of(context);
    final distance = isMinimumSide ? -1.0 : 1.0;
    final slideTween = Tween(
      begin: Offset(
        axis == Axis.horizontal ? distance : 0.0,
        axis == Axis.vertical ? distance : 0.0,
      ),
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
    final sizeTween = Tween(
      begin: 0.0,
      end: 1.0,
    );
    final sizeAnimation = CurvedAnimation(
      parent: animation,
      curve: const Interval(
        0 / 5,
        5 / 5,
        curve: Curves.easeInOutCubicEmphasized,
      ),
    ).drive(sizeTween);
    return Stack(
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: stickySize,
            minHeight: stickySize,
          ),
        ),
        SizeTransition(
          sizeFactor: sizeAnimation,
          axis: axis,
          axisAlignment: isMinimumSide ? 0.0 : 1.0,
          child: SlideTransition(
            position: slideAnimation,
            textDirection: textDirection,
            child: child,
          ),
        ),
      ],
    );
  }

  Widget buildStickyView(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: stickySize,
        minHeight: stickySize,
      ),
    );
  }
}
