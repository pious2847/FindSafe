// websocket_service.dart
import 'dart:convert';

import 'package:lost_mode_app/services/alarm_service.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WebSocketService {
  late WebSocketChannel _channel;
  final List<String> _receivedCommands = [];
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

    await _channel.ready;

    _channel.stream.listen((message) {
      try {
        final String stringMessage = String.fromCharCodes(message);
        print('Received $stringMessage');

        final data = jsonDecode(stringMessage);
        print('Received data:  $data');
        final String command = data['command'];
        final String targetDeviceId = data['deviceId'];
        print('Current Device Id : $deviceId,    Target Device Id $targetDeviceId');
        if (targetDeviceId == deviceId) {
          print('Received command:  $data');
          _receivedCommands.add(command);
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
        } else {
          return;
        }
      } catch (e) {
        print('Error decoding or handling message: $e');
      }
    });
  }

  void disconnect() {
    _channel.sink.close();
  }

  Future<List<String>> getReceivedCommands() async {
    final commands = List<String>.from(_receivedCommands);
    _receivedCommands.clear();
    print('Recieve commands $commands');
    return commands;
  }

  void sendCommand(String command) {
    _channel.sink.add(command);
  }
}
