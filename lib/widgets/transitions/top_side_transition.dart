import 'package:flutter/material.dart';

import '../animations.dart';

class TopTransition extends StatelessWidget {
  final Animation<double> timeline;
  final Widget child;

  const TopTransition({
    super.key,
    required this.timeline,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final heightTween = Tween(
      begin: 1.0,
      end: 0.0,
    );
    final heightAnimation = SizeAnimation(parent: timeline).drive(heightTween);
    final translationTween = Tween(
      begin: Offset.zero,
      end: const Offset(0.0, -1.0),
    );
    final translationAnimation =
        Offset1Animation(parent: timeline).drive(translationTween);
    return AnimatedBuilder(
      animation: timeline,
      builder: (context, child) {
        return Align(
          alignment: Alignment.topCenter,
          heightFactor: heightAnimation.value,
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
