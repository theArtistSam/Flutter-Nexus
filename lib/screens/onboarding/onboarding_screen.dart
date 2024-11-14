import 'package:flutter/material.dart';
import 'package:nexus/screens/login/login_screen.dart';
import 'package:nexus/screens/signup/signup_screen.dart';
import 'package:nexus/utils/constants.dart';
import 'package:nexus/widgets/styled_widgets/styled_button.dart';
import 'package:nexus/widgets/styled_widgets/styled_text.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double topPadding = MediaQuery.of(context).padding.top;
    final double bottomPadding = MediaQuery.of(context).padding.bottom;
    return Scaffold(
      backgroundColor: NexusColors.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: topPadding,
            ),
            Container(
              height: 380,
              color: Colors.black45,
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              height: 60,
              color: Colors.black45,
            ),
            const SizedBox(
              height: 20,
            ),
            StyledText(
              text: "Connect, Entertain, Grow",
              fontSize: 20,
            ),
            StyledText(
              text:
                  "Find the perfect venue, book performers, engage vendors, and connect with attendees—",
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: NexusColors.secondaryTextColor,
            ),
            Spacer(),
            StyledButton(
                text: "Login",
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (builder) => LoginScreen()));
                }),
            const SizedBox(
              height: 10,
            ),
            StyledButton(
                text: "Register",
                isBordered: true,
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (builder) => SignupScreen()));
                }),
            SizedBox(
              height: bottomPadding + 30,
            ),
          ],
        ),
      ),
    );
  }
}
