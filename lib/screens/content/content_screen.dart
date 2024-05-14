import 'package:audioplayers/audioplayers.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nexus/blocs/content_screen_bloc/bloc/content_screen_bloc.dart';
import 'package:nexus/screens/content/widgets/content_configure_tabs.dart';
import 'package:nexus/screens/content/widgets/edit_bottom_sheet.dart';
import 'package:nexus/utils/constants.dart';
import 'package:nexus/widgets/content_tile.dart';
import 'package:nexus/widgets/styled_button.dart';
import 'package:nexus/widgets/styled_icon_button.dart';
import 'package:nexus/widgets/styled_tabs.dart';
import 'package:nexus/widgets/styled_text.dart';
import 'package:nexus/widgets/styled_textfield.dart';

// ignore: must_be_immutable
class ContentScreen extends StatefulWidget {
  ContentScreen(
      {super.key,
      required this.image,
      required this.title,
      this.folder,
      this.summary,
      this.translation});

  String image;
  String title;
  String? summary;
  String? translation;
  String? folder;

  @override
  State<ContentScreen> createState() => _ContentScreenState();
}

class _ContentScreenState extends State<ContentScreen> {
  String dropdownValue = "School Work";
  bool isOriginalDisplayed = false;
  late ContentScreenBloc contentScreenBloc;

  late AudioPlayer player;
  bool isPlaying = false;
  Duration position = Duration.zero;
  Duration duration = Duration.zero;

