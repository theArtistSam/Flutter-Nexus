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
    await videoPlayerController!
        .initialize(); // Ensure controller is initialized
    final duration =
        videoPlayerController!.value.duration.inMilliseconds / 1000.0;
    videoPlayerController!.play();
    guideBottomSheetBloc.add(StartTimer(endTime: duration));
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
              final bool isLiked =
                  (state).guide.likedBy!.contains('Bd4umkyLqOLnMpdOLZ0E');
              return Stack(
                // alignment: Alignment.center,
                children: [
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
                      child: widget.guide.type == 'video'
                          ? (videoPlayerController != null &&
                                  videoPlayerController!.value.isInitialized
                              ? ClipRRect(
                                  borderRadius: const SmoothBorderRadius.all(
                                    SmoothRadius(
                                      cornerRadius: 20,
                                      cornerSmoothing: .8,
                                    ),
                                  ),
                                  child: VideoPlayer(videoPlayerController!),
                                )
                              : const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                ))
                          : ClipRRect(
                              borderRadius: const SmoothBorderRadius.all(
                                SmoothRadius(
                                  cornerRadius: 20,
                                  cornerSmoothing: .8,
                                ),
                              ),
                              child: Container(
                                color: NexusColors.accentColorDark,
                                child: CachedNetworkImage(
                                  imageUrl: widget.guide.link!,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  progressIndicatorBuilder:
                                      (context, url, progress) => Center(
                                    child: CircularProgressIndicator(
                                      value: progress.progress,
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                            ),
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 30,
                        decoration: const BoxDecoration(
                          borderRadius: SmoothBorderRadius.only(
                            topLeft: SmoothRadius(
                              cornerRadius: 20,
                              cornerSmoothing: .8,
                            ),
                            topRight: SmoothRadius(
                              cornerRadius: 20,
                              cornerSmoothing: .8,
                            ),
                          ),
                          // color: Colors.black,
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color.fromRGBO(0, 0, 0, .5),
                              Color.fromRGBO(0, 0, 0, 0),
                            ],
                          ),
                        ),
                        child: Center(
                          child: Container(
                            width: 60,
                            height: 5,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      isPaused
                          ? Center(
                              child: StyledIconButton(
                                icon: 'play',
                                height: 30,
                                backgroundColor: Colors.black.withOpacity(.5),
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
                      const Spacer(),
                      Container(
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
                                children: [
                                  StyledText(
                                    text: widget.guide.title!,
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                  const Spacer(),
                                  StyledIconButton(
                                    icon: isLiked ? 'heart-filled' : 'heart',
                                    onTap: () {
                                      String guideId = widget.guide.guideId!;
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
                              SizedBox(
                                height: 40,
                                child: StyledText(
                                  text: widget.guide.description!,
                                  color: Colors.white.withOpacity(.5),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              BlocBuilder<GuideBottomSheetBloc,
                                  GuideBottomSheetState>(
                                builder: (context, state) {
                                  final sliderValue =
                                      (state as GuideBottomSheetInitial)
                                          .sliderValue;
                                  final duration = (state).duration;

                                  return TweenAnimationBuilder<double>(
                                    tween: Tween<double>(
                                        begin: 0, end: sliderValue),
                                    duration: const Duration(seconds: 1),
                                    builder: (context, value, child) {
                                      return SliderTheme(
                                        data: SliderTheme.of(context).copyWith(
                                          thumbShape:
                                              const RoundSliderThumbShape(
                                            enabledThumbRadius: 0.0,
                                          ),
                                          overlayShape:
                                              const RoundSliderOverlayShape(
                                            overlayRadius: 0.0,
                                          ),
                                        ),
                                        child: Slider(
                                          activeColor: Colors.white,
                                          inactiveColor:
                                              Colors.white.withOpacity(.50),
                                          min: 0,
                                          max: widget.guide.type == 'image'
                                              ? 15
                                              : duration.ceilToDouble(),
                                          value: value,
                                          onChanged: (newValue) {
                                            // * Do not allow user the change slider value.
                                          },
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                              SizedBox(
                                height: bottomPadding + 5,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        )
      ]),
    );
  }
}
