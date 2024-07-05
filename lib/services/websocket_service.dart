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
      print('Received $message');
      try {
        final data = jsonDecode(message);
        final String command = data['command'];

        switch (command) {
          case 'play_alarm':
            _AlarmService.playAlarm();
            break;
          case 'other_command':
            print('unknown command');
            break;
          default:
            print('Unknown command: $command');
        }
      } catch (e) {
        print('Error decoding or handling message: $e');
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
