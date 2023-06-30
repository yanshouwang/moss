import 'dart:ui';

extension ExTextDirection on TextDirection {
  bool get isLTR => this == TextDirection.ltr;
  bool get isRTL => this == TextDirection.rtl;
}
