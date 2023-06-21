import 'package:flutter/foundation.dart';

import 'communication_state.dart';
import 'communication_type.dart';

abstract class Communication {
  CommunicationType get type;
  ValueListenable<CommunicationState> get state;
  Stream<Uint8List> get valueChanged;

  Future<void> connect();
  void disconnect();
  Future<void> write(Uint8List value);
}
