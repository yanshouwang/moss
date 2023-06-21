import 'package:flutter/animation.dart';

class BarAnimation extends ReverseAnimation {
  BarAnimation({required AnimationController parent})
      : super(
          CurvedAnimation(
            parent: parent,
            curve: const Interval(0, 1 / 5),
            reverseCurve: const Interval(1 / 5, 4 / 5),
          ),
        );
}

class RailAnimation extends CurvedAnimation {
  RailAnimation({required super.parent})
      : super(
          curve: const Interval(0 / 5, 4 / 5),
          reverseCurve: const Interval(3 / 5, 1),
        );
}

class RailFabAnimation extends CurvedAnimation {
  RailFabAnimation({required super.parent})
      : super(
          curve: const Interval(3 / 5, 1),
        );
}

class OffsetAnimation extends CurvedAnimation {
  OffsetAnimation({required super.parent})
      : super(
          curve: const Interval(
            2 / 5,
            3 / 5,
            curve: Curves.easeInOutCubicEmphasized,
          ),
          reverseCurve: Interval(
            4 / 5,
            1,
            curve: Curves.easeInOutCubicEmphasized.flipped,
          ),
        );
}

class Offset1Animation extends CurvedAnimation {
  Offset1Animation({required super.parent})
      : super(
          curve: Interval(
            0 / 5,
            1 / 5,
            curve: Curves.easeInOutCubicEmphasized.flipped,
          ),
          reverseCurve: const Interval(
            2 / 5,
            3 / 5,
            curve: Curves.easeInOutCubicEmphasized,
          ),
        );
}

class ScaleAnimation extends CurvedAnimation {
  ScaleAnimation({required super.parent})
      : super(
          curve: const Interval(
            3 / 5,
            4 / 5,
            curve: Curves.easeInOutCubicEmphasized,
          ),
          reverseCurve: Interval(
            3 / 5,
            1,
            curve: Curves.easeInOutCubicEmphasized.flipped,
          ),
        );
}

class ShapeAnimation extends CurvedAnimation {
  ShapeAnimation({required super.parent})
      : super(
          curve: const Interval(
            2 / 5,
            3 / 5,
            curve: Curves.easeInOutCubicEmphasized,
          ),
        );
}

class SizeAnimation extends CurvedAnimation {
  SizeAnimation({required super.parent})
      : super(
          curve: const Interval(
            0 / 5,
            3 / 5,
            curve: Curves.easeInOutCubicEmphasized,
          ),
          reverseCurve: Interval(
            2 / 5,
            5 / 5,
            curve: Curves.easeInOutCubicEmphasized.flipped,
          ),
        );
}
