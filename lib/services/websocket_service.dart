// websocket_service.dart
import 'dart:convert';

import 'package:lost_mode_app/services/alarm_service.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WebSocketService {
  late WebSocketChannel _channel;
  final _AlarmService = AlarmService();

  void connect() async {
    final deviceData = await SharedPreferences.getInstance();
    final deviceId = deviceData.getString('deviceId');

    const String webSocketUrl =
        'wss://findsafe-backend.onrender.com'; // Use 'wss' for secure WebSocket connection
    print('webSocketUrl : $webSocketUrl');
    print('deviceId : $deviceId');

    _channel = IOWebSocketChannel.connect(
      Uri.parse('$webSocketUrl/$deviceId'),
    );

    _channel.stream.listen((message) {
      print('Revieved $message');
      // Parse the command and execute it
      final data = jsonDecode(message);
      if (data['command'] == 'play_alarm') {
        _AlarmService.playAlarm();
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