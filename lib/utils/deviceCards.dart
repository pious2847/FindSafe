import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:lost_mode_app/models/devices.dart';
import 'package:lost_mode_app/services/alarm_service.dart';
import 'package:lost_mode_app/services/devices.dart';
import 'package:lost_mode_app/services/websocket_service.dart';
import 'package:web_socket_channel/io.dart';

class DevicesCards extends StatefulWidget {
  final Device phone;
  final Function(String) onTap;
  final bool isActive;

  const DevicesCards({
    super.key,
    required this.phone,
    required this.onTap,
    this.isActive = false,
  });

  @override
  State<DevicesCards> createState() => _DevicesCardsState();
}

class _DevicesCardsState extends State<DevicesCards> {
  IOWebSocketChannel? _channel;
  final AlarmService _alarmService = AlarmService();

  @override
  void dispose() {
    _channel?.sink.close();
    super.dispose();
  }

  Future<void> _sendAlarmCommand(String deviceId) async {
    try {
      final result = await ApiService.sendAlarmCommand(deviceId);
      if (result['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Alarm command sent successfully')),
        );
        _connectWebSocket(deviceId);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send alarm command')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    }
  }

  void _connectWebSocket(String deviceId) {
    _channel = WebSocketService.connect(deviceId);
    _channel!.stream.listen((message) {
      final data = json.decode(message);
      if (data['command'] == 'play_alarm') {
        _alarmService.playAlarm();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(widget.phone.image),
        radius: 30,
      ),
      title: Text(widget.phone.devicename),
      subtitle: Text(widget.phone.mode),
      initiallyExpanded: widget.isActive,
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextButton.icon(
                  icon: const Icon(Iconsax.music_play_copy),
                  onPressed: () async {
                    if (widget.phone.id.isNotEmpty) {
                      await _sendAlarmCommand(widget.phone.id);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please enter a Device ID')),
                      );
                    }
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
                    ),
                    textStyle: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  label: const Text('Play Alarm'),
                ),
                TextButton.icon(
                  icon: const Icon(Iconsax.security_safe_copy),
                  onPressed: () async {
                    // Implement secure device logic here
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
                    ),
                    textStyle: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  label: const Text('Secure Device'),
                ),
                TextButton.icon(
                  icon: const Icon(Iconsax.map_copy),
                  onPressed: () => widget.onTap(widget.phone.id),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
                    ),
                    textStyle: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  label: const Text('Locate Device'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}


class CommandNotifier extends ChangeNotifier {
  List<String> _commands = [];

  List<String> get commands => _commands;

  void addCommand(String command) {
    _commands.add(command);
    notifyListeners();
  }
}
