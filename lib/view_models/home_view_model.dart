import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:moss/models.dart';

abstract class HomeViewModel {
  List<CommunicationType> get communicationTypes;
  ValueListenable<CommunicationType> get communicationType;
  ValueListenable<CommunicationState> get communicationState;
  List<Encoding> get encodings;
  ValueListenable<Encoding> get encoding;
  ValueListenable<List<String>> get receivedMessages;
  ValueListenable<List<String>> get sendMessages;
  List<EndSymbol> get endSymbols;
  ValueListenable<EndSymbol> get endSymbol;

  Future<void> connect();
  void disconnect();
  Future<void> write(String message);
  void setCommunicationType(CommunicationType value);
  void setEncoding(Encoding value);
  void setEndSymbol(EndSymbol value);
  void dispose();

  factory HomeViewModel() => _HomeViewModel();
}

class _HomeViewModel implements HomeViewModel {
  @override
  final List<CommunicationType> communicationTypes;
  @override
  final ValueNotifier<CommunicationType> communicationType;
  @override
  final ValueNotifier<CommunicationState> communicationState;
  @override
  final List<Encoding> encodings;
  @override
  final ValueNotifier<Encoding> encoding;
  @override
  final ValueNotifier<List<String>> receivedMessages;
  @override
  final ValueNotifier<List<String>> sendMessages;
  @override
  final List<EndSymbol> endSymbols;
  @override
  final ValueNotifier<EndSymbol> endSymbol;

  late StreamSubscription<Uint8List> valueChangedSubscription;

  _HomeViewModel()
      : communicationTypes = communications.keys.toList(),
        communicationType = ValueNotifier(communications.keys.elementAt(0)),
        communicationState =
            ValueNotifier(communications.values.elementAt(0).state.value),
        encodings = [
          ascii,
          utf8,
        ],
        encoding = ValueNotifier(ascii),
        receivedMessages = ValueNotifier([]),
        sendMessages = ValueNotifier([]),
        endSymbols = EndSymbol.values,
        endSymbol = ValueNotifier(EndSymbol.none) {
    setupCommunication();
  }

  Communication get _communication => communications[communicationType.value]!;

  @override
  Future<void> connect() => _communication.connect();

  @override
  void disconnect() => _communication.disconnect();

  @override
  Future<void> write(String message) {
    final encoding = this.encoding.value;
    final endSymbol = this.endSymbol.value;
    final elements = [
      ...encoding.encode(message),
      ...endSymbol.elements,
    ];
    final value = Uint8List.fromList(elements);
    return _communication.write(value);
  }

  @override
  void setCommunicationType(CommunicationType value) {
    throw UnimplementedError();
  }

  @override
  void setEncoding(Encoding value) {
    encoding.value = value;
  }

  @override
  void setEndSymbol(EndSymbol value) {
    endSymbol.value = value;
  }

  @override
  void dispose() {
    tearDownCommunicationService();
    communicationType.dispose();
    communicationState.dispose();
    encoding.dispose();
    receivedMessages.dispose();
    endSymbol.dispose();
  }

  void setupCommunication() {
    communicationState.value = _communication.state.value;
    _communication.state.addListener(onCommunicationStateChagned);
    valueChangedSubscription = _communication.valueChanged.listen((value) {
      final encoding = this.encoding.value;
      final message = encoding.decode(value);
      receivedMessages.value = [
        ...receivedMessages.value,
        message,
      ];
    });
  }

  void tearDownCommunicationService() {
    _communication.state.removeListener(onCommunicationStateChagned);
    valueChangedSubscription.cancel();
  }

  void onCommunicationStateChagned() {
    communicationState.value = _communication.state.value;
  }
}

extension on EndSymbol {
  List<int> get elements {
    switch (this) {
      case EndSymbol.none:
        return [];
      case EndSymbol.cr:
        return [0x0d];
      case EndSymbol.lf:
        return [0x0a];
      case EndSymbol.crLF:
        return [0x0d, 0x0a];
      case EndSymbol.nul:
        return [0x00];
      default:
        throw ArgumentError.value(this);
    }
  }
}
