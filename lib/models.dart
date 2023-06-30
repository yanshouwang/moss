export 'models/communication.dart';
export 'models/communication_type.dart';
export 'models/communication_state.dart';
export 'models/udp_communication.dart';
export 'models/tcp_communication.dart';
export 'models/serial_communication.dart';
export 'models/bluetooth_low_energy_communication.dart';
export 'models/end_symbol.dart';

import 'models/communication.dart';
import 'models/udp_communication.dart';

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
