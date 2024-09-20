import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus/blocs/guide_bottom_sheet_bloc/bloc/guide_bottom_sheet_bloc.dart';
import 'package:nexus/models/guide_model.dart';
import 'package:nexus/utils/constants.dart';
import 'package:nexus/widgets/styled_widgets/styled_icon_button.dart';
import 'package:nexus/widgets/styled_widgets/styled_text.dart';
import 'package:video_player/video_player.dart';

class GuideBottomSheet extends StatefulWidget {
  const GuideBottomSheet({
    super.key,
    required this.guide,
  });
  final GuideModel guide;
  @override
  State<GuideBottomSheet> createState() => _GuideBottomSheetState();
}

class _GuideBottomSheetState extends State<GuideBottomSheet> {
  late GuideBottomSheetBloc guideBottomSheetBloc;
  late VideoPlayerController? videoPlayerController;

  @override
  void initState() {
    guideBottomSheetBloc = GuideBottomSheetBloc(guide: widget.guide);

    if (widget.guide.type == 'video') {
      _initVideoPlayerController(link: widget.guide.link!);
    } else {
      // When the type is Image
      videoPlayerController = null;
      guideBottomSheetBloc.add(const StartTimer());
    }

    super.initState();
  }

  @override
  void dispose() {
    guideBottomSheetBloc.close();
    videoPlayerController?.dispose();
    super.dispose();
  }

  Future<void> _initVideoPlayerController({required String link}) async {
    videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(link));
    // Ensure controller is initialized
    await videoPlayerController!.initialize();
    videoPlayerController!.play();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return BlocProvider(
      create: (context) => guideBottomSheetBloc,
      child: Wrap(children: [
        Container(
          height: height - 50,
          decoration: const ShapeDecoration(
            color: Colors.black,
            shape: SmoothRectangleBorder(
              borderRadius: SmoothBorderRadius.all(
                SmoothRadius(
                  cornerRadius: 25,
                  cornerSmoothing: 0.8,
                ),
              ),
            ),
          ),
          child: BlocBuilder<GuideBottomSheetBloc, GuideBottomSheetState>(
            builder: (context, state) {
              final isPaused = (state as GuideBottomSheetInitial).isPaused;
              final isLiked = state.isLiked;

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Column(
                  children: [
                    Container(
                      width: 60,
                      height: 5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Image
                          GestureDetector(
                            onTap: () {
                              guideBottomSheetBloc.add(
                                const TogglePauseResume(
                                  value: true,
                                ),
                              );
                              if (videoPlayerController != null) {
                                videoPlayerController!.pause();
                              }
                            },
                            child: AspectRatio(
                              aspectRatio: 9 / 16,
                              child: _getContentTile(
                                isVideo: widget.guide.type == 'video',
                              ),
                            ),
                          ),
                          isPaused
                              ? Center(
                                  child: StyledIconButton(
                                    icon: 'play',
                                    backgroundColor:
                                        Colors.black.withOpacity(.5),
                                    onTap: () {
                                      guideBottomSheetBloc.add(
                                        const TogglePauseResume(value: false),
                                      );
                                      if (videoPlayerController
                                              ?.value.isInitialized ??
                                          false) {
                                        videoPlayerController!.play();
                                      }
                                    },
                                  ),
                                )
                              : const SizedBox(),
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: Container(
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Color.fromRGBO(0, 0, 0, 0),
                                    Color.fromRGBO(0, 0, 0, .85),
                                  ],
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 20,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        StyledText(
                                          text: widget.guide.title!,
                                          color: Colors.white,
                                          fontSize: 18,
                                        ),
                                        StyledIconButton(
                                          icon: isLiked
                                              ? 'heart-filled'
                                              : 'heart',
                                          onTap: () {
                                            String guideId =
                                                widget.guide.guideId!;
                                            if (isLiked) {
                                              guideBottomSheetBloc.add(
                                                DislikeGuide(guideId: guideId),
                                              );
                                            } else {
                                              guideBottomSheetBloc.add(
                                                LikeGuide(guideId: guideId),
                                              );
                                            }
                                          },
                                          iconColor: Colors.white,
                                          backgroundColor: Colors.transparent,
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ), // * Fix This
                                    StyledText(
                                      text: widget.guide.description!,
                                      color: Colors.white.withOpacity(.5),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    _getSlider(isVideo: widget.guide.type == 'video'),
                    SizedBox(
                      height: bottomPadding + 5,
                    ),
                  ],
                ),
              );
            },
          ),
        )
      ]),
    );
  }

  Widget _getContentTile({required bool isVideo}) {
    if (isVideo) {
      // If controller is initialized -> then display video
      if (videoPlayerController != null &&
          videoPlayerController!.value.isInitialized) {
        return VideoPlayer(videoPlayerController!);
      }
      // else display circular progress indicator
      return const Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      );
    }
    return Container(
      color: NexusColors.accentColorDark,
      child: CachedNetworkImage(
        imageUrl: widget.guide.link!,
        width: double.infinity,
        fit: BoxFit.cover,
        progressIndicatorBuilder: (context, url, progress) => Center(
          child: CircularProgressIndicator(
            value: progress.progress,
          ),
        ),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ),
    );
  }

  Widget _getSlider({required bool isVideo}) {
    if (isVideo) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: SizedBox(
            height: 5,
            child: VideoProgressIndicator(
              videoPlayerController!,
              padding: EdgeInsets.zero,
              allowScrubbing: true,
              colors: const VideoProgressColors(
                playedColor: Colors.white,
                bufferedColor: Colors.white24,
              ),
            ),
          ),
        ),
      );
    }
    return BlocBuilder<GuideBottomSheetBloc, GuideBottomSheetState>(
      builder: (context, state) {
        final sliderValue = (state as GuideBottomSheetInitial).sliderValue;
        final duration = (state).duration;
        return TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0, end: sliderValue),
          duration: const Duration(seconds: 1),
          builder: (context, value, child) {
            return SliderTheme(
              data: SliderTheme.of(context).copyWith(
                thumbShape: const RoundSliderThumbShape(
                  enabledThumbRadius: 0.0,
                ),
                overlayShape: const RoundSliderOverlayShape(
                  overlayRadius: 0.0,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                ),
                child: Slider(
                  activeColor: Colors.white,
                  inactiveColor: Colors.white.withOpacity(.50),
                  min: 0,
                  max: widget.guide.type == 'image'
                      ? 15
                      : duration.ceilToDouble(),
                  value: value,
                  onChanged: (newValue) {
                    // * Do not allow user the change slider value.
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}
