import 'dart:async';
import 'dart:io';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:nexus/utils/constants.dart';
import 'package:nexus/widgets/styled_widgets/styled_icon_button.dart';
import 'package:nexus/widgets/styled_widgets/styled_text.dart';
import 'package:path_provider/path_provider.dart';

class AudioBottomSheet extends StatefulWidget {
  const AudioBottomSheet({super.key});

  @override
  State<AudioBottomSheet> createState() => _AudioBottomSheetState();
}

class _AudioBottomSheetState extends State<AudioBottomSheet> {
  late PlayerController _playerController;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;
  StreamSubscription<int>? _currentDurationSubscription;

  @override
  void initState() {
    super.initState();

    // Initialize PlayerController
    _playerController = PlayerController();

    //  Load audio from URL
    _loadAudioFromUrl();
  }

  @override
  void dispose() {
    _playerController.dispose();
    super.dispose();
  }

  Future<void> _loadAudioFromUrl() async {
    try {
      String audioUrl =
          'https://firebasestorage.googleapis.com/v0/b/nexus-ef4c1.appspot.com/o/guides%2FUNs6mWLneQQNMXLuGiX7%2Fsample-audio.mp3?alt=media&token=d05241f3-226a-46fa-a1d0-ccfd9ddc1a7e';
      // Fetch the audio file from the URL
      http.Response response = await http.get(Uri.parse(audioUrl));

      if (response.statusCode == 200) {
        // Get the app's temporary directory
        Directory tempDir = await getTemporaryDirectory();

        // Create a new file in the temporary directory
        File tempFile = File('${tempDir.path}/audio_from_url.mp3');

        // Write the audio file data to the temporary file
        await tempFile.writeAsBytes(response.bodyBytes, flush: true);

        // Prepare the player with the path to the local temp file
        await _playerController.preparePlayer(
          path: tempFile.path, // Path to the locally stored audio file
          shouldExtractWaveform: true, // Extract waveform data
          noOfSamples: 100, // Number of waveform samples to extract
          volume: 1.0, // Set the playback volume
        );

        // Start playing the audio
        _playerController.startPlayer(finishMode: FinishMode.stop);

        // Get total duration of the audio
        final duration = await _playerController.getDuration(DurationType.max);
        _totalDuration = Duration(milliseconds: duration ?? 0);

        // Listen to current duration changes
        _currentDurationSubscription =
            _playerController.onCurrentDurationChanged.listen((milliseconds) {
          setState(() {
            _currentPosition = Duration(milliseconds: milliseconds);
          });
        });
      } else {
        print("Failed to download the audio file: ${response.statusCode}");
      }
    } catch (e) {
      print("Error loading audio from URL: $e");
    }
  }

  Future<void> _loadAudioFromAssets() async {
    try {
      // Load the audio file from assets
      final ByteData data =
          await rootBundle.load('assets/audio/sample-audio.mp3');

      // Get the temporary directory to save the audio file
      final Directory tempDir = await getTemporaryDirectory();
      final File tempFile = File('${tempDir.path}/sample-audio.mp3');

      // Write the asset's byte data to a file
      await tempFile.writeAsBytes(data.buffer.asUint8List(), flush: true);

      // Prepare the player to stream the audio file from the local temp file and generate waveform
      await _playerController.preparePlayer(
        path: tempFile.path, // Path to the temp file
        shouldExtractWaveform: true, // Extract waveform data for visualization
        noOfSamples: 100,
        volume: 1.0,
      );

      _playerController.startPlayer();
    } catch (e) {
      print("Error loading audio from assets: $e");
    }
  }

  String _videoDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return [
      if (duration.inHours > 0) hours,
      minutes,
      seconds,
    ].join(':');
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Wrap(
      children: [
        ClipSmoothRect(
          radius: SmoothBorderRadius(
            cornerRadius: 25,
            cornerSmoothing: .8,
          ),
          child: Container(
            width: double.infinity,
            height: height - 50,
            color: Colors.black,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Handle
                  Container(
                    width: 60,
                    height: 5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Container(
                          color: NexusColors.accentColorDark,
                          child: AudioFileWaveforms(
                            size:
                                Size(MediaQuery.of(context).size.width, 100.0),
                            playerController: _playerController,
                            enableSeekGesture: true,
                            waveformType: WaveformType.long,
                            //  waveformData: [],
                            playerWaveStyle: const PlayerWaveStyle(
                              fixedWaveColor: Colors.white54,
                              liveWaveColor: Colors.blueAccent,
                              spacing: 6,
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: StyledIconButton(
                          icon: 'play',
                          onTap: () {
                            setState(() {
                              _playerController.pausePlayer();
                            });
                          },
                          backgroundColor: Colors.black54,
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            StyledText(
                              text: _formatDuration(
                                  _currentPosition), // Format current position
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                            const Spacer(),
                            StyledText(
                              text: _formatDuration(
                                  _totalDuration), // Format total duration
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
