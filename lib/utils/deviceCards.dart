// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, avoid_print

import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lost_mode_app/models/devices.dart';
import 'package:lost_mode_app/models/phone_model.dart';

class DevicesCards extends StatelessWidget {
  final Device phone;
  final Function(String) onTap;
  final bool isActive; // Add a boolean parameter for active state

  const DevicesCards({
    super.key,
    required this.phone,
    required this.onTap,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      onExpansionChanged: onTap(phone.id),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(phone.image),
        radius: 50,
      ),
      title: Text(phone.devicename),
      subtitle: Text(phone.mode),
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
              ],
            ),
          ),
        ),
      ],
    );
  }
}
