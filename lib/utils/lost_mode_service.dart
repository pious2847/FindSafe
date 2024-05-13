// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:lost_mode_app/.env.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:wakelock/wakelock.dart';
// import 'package:workmanager/workmanager.dart';
// import 'package:device_unlock_zuel/device_unlock_zuel.dart';

// @pragma('vm:entry-point')
// void callbackDispatcher() {
//   Workmanager().executeTask((taskName, inputData) async {
//     final isLostMode = await checkLostMode();

//     if (isLostMode) {
//       // Lost mode is activated
//       await Wakelock
//           .enable(); // Acquire a wakelock to prevent the device from being turned off
//       try {
//         final deviceUnlock =
//             DeviceUnlock(); // Create an instance of DeviceUnlock
//         final unlocked = await deviceUnlock.request(
//           localizedReason: 'We need to check your identity.',
//         );

//         if (!unlocked) {
//           // User did not pass face, touch, or pin validation
//           // Show a lock screen with a prompt for the activation code
//           showDisableScreen();
//         }
//       } on DeviceUnlockUnavailable {
//         // Device does not have face, touch, or pin security available
//         // Show a lock screen with a prompt for the activation code
//         showDisableScreen();
//       } on RequestInProgress {
//         // A new request was sent before the first one finishes
//         // Handle this case as per your requirements
//       }
//     } else {
//       // Lost mode is deactivated
//       await Wakelock.disable(); // Release the wakelock
//     }
//     return Future.value(true);
//   });
// }

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await initializeBackgroundTask();
// }

// Future<void> initializeBackgroundTask() async {
//   await Workmanager().initialize(
//     callbackDispatcher,
//     isInDebugMode: true, // Set this to false for production
//   );

//   await Workmanager().registerPeriodicTask(
//     'lost_mode_task',
//     'Lost Mode Task',
//     frequency:
//         const Duration(minutes: 2), // Check for lost mode every 2 minutes
//     constraints: Constraints(
//       networkType:
//           NetworkType.connected, // Only run when connected to the internet
//     ),
//   );
// }

// Future<bool> checkLostMode() async {
//   final dio = Dio();
//   final deviceData = await SharedPreferences.getInstance();
//   final deviceId = deviceData.getString('deviceId');

//   final url = '$APIURL/api/devices/$deviceId/mode';

//   try {
//     final response = await dio.get(url);
//     final deviceMode = response.data['mode'];
//     return deviceMode == 'disable';
//   } catch (e) {
//     print('Error fetching device mode: $e');
//     return false;
//   }
// }

// Future<bool> validateActivationCode(String activationCode) async {
//   final dio = Dio();
//   final deviceData = await SharedPreferences.getInstance();
//   final deviceId = deviceData.getString('deviceId');

//   final url = '$APIURL/$deviceId/validate-activation-code';
//   final data = {'activationCode': activationCode};

//   try {
//     final response = await dio.post(url, data: data);
//     return response.data['isValid'];
//   } catch (e) {
//     print('Error validating activation code: $e');
//     return false;
//   }
// }

// void onActivationCodeEntered(String activationCode) async {
//   final isValid = await validateActivationCode(activationCode);

//   if (isValid) {
//     await Wakelock.disable(); // Release the wakelock
//     // Perform any other actions needed for the "active" mode
//     // (e.g., unlock the device, enable hardware buttons, etc.)
//   }
// }

// void showDisableScreen() {
//   // Create a new route for the disable screen
//   WidgetsBinding.instance.addPostFrameCallback((_) {
//     Get.to(const DisableScreen());
//   });
// }

// class DisableScreen extends StatefulWidget {
//   const DisableScreen({Key? key}) : super(key: key);

//   @override
//   _DisableScreenState createState() => _DisableScreenState();
// }

// class _DisableScreenState extends State<DisableScreen> {
//   final TextEditingController _activationCodeController =
//       TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Text(
//               'Device Disabled',
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 16),
//             const Text(
//               'Enter the activation code to unlock the device:',
//               style: TextStyle(fontSize: 16),
//             ),
//             const SizedBox(height: 16),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               child: TextField(
//                 controller: _activationCodeController,
//                 decoration: const InputDecoration(
//                   hintText: 'Activation Code',
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: () {
//                 final activationCode = _activationCodeController.text.trim();
//                 onActivationCodeEntered(activationCode);
//               },
//               child: const Text('Unlock Device'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _activationCodeController.dispose();
//     super.dispose();
//   }
// }
