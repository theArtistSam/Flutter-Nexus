import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nexus/screens/support/support_screen.dart';
import 'package:nexus/utils/constants.dart';
import 'package:nexus/widgets/styled_button.dart';
import 'package:nexus/widgets/styled_icon_button.dart';
import 'package:nexus/widgets/styled_text.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // COLOR: FIX
      backgroundColor: NexusColors.isDark
          ? const Color(0XFF0A0A0A)
          : NexusColors.accentColorLight,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 5),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: AppBar(
            surfaceTintColor: Colors.transparent,
            // COLOR: FIX
            backgroundColor: NexusColors.isDark
                ? const Color(0XFF0A0A0A)
                : NexusColors.accentColorLight,
            leadingWidth: 30,
            leading: Transform.scale(
              scale: 1,
              child: StyledIconButton(
                icon: 'back-arrow',
                backgroundColor: NexusColors.isDark
                    ? const Color(0XFF0A0A0A)
                    : NexusColors.accentColorLight,
                // COLOR: FIX
                iconColor: NexusColors.isDark
                    ? Colors.white
                    : NexusColors.primaryColorLight,
                onTap: () => Navigator.pop(context),
              ),
            ),
            title: StyledText(
              text: 'Settings',
              color: NexusColors.textColor,
              fontSize: 24,
            ),
            actions: [
              StyledIconButton(
                isBordered: true,
                backgroundColor: NexusColors.isDark
                    ? const Color(0XFF0A0A0A)
                    : NexusColors.accentColor,
                // COLOR: FIX
                iconColor: NexusColors.isDark
                    ? Colors.white
                    : NexusColors.primaryColor,
                padding: 6,
                icon: 'logout',
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: ShapeDecoration(
                color: NexusColors.backgroundColor,
                shape: const SmoothRectangleBorder(
                  borderRadius: SmoothBorderRadius.only(
                    topLeft:
                        SmoothRadius(cornerRadius: 35, cornerSmoothing: 0.8),
                    topRight: SmoothRadius(
                      cornerRadius: 35,
                      cornerSmoothing: 0.8,
                    ),
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {},
                    borderRadius: const SmoothBorderRadius.all(
                      SmoothRadius(
                        cornerRadius: 15,
                        cornerSmoothing: 0.8,
                      ),
                    ),
                    child: Ink(
                      decoration: ShapeDecoration(
                        color: NexusColors.accentColor,
                        shape: const SmoothRectangleBorder(
                          borderRadius: SmoothBorderRadius.all(
                            SmoothRadius(
                              cornerRadius: 15,
                              cornerSmoothing: 0.8,
                            ),
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Row(
                          children: [
                            ClipOval(
                              child: Image.asset(
                                'assets/images/profile-picture.png',
                                width: 45,
                                height: 45,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                StyledText(
                                  text: 'Dunn Oliver',
                                  color: NexusColors.textColor,
                                ),
                                StyledText(
                                  text: 'View Profile',
                                  color: NexusColors.secondaryTextColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ],
                            ),
                            const Spacer(),
                            SvgPicture.asset(
                              'assets/icons/small-arrow-right.svg',
                              color: NexusColors.secondaryTextColor,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              color: NexusColors.backgroundColor,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StyledText(
                      text: 'Preferences',
                      color: NexusColors.textColor,
                      fontSize: 20,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    toggleTile(
                      icon: 'moon',
                      text: 'Toggle theme',
                      onChanged: (isDark) {
                        setState(() {
                          NexusColors.isDark = isDark;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    toggleTile(
                      icon: 'computer',
                      text: 'App notifications',
                      onChanged: (isApp) {},
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    toggleTile(
                      icon: 'community',
                      text: 'Community notifications',
                      onChanged: (isCommunity) {},
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              color: NexusColors.backgroundColor,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StyledText(
                      text: 'Account',
                      color: NexusColors.textColor,
                      fontSize: 20,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    settingTile(
                      icon: 'person-edit',
                      text: 'Manage account',
                      onTap: () {},
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    settingTile(
                      icon: 'support-message',
                      text: 'Help & Support',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (builder) => const SupportScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget toggleTile({
    required icon,
    required text,
    required void Function(bool)? onChanged,
  }) =>
      Container(
        decoration: ShapeDecoration(
          color: NexusColors.accentColor,
          shape: const SmoothRectangleBorder(
            borderRadius: SmoothBorderRadius.all(
              SmoothRadius(
                cornerRadius: 15,
                cornerSmoothing: 0.8,
              ),
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 13,
            horizontal: 20,
          ),
          child: Row(
            children: [
              SvgPicture.asset(
                'assets/icons/$icon.svg',
                color: NexusColors.secondaryTextColor,
              ),
              const SizedBox(
                width: 15,
              ),
              StyledText(
                text: text,
                color: NexusColors.secondaryTextColor,
                fontWeight: FontWeight.w500,
              ),
              const Spacer(),
              Switch(
                activeTrackColor: NexusColors.backgroundColor,
                inactiveTrackColor: NexusColors.backgroundColor,
                value: NexusColors.isDark,
                onChanged: onChanged,
              ),
            ],
          ),
        ),
      );

  Widget settingTile({
    required icon,
    required text,
    required VoidCallback onTap,
  }) =>
      Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: const SmoothBorderRadius.all(
            SmoothRadius(
              cornerRadius: 15,
              cornerSmoothing: 0.8,
            ),
          ),
          onTap: onTap,
          child: Ink(
            decoration: ShapeDecoration(
              color: NexusColors.accentColor,
              shape: const SmoothRectangleBorder(
                borderRadius: SmoothBorderRadius.all(
                  SmoothRadius(
                    cornerRadius: 15,
                    cornerSmoothing: 0.8,
                  ),
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 25,
                horizontal: 20,
              ),
              child: Row(
                children: [
                  SvgPicture.asset(
                    'assets/icons/$icon.svg',
                    color: NexusColors.secondaryTextColor,
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  StyledText(
                    text: text,
                    color: NexusColors.secondaryTextColor,
                    fontWeight: FontWeight.w500,
                  ),
                  const Spacer(),
                  SvgPicture.asset(
                    'assets/icons/small-arrow-right.svg',
                    color: NexusColors.secondaryTextColor,
                  )
                ],
              ),
            ),
          ),
        ),
      );
}
