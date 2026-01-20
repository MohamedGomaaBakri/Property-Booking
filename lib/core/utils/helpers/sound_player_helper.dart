// import 'dart:developer';

// import 'package:audioplayers/audioplayers.dart';

// class SoundPlayerHelper {
//   static final SoundPlayerHelper _instance = SoundPlayerHelper._internal();

//   factory SoundPlayerHelper() => _instance;

//   late final AudioPlayer _audioPlayer;

//   SoundPlayerHelper._internal() {
//     _audioPlayer = AudioPlayer();
//   }

//   Future<void> playLocal(String assetPath) async {
//     try {
//       await _audioPlayer.play(AssetSource(assetPath));
//     } catch (e) {
//       log('Error playing local sound: $e');
//     }
//   }

//   Future<void> playRemote(String url) async {
//     try {
//       await _audioPlayer.play(UrlSource(url));
//     } catch (e) {
//       log('Error playing remote sound: $e');
//     }
//   }

//   Future<void> pause() async {
//     try {
//       await _audioPlayer.pause();
//     } catch (e) {
//       log('Error pausing audio: $e');
//     }
//   }

//   Future<void> resume() async {
//     try {
//       await _audioPlayer.resume();
//     } catch (e) {
//       log('Error resuming audio: $e');
//     }
//   }

//   Future<void> stop() async {
//     try {
//       await _audioPlayer.stop();
//     } catch (e) {
//       log('Error stopping audio: $e');
//     }
//   }

//   Future<void> setVolume(double volume) async {
//     try {
//       await _audioPlayer.setVolume(volume);
//     } catch (e) {
//       log('Error setting volume: $e');
//     }
//   }

//   void dispose() {
//     _audioPlayer.dispose();
//   }
// }
