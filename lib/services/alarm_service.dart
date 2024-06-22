import 'package:audioplayers/audioplayers.dart';

class AlarmService {
  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> playAlarm() async {
    await _audioPlayer.play(AssetSource('assets/audio/alarmtone.mp3'));
  }
}
