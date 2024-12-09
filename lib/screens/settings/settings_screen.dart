import 'package:figma_squircle/figma_squircle.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nexus/repositories/local_storage_repository.dart';
import 'package:nexus/screens/onboarding/onboarding_screen.dart';
import 'package:nexus/screens/profile/profile_screen.dart';
import 'package:nexus/screens/support/support_screen.dart';
import 'package:nexus/utils/constants.dart';
import 'package:nexus/widgets/styled_widgets/styled_icon_button.dart';
import 'package:nexus/widgets/styled_widgets/styled_text.dart';

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
                  onTap: () async {
                    try {
                      // Get the current user
                      User? currentUser = FirebaseAuth.instance.currentUser;

                      if (currentUser != null) {
                        // Revoke all refresh tokens for the currently logged-in user
                        await currentUser.getIdTokenResult(true);

                        // Sign out the user
                        await FirebaseAuth.instance.signOut();

                        // Print message
                        print("User logged out successfully.");

                        // Navigate to the home screen (you can adjust this based on your app's navigation structure)
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OnboardingScreen()),
                        );
                      } else {
                        print("No user is currently signed in.");
                      }

                      // empty the box!
                      LocalStorageRepository().clearBox();
                    } catch (e) {
                      print("Error logging out: $e");
                    }
                  }),
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
                    onTap: () {
                      final userId = LocalStorageRepository().getUserId()!;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (builder) => ProfileScreen(
                            userId: userId,
                          ),
                        ),
                      );
                    },
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
              height: 10,
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
                      icon: 'globe',
                      text: 'Community notifications',
                      onChanged: (isCommunity) {},
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
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
          padding: const EdgeInsets.fromLTRB(
            20,
            13,
            13,
            13,
          ),
          child: Row(
            children: [
              SvgPicture.asset(
                'assets/icons/$icon.svg',
                color: NexusColors.secondaryTextColor,
              ),
              const SizedBox(
                width: 12,
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
                    width: 12,
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
