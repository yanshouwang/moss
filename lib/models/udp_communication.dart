import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:moss/models/communication_type.dart';

import 'communication.dart';
import 'communication_state.dart';

class UdpCommunication extends Communication {
  final String remoteHost;
  final int remotePort;
  final int localPort;
  final ValueNotifier<CommunicationState> _state;
  final StreamController<Uint8List> _valueChangedController;

  late RawDatagramSocket _socket;
  late StreamSubscription<RawSocketEvent> _subscription;

  UdpCommunication({
    required this.remoteHost,
    required this.remotePort,
    required this.localPort,
  })  : _state = ValueNotifier(CommunicationState.disconnected),
        _valueChangedController = StreamController<Uint8List>.broadcast();

  @override
  CommunicationType get type => CommunicationType.udp;
  @override
  ValueListenable<CommunicationState> get state => _state;
  @override
  Stream<Uint8List> get valueChanged => _valueChangedController.stream;

  @override
  Future<void> write(Uint8List value) {
    return Future.sync(() {
      final remoteAddress = InternetAddress(remoteHost);
      _socket.send(value, remoteAddress, remotePort);
    });
  }

  @override
  Future<void> connect() async {
    try {
      _state.value = CommunicationState.connecting;
      _socket = await RawDatagramSocket.bind(
        InternetAddress.anyIPv4,
        localPort,
      );
      _socket.broadcastEnabled = true;
      _subscription = _socket.listen((event) {
        if (event != RawSocketEvent.read) {
          return;
        }
        final datagram = _socket.receive();
        if (datagram == null) {
          return;
        }
        _valueChangedController.add(datagram.data);
      });
      _state.value = CommunicationState.connected;
    } catch (e) {
      _state.value = CommunicationState.disconnected;
    }
  }

  @override
  void disconnect() {
    _subscription.cancel();
    _socket.close();
    _state.value = CommunicationState.disconnected;
  }
}
