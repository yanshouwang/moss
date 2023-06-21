import 'package:flutter/material.dart';

import '../animations.dart';

class BottomLeftTransition extends StatelessWidget {
  final Animation<double> timeline;
  final Widget child;

  const BottomLeftTransition({
    super.key,
    required this.timeline,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final widthTween = Tween(
      begin: 0.0,
      end: 1.0,
    );
    final widthAnimation = SizeAnimation(parent: timeline).drive(widthTween);
    final translationTween = Tween(
      begin: Directionality.of(context) == TextDirection.ltr
          ? const Offset(-1.0, 0.0)
          : const Offset(1.0, 0.0),
      end: Offset.zero,
    );
    final translationAnimation =
        OffsetAnimation(parent: timeline).drive(translationTween);
    return AnimatedBuilder(
      animation: timeline,
      builder: (context, child) {
        return Align(
          alignment: Alignment.centerLeft,
          widthFactor: widthAnimation.value,
          child: FractionalTranslation(
            translation: translationAnimation.value,
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
