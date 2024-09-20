import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nexus/utils/constants.dart';
import 'package:nexus/widgets/styled_widgets/styled_icon_button.dart';
import 'package:nexus/widgets/styled_widgets/styled_text.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:video_player/video_player.dart';

class VideoBottomSheet extends StatefulWidget {
  const VideoBottomSheet({super.key});

  @override
  State<VideoBottomSheet> createState() => _VideoBottomSheetState();
}

class _VideoBottomSheetState extends State<VideoBottomSheet> {
  late VideoPlayerController _controller;
  @override
  void initState() {
    _initVideoPlayerController(
      link:
          'https://firebasestorage.googleapis.com/v0/b/nexus-ef4c1.appspot.com/o/guides%2FUNs6mWLneQQNMXLuGiX7%2Fvideo.mp4?alt=media&token=5961a384-60be-4f67-b6dc-4fd51aa10606',
    );

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _initVideoPlayerController({required String link}) async {
    _controller = VideoPlayerController.networkUrl(Uri.parse(link));
    await _controller.initialize(); // Ensure controller is initialized
    setState(() {
      _controller.play();
    });
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
                      _controller.value.isInitialized
                          ? AspectRatio(
                              aspectRatio: _controller.value.aspectRatio,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (_controller.value.isPlaying) {
                                      _controller.pause();
                                    }
                                  });
                                },
                                child: VideoPlayer(_controller),
                              ),
                            )
                          : AspectRatio(
                              aspectRatio: 16 / 9,
                              child: Container(
                                color: NexusColors.accentColorDark,
                              ),
                            ),
                      !_controller.value.isPlaying
                          ? Center(
                              child: StyledIconButton(
                                icon: 'play',
                                onTap: () {
                                  setState(() {
                                    _controller.play();
                                  });
                                },
                                backgroundColor: Colors.black54,
                              ),
                            )
                          : const SizedBox(),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: SizedBox(
                            height: 5,
                            child: VideoProgressIndicator(
                              _controller,
                              padding: EdgeInsets.zero,
                              allowScrubbing: true,
                              colors: const VideoProgressColors(
                                playedColor: Colors.white,
                                bufferedColor: Colors.white24,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        ValueListenableBuilder(
                          valueListenable: _controller,
                          builder: (context, VideoPlayerValue value, child) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                StyledText(
                                  text: _videoDuration(value.position),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                                // const Spacer(),
                                StyledText(
                                  text: _videoDuration(
                                      _controller.value.duration),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ],
                            );
                          },
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
