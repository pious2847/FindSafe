import 'package:flutter/material.dart';
import 'package:lost_mode_app/models/phone_model.dart';

class PhoneListCard extends StatelessWidget {
  final Phone phone;
  final Function(String) onTap; // Add a callback function parameter

  const PhoneListCard({
    super.key,
    required this.phone,
    required this.onTap, // Add the callback function parameter
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(phone.deviceId), // Call the callback function with the device name
      child: Container(
        margin: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                phone.imageUrl,
                width: 90,
                height: 90,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              phone.name,
              style: const TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}