  @override
  void initState() {
    contentScreenBloc = ContentScreenBloc();
    // Create the audio player.
    player = AudioPlayer();

    // Set the release mode to keep the source after playback has completed.
    player.setReleaseMode(ReleaseMode.stop);

    // Start the player as soon as the app is displayed.
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await player.setSource(AssetSource('audio/sample-audio.mp3'));
    });

    // Listen to states of audio player
    player.onPlayerStateChanged.listen((state) {
      isPlaying = state == PlayerState.playing;
    });

    // Listen to duration and position changes
    player.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
    });

    player.onPositionChanged.listen((newPosition) {
      setState(() {
        position = newPosition;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    contentScreenBloc.close();
    player.dispose();
    super.dispose();
  }

  void toggleView(bool isLeftSelected) {
    contentScreenBloc.add(ToggleView(isLeftSelected: isLeftSelected));
  }

  final tags = ['sfs fsf', 'sfsdfdfsf', 'dsfs', 'sfsdf', 'sdf42142 sdf'];

  @override
  Widget build(BuildContext context) {
    final appbarHeight = MediaQuery.of(context).padding.top;
    final screenHeight = MediaQuery.of(context).size.height;

    return BlocProvider(
      create: (context) => contentScreenBloc,
      child: Scaffold(
        backgroundColor: NexusColors.accentColorLight,
        body: SizedBox(
          child: Stack(
            children: [
              Image.asset(
                'assets/images/${widget.image}.png',
                fit: BoxFit.cover,
                width: double.infinity,
                // height: double.infinity,
                height: 410,
              ),
              Positioned(
                child: Container(
                  height: 410,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(.3), // Start color (0% black)
                        Colors.black.withOpacity(0.5), // End color (90% black)
                      ],
                    ),
                    // borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              // Appbar
              SizedBox(
                height: 410,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 60),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: appbarHeight,
                      ),
                      Row(
                        children: [
                          StyledIconButton(
                            icon: 'back-arrow',
                            onTap: () => Navigator.pop(context),
                            backgroundColor: Colors.black26,
                            padding: 15,
                          ),
                          const Spacer(),
                          StyledIconButton(
                            icon: 'pencil-filled',
                            onTap: () => {
                              showModalBottomSheet(
                                  isScrollControlled: true,
                                  context: context,
                                  builder: (context) =>
                                      const EditBottomSheet() // Add actual content
                                  )
                            },
                            padding: 11.5,
                            backgroundColor: Colors.black26,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          StyledIconButton(
                            icon: 'setting-filled',
                            onTap: () => {
                              showModalBottomSheet(
                                  isScrollControlled: true,
                                  context: context,
                                  builder: (context) =>
                                      contentConfigureBottomSheet() // Add actual content
                                  )
                            },
                            backgroundColor: Colors.black26,
                          )
                        ],
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () async {
                          isPlaying
                              ? await player.pause()
                              : await player.resume();

                          setState(() {
                            isPlaying = !isPlaying;
                          });
                        },
                        child: Center(
                          child: SvgPicture.asset(
                            isPlaying
                                ? 'assets/icons/pause.svg'
                                : 'assets/icons/play.svg',
                            height: 45,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const Spacer(),
                      // contentTyle: isAudio
                      Container(
                        decoration: ShapeDecoration(
                            color: Colors.black26,
                            shape: SmoothRectangleBorder(
                                borderRadius: SmoothBorderRadius(
                                    cornerRadius: 15, cornerSmoothing: .8))),
                        child: Padding(
                          padding: const EdgeInsets.all(2),
                          child: Slider(
                            thumbColor: Colors.white,
                            activeColor: Colors.white,
                            inactiveColor: Colors.white54,
                            min: 0,
                            max: duration.inSeconds.toDouble(),
                            value: position.inSeconds.toDouble(),
                            onChanged: (value) async {
                              final newPosition =
                                  Duration(seconds: value.toInt());
                              await player.seek(newPosition);
                              // Resume playback if necessary
                            },
                          ),
                        ),
                      ),

                      // contentType: isImage
                      // contentIconButton('View complete image', 'maximize', () {}),

                      // contentType: isDocument
                      // contentIconButton(
                      //     'View complete document', 'sticky-note', () {}),

                      const SizedBox(
                        height: 10,
                      ),
                      StyledText(
                        text: widget.title,
                        color: NexusColors.textColorLight,
                        fontSize: 18,
                      )
                    ],
                  ),
                ),
              ),
              DraggableScrollableSheet(
                  initialChildSize: (screenHeight - 410 + 40) / screenHeight,
                  minChildSize: (screenHeight - 410 + 40) / screenHeight,
                  maxChildSize: .95,
                  builder: (context, controller) =>
                      contentBottomSheet(controller))
            ],
          ),
        ),
      ),
    );
  }

  contentIconButton(title, icon, onTap) => Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: SmoothBorderRadius(cornerRadius: 15),
          onTap: onTap,
          child: Ink(
              decoration: ShapeDecoration(
                  color: Colors.black26,
                  shape: SmoothRectangleBorder(
                      borderRadius: SmoothBorderRadius(
                          cornerRadius: 15, cornerSmoothing: .8))),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  children: [
                    StyledText(
                      text: title,
                      color: NexusColors.textColorLight,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                    const Spacer(),
                    SvgPicture.asset(
                      'assets/icons/$icon.svg',
                      color: Colors.white,
                    )
                  ],
                ),
              )),
        ),
      );

  contentTile(
          {isOpen,
          openTitle,
          closeTitle,
          text,
          onTap,
          isTranslation = false}) =>
      Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius:
              SmoothBorderRadius(cornerRadius: 15, cornerSmoothing: .8),
          onTap: onTap,
          child: Ink(
            decoration: ShapeDecoration(
                color: NexusColors.accentColorLight,
                shape: SmoothRectangleBorder(
                    borderRadius: SmoothBorderRadius(
                        cornerRadius: 15, cornerSmoothing: 0.8))),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: isTranslation
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      StyledText(
                        fontSize: 14,
                        text: isOpen ? openTitle : closeTitle,
                        color: NexusColors.primaryColorLight,
                      ),
                      const Spacer(),
                      !isOpen
                          ? SvgPicture.asset(
                              'assets/icons/small-arrow-down.svg',
                              color: NexusColors.primaryColorLight,
                            )
                          : const SizedBox()
                    ],
                  ),
                  SizedBox(height: isOpen ? 10 : 0),
                  isOpen
                      ? isTranslation
                          ? Text(
                              text,
                              style: GoogleFonts.notoNastaliqUrdu(
                                color: NexusColors.primaryColorLight,
                                height: 2,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.right,
                            )
                          : StyledText(
                              fontSize: 18,
                              text: text,
                              fontWeight: FontWeight.w500,
                            )
                      : const SizedBox(),
                ],
              ),
            ),
          ),
        ),
      );

  contentBottomSheet(controller) => Container(
        decoration: const ShapeDecoration(
            color: Colors.white,
            shape: SmoothRectangleBorder(
                borderRadius: SmoothBorderRadius.only(
                    topLeft:
                        SmoothRadius(cornerRadius: 25, cornerSmoothing: .8),
                    topRight:
                        SmoothRadius(cornerRadius: 25, cornerSmoothing: .8)))),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
          child: Stack(
            children: [
              ListView(
                key: UniqueKey(),
                padding: const EdgeInsets.fromLTRB(0, 105, 0, 0),
                controller: controller,
                children: [
                  BlocBuilder<ContentScreenBloc, ContentScreenState>(
                    builder: (context, state) {
                      if (state is ContentScreenInitial) {
                        bool isLeftSelected = state.isLeftSelected;
                        return Column(
                          children: [
                            contentTile(
                                onTap: () {
                                  contentScreenBloc.add(
                                      ToggleContainerView(isOriginal: true));
                                },
                                isOpen: state.isOriginal ? true : false,
                                openTitle: 'Original',
                                closeTitle: 'View original text',
                                text: 'This is the original text'),
                            const SizedBox(
                              height: 10,
                            ),
                            // This one can help with both translation and summarization
                            contentTile(
                                onTap: () {
                                  contentScreenBloc.add(
                                      ToggleContainerView(isOriginal: false));
                                },
                                isTranslation: isLeftSelected,
                                isOpen: state.isOriginal ? false : true,
                                openTitle:
                                    isLeftSelected ? 'Translation' : 'Summary',
                                closeTitle: isLeftSelected
                                    ? 'View Translation'
                                    : 'View summary',
                                text: isLeftSelected
                                    ? widget.translation ??
                                        'کوئی ترجمہ دستیاب نہیں ہے۔'
                                    : widget.summary ?? 'No Summary available'),

                            const SizedBox(height: 10),
                            Row(
                              children: [
                                StyledIconButton(
                                  icon: 'rotate-left',
                                  onTap: () {},
                                  backgroundColor: NexusColors.accentColorLight,
                                  iconColor: NexusColors.primaryColorLight,
                                ),
                                const SizedBox(width: 5),
                                StyledIconButton(
                                  icon: 'arrow-down',
                                  onTap: () {},
                                  backgroundColor: NexusColors.accentColorLight,
                                  iconColor: NexusColors.primaryColorLight,
                                ),
                                const SizedBox(width: 5),
                                StyledIconButton(
                                  icon: 'share',
                                  onTap: () {},
                                  backgroundColor: NexusColors.accentColorLight,
                                  iconColor: NexusColors.primaryColorLight,
                                ),
                                const SizedBox(width: 5),
                                StyledIconButton(
                                  icon: 'pencil',
                                  onTap: () {},
                                  backgroundColor: NexusColors.accentColorLight,
                                  iconColor: NexusColors.primaryColorLight,
                                ),
                                const Spacer(),
                                StyledIconButton(
                                  icon: state.isLiked ? 'like-filled' : 'like',
                                  onTap: () {
                                    contentScreenBloc
                                        .add(ToggleLikeDislike(isLiked: true));
                                  },
                                  backgroundColor: NexusColors.accentColorLight,
                                  iconColor: NexusColors.primaryColorLight,
                                ),
                                const SizedBox(width: 5),
                                StyledIconButton(
                                  icon: state.isLiked
                                      ? 'dislike'
                                      : 'dislike-filled',
                                  onTap: () {
                                    contentScreenBloc
                                        .add(ToggleLikeDislike(isLiked: false));
                                  },
                                  backgroundColor: NexusColors.accentColorLight,
                                  iconColor: NexusColors.primaryColorLight,
                                ),
                              ],
                            ),
                            const SizedBox(height: 30),
                          ],
                        );
                      }
                      return const SizedBox();
                    },
                  )
                ],
              ),
              // been put at the end to act as a sticky header
              Container(
                height: 105,
                color: Colors.white,
                child: Column(
                  children: [
                    Center(
                      child: Container(
                        width: 60,
                        height: 5,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: NexusColors.borderColor),
                      ),
                    ),
                    const SizedBox(height: 15),
                    StyledTabs(
                      leftTabText: 'Translate',
                      rightTabText: 'Summarize',
                      changeState: toggleView,
                      // isLeftSelected: false
                    ),
                    const Divider(
                      height: 30,
                      color: NexusColors.dividerColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  contentConfigureBottomSheet() => Wrap(
        children: [
          Container(
            decoration: const ShapeDecoration(
              color: Colors.white,
              shape: SmoothRectangleBorder(
                borderRadius: SmoothBorderRadius.only(
                    topLeft:
                        SmoothRadius(cornerRadius: 20, cornerSmoothing: 0.8),
                    topRight:
                        SmoothRadius(cornerRadius: 20, cornerSmoothing: 0.8)),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 60,
                        height: 5,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: NexusColors.borderColor),
                      ),
                    ),
                    const SizedBox(height: 15),
                    DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        borderRadius: SmoothBorderRadius(
                            cornerRadius: 15, cornerSmoothing: .8),
                        icon: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: SvgPicture.asset(
                            'assets/icons/small-arrow-down.svg',
                            color: Colors.black,
                          ),
                        ),
                        // value: dropdownValue,
                        hint: StyledText(text: 'Summarization Length'),
                        items: <String>['Standard Length', 'Custom Length']
                            .map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: StyledText(
                              text: value,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          // setState(() {
                          //   dropdownValue = newValue!;
                          // });
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ContentConfigureTabs(
                      tabsText: const ['Short', 'Medium', 'Long'],
                      // index: 1,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    StyledText(text: 'Summarization Style'),
                    const SizedBox(
                      height: 10,
                    ),
                    ContentConfigureTabs(
                      tabsText: const ['Creative', 'Balanaced', 'Precise'],
                      // index: 1
                    ),
                    const Divider(
                      height: 50,
                      color: NexusColors.dividerColor,
                    ),
                    StyledButton(text: 'Confirm changes', onTap: () {}),
                    const SizedBox(height: 20),
                  ]),
            ),
          )
        ],
      );
}
