import 'dart:async';
import 'dart:io';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:nexus/blocs/audio_bottom_sheet_bloc/bloc/audio_bottom_sheet_bloc.dart';
import 'package:nexus/utils/constants.dart';
import 'package:nexus/widgets/styled_widgets/styled_icon_button.dart';
import 'package:nexus/widgets/styled_widgets/styled_text.dart';
import 'package:path_provider/path_provider.dart';

class AudioBottomSheet extends StatefulWidget {
  const AudioBottomSheet({
    super.key,
    required this.url,
  });

  final String url;
  @override
  State<AudioBottomSheet> createState() => _AudioBottomSheetState();
}

class _AudioBottomSheetState extends State<AudioBottomSheet> {
  late PlayerController _playerController;
  Duration _totalDuration = Duration.zero;
  StreamSubscription<int>? _currentDurationSubscription;
  late AudioBottomSheetBloc audioBottomSheetBloc;

  @override
  void initState() {
    super.initState();

    audioBottomSheetBloc = AudioBottomSheetBloc();

    // Initialize PlayerController
    _playerController = PlayerController();

    //  Load audio from URL
    _loadAudioFromUrl(url: widget.url);

    // Listen to current duration changes
    _currentDurationSubscription =
        _playerController.onCurrentDurationChanged.listen((milliseconds) {
      audioBottomSheetBloc.add(
        UpdateCurrentPosition(
          currentPosition: Duration(milliseconds: milliseconds),
        ),
      );
    });
  }

  @override
  void dispose() {
    audioBottomSheetBloc.close();
    _playerController.dispose();
    super.dispose();
  }

  Future<void> _loadAudioFromUrl({required String url}) async {
    try {
      // Fetch the audio file from the URL
      http.Response response = await http.get(Uri.parse(url));

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
        final int duration =
            await _playerController.getDuration(DurationType.max);
        _totalDuration = Duration(milliseconds: duration);
      } else {
        print("Failed to download the audio file: ${response.statusCode}");
      }
    } catch (e) {
      print("Error loading audio from URL: $e");
    }
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return BlocProvider(
      create: (context) => audioBottomSheetBloc,
      child: Wrap(
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
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Container(
                        color: NexusColors.accentColorDark,
                        child: AudioFileWaveforms(
                          size: Size(
                            MediaQuery.of(context).size.width,
                            100.0,
                          ),
                          playerController: _playerController,
                          enableSeekGesture: true,
                          waveformType: WaveformType.long,
                          //  waveformData: [],
                          playerWaveStyle: const PlayerWaveStyle(
                            fixedWaveColor: Colors.white24,
                            liveWaveColor: Colors.white,
                            spacing: 6,
                          ),
                        ),
                      ),
                    ),
                    BlocBuilder<AudioBottomSheetBloc, AudioBottomSheetState>(
                      builder: (context, state) {
                        final currentState = state as AudioBottomSheetInitial;
                        final Duration currentPosition =
                            currentState.currentPosition;
                        final isPlaying = currentState.isPlaying;
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  StyledText(
                                    text: _formatDuration(
                                        currentPosition), // Format current position
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                  const Spacer(),
                                  Center(
                                    child: StyledIconButton(
                                      icon: isPlaying ? 'pause' : 'play',
                                      onTap: () {
                                        if (isPlaying) {
                                          _playerController.pausePlayer();
                                          audioBottomSheetBloc
                                              .add(PauseAudio());
                                        } else {
                                          _playerController.startPlayer();
                                          audioBottomSheetBloc.add(PlayAudio());
                                        }
                                      },
                                      backgroundColor:
                                          NexusColors.accentColorDark,
                                    ),
                                  ),
                                  const Spacer(),
                                  StyledText(
                                    text: _formatDuration(
                                      _totalDuration,
                                    ), // Format total duration
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ],
                              )
                            ],
                          ),
                        );
                      },
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
