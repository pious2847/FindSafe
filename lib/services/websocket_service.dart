// websocket_service.dart
import 'package:web_socket_channel/io.dart';

class WebSocketService {
  static const String webSocketUrl =
      'wss://findsafe-backend.onrender.com'; // Use 'wss' for secure WebSocket connection

  static IOWebSocketChannel connect(String deviceId) {
    print('Connecting to WebSocket with Device ID: $deviceId');
    return IOWebSocketChannel.connect(
      Uri.parse('$webSocketUrl/$deviceId'),
    );
  }
}
