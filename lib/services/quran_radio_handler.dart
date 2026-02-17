// ignore_for_file: prefer_const_constructors, avoid_print

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
    print('🎵 [Handler] Constructor called - creating new QuranRadioHandler');
    
    // Initialize playback state
    print('🎵 [Handler] Initializing playback state...');
    playbackState.add(PlaybackState(
      controls: [],
      systemActions: const {},
      playing: false,
      processingState: AudioProcessingState.idle,
    ));
    print('✅ [Handler] Initial playback state set');

    // Listen to player state changes and update playback state
    print('🎵 [Handler] Setting up player event listeners...');
    _player.playbackEventStream.listen(_updatePlaybackState);
    print('✅ [Handler] Playback event listener set');

    // Listen to player errors
    _player.playerStateStream.listen((state) {
      print('🎵 [Handler] Player state changed: ${state.processingState}');
      if (state.processingState == ProcessingState.completed) {
        print('🎵 [Handler] Stream completed, stopping...');
        stop();
      }
    });
    print('✅ [Handler] Player state listener set');
    
    print('✅ [Handler] QuranRadioHandler fully constructed');
  }

  /// Play a radio station
  Future<void> playStation(
      String url, String stationName, String reciter) async {
    print('🎵 [Handler] playStation called');
    print('🎵 [Handler] URL: $url');
    print('🎵 [Handler] Station: $stationName');
    
    try {
      // Update media item (shows in notification)
      print('🎵 [Handler] Setting media item...');
      mediaItem.add(MediaItem(
        id: url,
        title: stationName,
        artist: reciter,
        artUri: null, // You can add an icon URI here if you have one
        playable: true,
        duration: null, // Live stream has no duration
      ));
      print('✅ [Handler] Media item set');

      // Set audio source
      print('🎵 [Handler] Setting audio URL...');
      await _player.setUrl(url);
      print('✅ [Handler] Audio URL set');

      // Start playing
      print('🎵 [Handler] Starting player...');
      await _player.play();
      print('✅ [Handler] Player started');

      // Update state to playing
      print('🎵 [Handler] Updating playback state...');
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
      print('✅ [Handler] Playback state updated - playing=true');
    } catch (e, stackTrace) {
      print('❌ [Handler] Error playing station: $e');
      print('❌ [Handler] Stack trace: $stackTrace');
      playbackState.add(playbackState.value.copyWith(
        processingState: AudioProcessingState.error,
        playing: false,
      ));
      rethrow; // Re-throw so the UI can catch it
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
