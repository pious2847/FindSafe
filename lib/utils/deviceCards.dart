// DeviceCard.dart
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:flutter/material.dart';
import 'package:lost_mode_app/models/devices.dart';
import 'package:lost_mode_app/services/devices.dart';
import 'package:lost_mode_app/services/websocket_service.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

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
    WebSocketChannel? _channel;

  @override
  void initState() {
    super.initState();
  }

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
      Provider.of<CommandNotifier>(context, listen: false).addCommand(message);
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
      initiallyExpanded: widget.isActive, // Reflect active state
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
                  icon: const Icon(Iconsax.music),
                  onPressed: () async {
                     if (widget.phone.id.isEmpty) {
                  _sendAlarmCommand(widget.phone.id);
                  _connectWebSocket(widget.phone.id);
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
                  icon: const Icon(Iconsax.security_copy),
                  onPressed: () async {},
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
                  onPressed:() => widget.onTap(widget.phone.id),
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