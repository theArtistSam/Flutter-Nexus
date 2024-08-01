import 'dart:ui';

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

  @override
  void initState() {
    guideBottomSheetBloc = GuideBottomSheetBloc(guide: widget.guide);
    guideBottomSheetBloc.add(StartTimer());
    super.initState();
  }

  @override
  void dispose() {
    guideBottomSheetBloc.close();
    super.dispose();
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
                  cornerRadius: 15,
                  cornerSmoothing: 0.8,
                ),
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Column(
              children: [
                Center(
                  child: Container(
                    width: 60,
                    height: 5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white.withOpacity(.3),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                BlocBuilder<GuideBottomSheetBloc, GuideBottomSheetState>(
                  builder: (context, state) {
                    final isPaused =
                        (state as GuideBottomSheetInitial).isPaused;
                    final bool isLiked = (state)
                        .guide!
                        .likedBy!
                        .contains('Bd4umkyLqOLnMpdOLZ0E');
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        AspectRatio(
                          aspectRatio: 9 / 16,
                          child: GestureDetector(
                            onTap: () {
                              guideBottomSheetBloc.add(
                                const TogglePauseResume(value: true),
                              );
                            },
                            child: Container(
                              color: NexusColors.accentColorDark,
                              child: Image.network(
                                widget.guide.link!,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
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
                                  },
                                ),
                              )
                            : const SizedBox(),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
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
                                    children: [
                                      StyledText(
                                        text: widget.guide.title!,
                                        color: Colors.white,
                                      ),
                                      const Spacer(),
                                      StyledIconButton(
                                        icon:
                                            isLiked ? 'heart-filled' : 'heart',
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
                        )
                      ],
                    );
                  },
                ),
                BlocBuilder<GuideBottomSheetBloc, GuideBottomSheetState>(
                  builder: (context, state) {
                    final sliderValue =
                        (state as GuideBottomSheetInitial).sliderValue;

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
                          child: Slider(
                            activeColor: Colors.white,
                            inactiveColor: Colors.white.withOpacity(.50),
                            min: 0,
                            max: 15,
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
                SizedBox(height: bottomPadding),
              ],
            ),
          ),
        )
      ]),
    );
  }

  Widget guideLine() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.5),
      child: Container(
        height: 5,
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: SmoothRectangleBorder(
            borderRadius: SmoothBorderRadius(
              cornerRadius: 40,
              // cornerSmoothing: .8,
            ),
          ),
        ),
      ),
    );
  }
}
