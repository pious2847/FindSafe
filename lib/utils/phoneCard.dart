import 'package:flutter/material.dart';
import 'package:lost_mode_app/models/phone_model.dart';

class PhoneListCard extends StatelessWidget {
  final Phone phone;
  final Function(String) onTap;
  final bool isActive; // Add a boolean parameter for active state

  const PhoneListCard({
    super.key,
    required this.phone,
    required this.onTap,
    this.isActive = false, // Set the default value to false
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(phone.deviceId),
      child: Container(
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: isActive
              ? Colors.blue.withOpacity(0.2)
              : null, // Apply the active background color if isActive is true
        ),
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
                  errorBuilder: (context, error, stackTrace) {
                    // Handle the error case
                    return Container(
                      width: 90,
                      height: 90,
                      alignment: Alignment.center,
                      child: const Icon(Icons.error),
                    );
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    }
                    double? progress;
                    if (loadingProgress.expectedTotalBytes != null) {
                      progress = loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!;
                    }
                    return Container(
                      width: 90,
                      height: 90,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        value: progress,
                      ),
                    );
                  },
                )),
            
            const SizedBox(height: 8.0),
            Text(
              phone.name,
              style: const TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (isActive) // Show an active indicator if isActive is true
              const SizedBox(height: 4.0),
            if (isActive)
              Container(
                width: 8.0,
                height: 8.0,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors
                      .green, // Change the color of the active indicator as desired
                ),
              ),
          ],
        ),
      ),
    );
  }
}
