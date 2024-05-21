// ignore: file_names
// ignore_for_file: deprecated_member_use

import 'package:carousel_slider/carousel_slider.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:nexus/blocs/home_screen_bloc/bloc/home_screen_bloc.dart';
import 'package:nexus/models/content_model.dart';
import 'package:nexus/screens/content/content_screen.dart';
import 'package:nexus/screens/home/widgets/content_upload_tile.dart';
import 'package:nexus/utils/enums.dart';
import 'package:nexus/widgets/content_tile.dart';
import 'package:nexus/screens/home/widgets/guide_tile.dart';
import 'package:nexus/utils/constants.dart';
import 'package:nexus/widgets/styled_text.dart';
import 'package:nexus/widgets/styled_button.dart';
import 'package:nexus/widgets/styled_icon_button.dart';
import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:nexus/widgets/styled_icon_tile.dart';
import 'package:nexus/widgets/styled_tabs.dart';

class HomeScreen extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  const HomeScreen({Key? key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // late HomeScreenBloc homeScreenBloc;
  @override
  void initState() {
    context.read<HomeScreenBloc>().add(LoadContent());
    // homeScreenBloc.add(LoadContent());
    super.initState();
  }

  @override
  void dispose() {
    // homeScreenBloc.close();
    super.dispose();
  }

  // ThemeMode _themeMode = ThemeMode.system;

  // void _toggleTheme(ThemeMode themeMode) {
  //   setState(() {
  //     _themeMode = themeMode;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    // final screenHeight = MediaQuery.of(context).size.height;
    // final screenWidth = MediaQuery.of(context).size.width;

    // bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: NexusColors.accentColorLight,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 5),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: AppBar(
            surfaceTintColor: Colors.transparent,
            backgroundColor: NexusColors.accentColorLight,
            automaticallyImplyLeading: false,
            leading: InkWell(
              borderRadius: BorderRadius.circular(5),
              onTap: () {}, // Handle tap on leading widget
              child: Transform.scale(
                scale: .85,
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/profile-picture.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StyledText(text: 'Dunn Oliver', fontSize: 18),
                Row(
                  children: [
                    StyledText(
                      text: 'Premium Account',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: NexusColors.secondaryTextColorDark,
                    ),
                    const SizedBox(width: 8),
                    SvgPicture.asset(
                      'assets/icons/small-arrow-right.svg',
                      color: NexusColors.secondaryTextColorDark,
                      height: 12,
                    )
                  ],
                ),
              ],
            ),
            actions: [
              StyledIconButton(
                icon: 'notification',
                onTap: () {},
                backgroundColor: Colors.white,
                iconColor: Colors.black,
              ),
              const SizedBox(width: 10),
              StyledIconButton(
                  icon: 'menu',
                  onTap: () {
                    // _toggleTheme(isDarkMode ? ThemeMode.dark : ThemeMode.light);
                  }),
            ],
          ),
        ),
      ),
      body: Container(
        decoration: const ShapeDecoration(
          color: Colors.white,
          shape: SmoothRectangleBorder(
            borderRadius: SmoothBorderRadius.only(
                topLeft: SmoothRadius(cornerRadius: 35, cornerSmoothing: 0.8),
                topRight: SmoothRadius(cornerRadius: 35, cornerSmoothing: 0.8)),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CarouselSlider(
                  options: CarouselOptions(
                      height: 170, autoPlay: true, viewportFraction: 1),
                  items: [1, 2, 3, 4, 5].map((i) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: GuideTile(
                              image: 'image', title: 'title', onTap: () => {}),
                        );
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: StyledIconTile(
                          icon: 'translate-filled',
                          text: 'Translate',
                          onTap: () => {}),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: StyledIconTile(
                          icon: 'book-filled',
                          text: 'Summarize',
                          onTap: () => {}),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                StyledText(text: 'Recent Content', fontSize: 20),
                const SizedBox(height: 10),
                BlocBuilder<HomeScreenBloc, HomeScreenState>(
                  builder: (context, state) {
                    if (state is HomeScreenInitial) {
                      List<ContentModel> contentList = state.contents;
                      ContentStatus status = state.status;
                      if (status == ContentStatus.success) {
                        return ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: contentList.length, // Number of items
                          separatorBuilder: (BuildContext context, int index) {
                            return const SizedBox(
                                height: 15); // Separator between items
                          },
                          itemBuilder: (BuildContext context, int index) {
                            ContentModel content = contentList[index];
                            return ContentTile(
                              title: content.title ?? '',
                              thumbnail: content.thumbnail ?? '',
                              date: DateTimeConversion.formattedTime(
                                  datetime: content.dateUpdated ?? ''),
                              icon: content.type ?? '',
                              onTap: () => {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (builder) =>
                                        ContentScreen(content: content),
                                  ),
                                )
                              },
                            );
                          },
                        );
                      } else if (status == ContentStatus.loading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
