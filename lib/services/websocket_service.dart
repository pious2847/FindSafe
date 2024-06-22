import 'package:web_socket_channel/io.dart';

class WebSocketService {
  static const String webSocketUrl =
      'ws://https://findsafe-backend.onrender.com';

  static IOWebSocketChannel connect(String deviceId) {
    print('Connection Established');
    return IOWebSocketChannel.connect(
      Uri.parse('$webSocketUrl/$deviceId'),
    );
  }
}
