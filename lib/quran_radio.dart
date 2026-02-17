// ignore_for_file: use_super_parameters, prefer_const_constructors, deprecated_member_use, avoid_print

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:audio_service/audio_service.dart';
import 'services/quran_radio_handler.dart';
import 'widgets/app_scaffold.dart';

class QuranRadio extends StatefulWidget {
  const QuranRadio({Key? key}) : super(key: key);

  @override
  State<QuranRadio> createState() => _QuranRadioState();
}

class _QuranRadioState extends State<QuranRadio> with TickerProviderStateMixin {
  QuranRadioHandler? _audioHandler;
  bool _isPlaying = false;
  bool _isLoading = false;
  double _volume = 0.7;
  int _selectedStationIndex = 0;
  late AnimationController _pulseController;

  final List<Map<String, String>> _stations = [
    {
      'name': 'إذاعة القرآن الكريم من الرياض',
      'url': 'https://qurango.net/radio/tarateel',
      'reciter': 'قراء متنوعون',
    },
    {
      'name': 'القرآن الكريم - الشيخ عبد الباسط',
      'url': 'https://Qurango.net/radio/abdulbasit_abdulsamad_mojawwad',
      'reciter': 'عبد الباسط عبد الصمد',
    },
    {
      'name': 'القرآن الكريم - الشيخ ماهر المعيقلي',
      'url': 'https://Qurango.net/radio/maher_almu-aiqly',
      'reciter': 'ماهر المعيقلي',
    },
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _initAudioService();
  }

