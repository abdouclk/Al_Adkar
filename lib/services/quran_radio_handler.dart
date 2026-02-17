// ignore_for_file: prefer_const_constructors

import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

/// Audio handler for Quran Radio that provides:
/// - Background playback
/// - Lock screen controls
/// - Media notifications
/// - No auto-stop
class QuranRadioHandler extends BaseAudioHandler {
  final AudioPlayer _player = AudioPlayer();
  
  QuranRadioHandler() {
    // Initialize playback state
    playbackState.add(PlaybackState(
      controls: [],
      systemActions: const {},
      playing: false,
      processingState: AudioProcessingState.idle,
    ));
    
    // Listen to player state changes and update playback state
    _player.playbackEventStream.listen(_updatePlaybackState);
    
    // Listen to player errors
    _player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        stop();
      }
    });
  }

  /// Play a radio station
  Future<void> playStation(String url, String stationName, String reciter) async {
    try {
      // Update media item (shows in notification)
      mediaItem.add(MediaItem(
        id: url,
        title: stationName,
        artist: reciter,
        artUri: null, // You can add an icon URI here if you have one
        playable: true,
        duration: null, // Live stream has no duration
      ));

      // Set audio source
      await _player.setUrl(url);
      
      // Start playing
      await _player.play();
      
      // Update state to playing
      playbackState.add(playbackState.value.copyWith(
        controls: [
          MediaControl.stop,
        ],
        systemActions: const {
          MediaAction.stop,
        },
        playing: true,
        processingState: AudioProcessingState.ready,
      ));
    } catch (e) {
      print('Error playing station: $e');
      playbackState.add(playbackState.value.copyWith(
        processingState: AudioProcessingState.error,
        playing: false,
      ));
    }
  }

  /// Update playback state based on player events
  void _updatePlaybackState(PlaybackEvent event) {
    playbackState.add(playbackState.value.copyWith(
      controls: [
        if (_player.playing) MediaControl.stop else MediaControl.play,
      ],
      systemActions: const {
        MediaAction.play,
        MediaAction.stop,
      },
      playing: _player.playing,
      processingState: {
        ProcessingState.idle: AudioProcessingState.idle,
        ProcessingState.loading: AudioProcessingState.loading,
        ProcessingState.buffering: AudioProcessingState.buffering,
        ProcessingState.ready: AudioProcessingState.ready,
        ProcessingState.completed: AudioProcessingState.completed,
      }[_player.processingState]!,
      updatePosition: _player.position,
    ));
  }

  @override
  Future<void> play() async {
    await _player.play();
  }

  @override
  Future<void> pause() async {
    await _player.pause();
  }

  @override
  Future<void> stop() async {
    await _player.stop();
    await super.stop();
  }

  @override
  Future<void> seek(Duration position) async {
    await _player.seek(position);
  }

  /// Change volume
  Future<void> setVolume(double volume) async {
    await _player.setVolume(volume);
  }

  /// Get current playing state
  bool get isPlaying => _player.playing;

  /// Get current volume
  double get volume => _player.volume;

  /// Dispose resources
  Future<void> dispose() async {
    await _player.dispose();
  }
}
