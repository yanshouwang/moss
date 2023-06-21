import 'models/communication.dart';
import 'models/udp_communication.dart';

export 'models/communication.dart';
export 'models/communication_type.dart';
export 'models/communication_state.dart';
export 'models/udp_communication.dart';
export 'models/tcp_communication.dart';
export 'models/serial_communication.dart';
export 'models/bluetooth_low_energy_communication.dart';
export 'models/end_symbol.dart';

class Attachment {
  const Attachment({
    required this.url,
  });

  final String url;
}

class Email {
  const Email({
    required this.sender,
    required this.recipients,
    required this.subject,
    required this.content,
    this.replies = 0,
    this.attachments = const [],
  });

  final User sender;
  final List<User> recipients;
  final String subject;
  final String content;
  final List<Attachment> attachments;
  final double replies;
}

class Name {
  const Name({
    required this.first,
    required this.last,
  });

  final String first;
  final String last;
  String get fullName => '$first $last';
}

class User {
  const User({
    required this.name,
    required this.avatarUrl,
    required this.lastActive,
  });

  final Name name;
  final String avatarUrl;
  final DateTime lastActive;
}

final communications = {
  for (var communication in <Communication>[
    UdpCommunication(
      remoteHost: '255.255.255.255',
      remotePort: 8000,
      localPort: 8001,
    ),
  ])
    communication.type: communication
};
