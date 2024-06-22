import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  static const String webSocketUrl = 'ws://localhost:8080';

  static WebSocketChannel connect(String deviceId) {
    return WebSocketChannel.connect(
      Uri.parse('$webSocketUrl/$deviceId'),
    );
  }
}
