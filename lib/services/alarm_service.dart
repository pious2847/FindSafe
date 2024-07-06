import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class AlarmService {
  
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  late AudioPlayer _player;
  int _playCount = 0;

  AlarmService() {
    _initializeNotifications();
  }

  void _initializeNotifications() async {
    const initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  void playAlarm() async {
    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'alarm_channel',
      'Alarm Notifications',
      importance: Importance.max,
      priority: Priority.high,
      sound: RawResourceAndroidNotificationSound(
          'alarm'), // Make sure to add an alarm sound file in your res/raw folder

      playSound: true,
      enableVibration: true,
    );
    const platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );
    flutterLocalNotificationsPlugin.show(
      0,
      'Alarm',
      'This is an alarm notification',
      platformChannelSpecifics,
      payload: 'alarm',
    );
  _player = AudioPlayer();
  _playCount = 0;

    playAudioThreeTimes();
  }

  void playAudioThreeTimes() async {
    if (_playCount < 3) {
      try {
        print('Playing audio. Count: $_playCount');
        await _player.setSource(AssetSource('audio/alarm.mp3'));
        await _player.resume();
        _playCount++;

        // Wait for the audio to finish before playing again
        _player.onPlayerComplete.listen((_) {
          print('Audio completed. Play count: $_playCount');
          if (_playCount < 3) {
            playAudioThreeTimes();
          } else {
            print('Finished playing 3 times. Stopping.');
            _player.stop();
            _player.dispose();
          }
        });
      } catch (e) {
        print('Error playing audio: $e');
      }
    }
  }

  Future<void> showLostModeNotification() async {
    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'lost_mode_channel',
      'Lost Mode',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    // const iOSPlatformChannelSpecifics = IOSNotificationDetails();
    const platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      // iOS: iOSPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      'Security Alert',
      'Your device has been put in lost mode.',
      platformChannelSpecifics,
      payload: 'lost_mode_notification',
    );
  }
}
