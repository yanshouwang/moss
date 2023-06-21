import 'package:flutter/foundation.dart';

import '../models.dart';

abstract class UdpSettingsViewModel {
  ValueListenable<String> get remoteHost;
  ValueListenable<int> get remotePort;
  ValueListenable<int> get localPort;

  void dispose();

  factory UdpSettingsViewModel() => _UdpSettingsViewModel();
}

UdpCommunication get _communication =>
    communications[CommunicationType.udp] as UdpCommunication;

class _UdpSettingsViewModel implements UdpSettingsViewModel {
  @override
  final ValueNotifier<String> remoteHost;
  @override
  final ValueNotifier<int> remotePort;
  @override
  final ValueNotifier<int> localPort;

  _UdpSettingsViewModel()
      : remoteHost = ValueNotifier(_communication.remoteHost),
        remotePort = ValueNotifier(_communication.remotePort),
        localPort = ValueNotifier(_communication.localPort);

  @override
  void dispose() {
    remoteHost.dispose();
    remotePort.dispose();
    localPort.dispose();
  }
}
