// websocket_service.dart
import 'dart:convert';

import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WebSocketService {
  late WebSocketChannel _channel;

  void connect() async {
    final deviceData = await SharedPreferences.getInstance();
    final deviceId = deviceData.getString('deviceId');

    const String webSocketUrl =
        'wss://findsafe-backend.onrender.com'; // Use 'wss' for secure WebSocket connection
    _channel = IOWebSocketChannel.connect(
      Uri.parse('$webSocketUrl/$deviceId'),
    );

    _channel.stream.listen((message) {
      print('Revieved $message');
        // Parse the command and execute it
      final data = jsonDecode(message);
      if (data['command'] == 'play_alarm') {
        // Implement logic to play the alarm
      }
    });
  }
   void disconnect() {
    _channel.sink.close();
  }

  void sendCommand(String command) {
    _channel.sink.add(command);
  }
}
