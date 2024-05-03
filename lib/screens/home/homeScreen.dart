import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nexus/utils/constants.dart';
import 'package:nexus/utils/styledText.dart';
import 'package:nexus/widgets/styledIconButton.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NexusColors.accentColorLight,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: AppBar(
            surfaceTintColor: Colors.transparent,
            backgroundColor: NexusColors.accentColorLight,
            leading: InkWell(
              borderRadius: BorderRadius.circular(5),
              onTap: () {}, // Handle tap on leading widget
              child: SizedBox(
                width: 55,
                height: 55,
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
                StyledText(text: 'Dunn Oliver', fontSize: 22),
                Row(
                  children: [
                    StyledText(
                      text: 'Premium Account',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: NexusColors.secondaryTextColor,
                    ),
                    const SizedBox(width: 8),
                    SvgPicture.asset(
                      'assets/icons/small-arrow-right.svg',
                      color: NexusColors.secondaryTextColor,
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
              StyledIconButton(icon: 'menu', onTap: () {}),
            ],
          ),
        ),
      ),
    );
  }
}