  /// Initialize audio service with foreground service
  Future<void> _initAudioService() async {
    print('🎵 [QuranRadio] Starting audio service initialization...');
    try {
      // Check if already initialized
      if (_audioHandler != null) {
        print('🎵 [QuranRadio] Audio service already initialized');
        return;
      }

      print('🎵 [QuranRadio] Creating audio handler...');
      QuranRadioHandler handler = QuranRadioHandler();
      print('🎵 [QuranRadio] Handler created, calling AudioService.init...');
      
      _audioHandler = await AudioService.init(
        builder: () => handler,
        config: AudioServiceConfig(
          androidNotificationChannelId: 'com.abdouclk.aladkar.radio',
          androidNotificationChannelName: 'إذاعة القرآن الكريم',
          androidNotificationIcon: 'mipmap/ic_launcher',
          androidShowNotificationBadge: true,
          androidNotificationOngoing: true,
          androidStopForegroundOnPause: false, // Keep notification when paused
          notificationColor: Color(0xFF0B6623),
        ),
      );
      
      print('🎵 [QuranRadio] AudioService.init completed!');
      print('🎵 [QuranRadio] Handler instance: ${_audioHandler != null ? "NOT NULL" : "NULL"}');

      if (_audioHandler == null) {
        throw Exception('AudioService.init returned null');
      }

      // Listen to playback state changes
      _audioHandler!.playbackState.listen((state) {
        print('🎵 [QuranRadio] Playback state changed: playing=${state.playing}, processingState=${state.processingState}');
        if (mounted) {
          setState(() {
            _isPlaying = state.playing;
            _isLoading = state.processingState == AudioProcessingState.loading ||
                state.processingState == AudioProcessingState.buffering;
          });
        }
      });
      
      print('🎵 [QuranRadio] Setting initial volume to $_volume');

      // Set initial volume
      await _audioHandler!.setVolume(_volume);
      
      print('✅ [QuranRadio] Audio service fully initialized and ready!');
    } catch (e, stackTrace) {
      print('❌ [QuranRadio] Error initializing audio service: $e');
      print('❌ [QuranRadio] Stack trace: $stackTrace');
      _audioHandler = null;
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ في تهيئة الراديو. يرجى التحقق من الأذونات\n$e', textAlign: TextAlign.center),
            backgroundColor: Colors.redAccent,
            duration: Duration(seconds: 5),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    // Don't dispose audio handler here - it continues in background
    super.dispose();
  }

  Future<void> _playPause() async {
    print('🎵 [QuranRadio] Play/Pause button pressed');
    print('🎵 [QuranRadio] Current handler state: ${_audioHandler != null ? "NOT NULL" : "NULL"}');
    print('🎵 [QuranRadio] Current playing state: $_isPlaying');
    
    if (_audioHandler == null) {
      // Audio service not initialized - show error and try to reinitialize
      print('❌ [QuranRadio] Audio handler is null! Attempting to reinitialize...');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('جاري تهيئة الراديو...', textAlign: TextAlign.center),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 2),
          ),
        );
      }
      
      await _initAudioService();
      
      if (_audioHandler == null) {
        print('❌ [QuranRadio] Reinitialization failed!');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('فشل تهيئة الراديو. يرجى إعادة فتح الشاشة', textAlign: TextAlign.center),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 3),
            ),
          );
        }
        return;
      }
      print('✅ [QuranRadio] Reinitialization successful!');
    }

    if (_isPlaying) {
      print('🎵 [QuranRadio] Stopping playback...');
      await _audioHandler!.stop();
      print('✅ [QuranRadio] Playback stopped');
    } else {
      print('🎵 [QuranRadio] Starting playback...');
      setState(() => _isLoading = true);
      try {
        final station = _stations[_selectedStationIndex];
        print('🎵 [QuranRadio] Selected station: ${station['name']}');
        print('🎵 [QuranRadio] URL: ${station['url']}');
        
        await _audioHandler!.playStation(
          station['url']!,
          station['name']!,
          station['reciter']!,
        );
        print('✅ [QuranRadio] Playback started successfully');
      } catch (e, stackTrace) {
        print('❌ [QuranRadio] Error playing station: $e');
        print('❌ [QuranRadio] Stack trace: $stackTrace');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('خطأ في الاتصال بالإذاعة', textAlign: TextAlign.center),
              backgroundColor: Colors.redAccent,
            ),
          );
          setState(() => _isLoading = false);
        }
      }
    }
  }

  Future<void> _changeStation(int index) async {
    if (_selectedStationIndex == index || _audioHandler == null) return;

    final wasPlaying = _isPlaying;
    await _audioHandler!.stop();

    setState(() {
      _selectedStationIndex = index;
    });

    if (wasPlaying) {
      await _playPause();
    }
  }

  Future<void> _changeVolume(double value) async {
    setState(() => _volume = value);
    await _audioHandler?.setVolume(value);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AppScaffold(
      title: 'إذاعة القرآن الكريم',
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            // Player Card
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF0B6623),
                    Color(0xFF1A8B3D),
                  ],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF0B6623).withOpacity(0.4),
                    blurRadius: 20,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Station Info
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Text(
                          _stations[_selectedStationIndex]['name']!,
                          style: GoogleFonts.cairo(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 8),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          decoration: BoxDecoration(
                            color: Color(0xFFF3D18A).withOpacity(0.9),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            _stations[_selectedStationIndex]['reciter']!,
                            style: GoogleFonts.cairo(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF0B6623),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 32),

                  // Animated Play Button
                  AnimatedBuilder(
                    animation: _pulseController,
                    builder: (context, child) {
                      return Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: _isPlaying
                              ? [
                                  BoxShadow(
                                    color: Colors.white.withOpacity(
                                        0.3 * _pulseController.value),
                                    blurRadius: 40,
                                    spreadRadius: 20 * _pulseController.value,
                                  ),
                                ]
                              : [],
                        ),
                        child: child,
                      );
                    },
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 15,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: _isLoading
                          ? Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFF0B6623),
                                strokeWidth: 3,
                              ),
                            )
                          : IconButton(
                              icon: Icon(
                                _isPlaying ? Icons.pause : Icons.play_arrow,
                                size: 50,
                                color: Color(0xFF0B6623),
                              ),
                              onPressed: _playPause,
                            ),
                    ),
                  ),
                  SizedBox(height: 32),

                  // Volume Control
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.volume_down, color: Colors.white),
                        Expanded(
                          child: Slider(
                            value: _volume,
                            min: 0.0,
                            max: 1.0,
                            activeColor: Colors.white,
                            inactiveColor: Colors.white.withOpacity(0.3),
                            onChanged: _changeVolume,
                          ),
                        ),
                        Icon(Icons.volume_up, color: Colors.white),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 32),

            // Station List
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'الإذاعات المتاحة',
                style: GoogleFonts.cairo(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
            SizedBox(height: 16),

            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 20),
              itemCount: _stations.length,
              itemBuilder: (context, index) {
                final isSelected = index == _selectedStationIndex;
                return Container(
                  margin: EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? theme.primaryColor.withOpacity(isDark ? 0.2 : 0.1)
                        : theme.cardColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected
                          ? theme.primaryColor
                          : theme.dividerColor.withOpacity(0.2),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ListTile(
                    onTap: () => _changeStation(index),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected
                            ? theme.primaryColor
                            : theme.primaryColor.withOpacity(isDark ? 0.25 : 0.1),
                      ),
                      child: Icon(
                        isSelected ? Icons.radio : Icons.radio_button_unchecked,
                        color: isSelected ? Colors.white : theme.primaryColor,
                      ),
                    ),
                    title: Text(
                      _stations[index]['name']!,
                      style: GoogleFonts.cairo(
                        fontSize: 16,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.w600,
                        color: isSelected
                            ? theme.primaryColor
                            : theme.colorScheme.onSurface,
                      ),
                    ),
                    subtitle: Text(
                      _stations[index]['reciter']!,
                      style: GoogleFonts.cairo(
                        fontSize: 13,
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                    trailing: isSelected && _isPlaying
                        ? Icon(
                            Icons.graphic_eq,
                            color: theme.primaryColor,
                          )
                        : null,
                  ),
                );
              },
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
