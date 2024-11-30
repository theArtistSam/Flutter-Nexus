import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nexus/screens/reset_password/reset_password_screen.dart';
import 'package:nexus/utils/constants.dart';
import 'package:nexus/widgets/styled_widgets/styled_button.dart';
import 'package:nexus/widgets/styled_widgets/styled_icon_button.dart';
import 'package:nexus/widgets/styled_widgets/styled_text.dart';
import 'package:pinput/pinput.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final focusedPinTheme = PinTheme(
    width: 62,
    height: 62,
    padding: EdgeInsets.all(20),
    textStyle: GoogleFonts.poppins(
      fontSize: 20,
      fontWeight: FontWeight.w500,
      color: NexusColors.primaryColor,
    ),
    decoration: BoxDecoration(
      border: Border.all(width: 2, color: NexusColors.primaryColor),
      borderRadius: SmoothBorderRadius(
        cornerRadius: 15,
        cornerSmoothing: 0.8,
      ),
    ),
  );

  final defaultPinTheme = PinTheme(
    width: 62,
    height: 62,
    textStyle: GoogleFonts.poppins(
      fontSize: 20,
      fontWeight: FontWeight.w500,
      color: NexusColors.primaryColor,
    ),
    decoration: BoxDecoration(
      border: Border.all(width: 2, color: NexusColors.borderColor),
      borderRadius: SmoothBorderRadius(
        cornerRadius: 15,
        cornerSmoothing: 0.8,
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final double topPadding = MediaQuery.of(context).padding.top;
    final double bottomPadding = MediaQuery.of(context).padding.bottom;
    return Scaffold(
      backgroundColor: NexusColors.backgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 5),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: AppBar(
            surfaceTintColor: Colors.transparent,
            // COLOR: FIX
            backgroundColor: NexusColors.backgroundColor,
            leadingWidth: 30,
            leading: Transform.scale(
              scale: 1,
              child: StyledIconButton(
                icon: 'back-arrow',
                backgroundColor: NexusColors.backgroundColor,
                // COLOR: FIX
                iconColor: NexusColors.isDark
                    ? Colors.white
                    : NexusColors.primaryColorLight,
                onTap: () => Navigator.pop(context),
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: SizedBox(
                height: 160,
                child: SvgPicture.asset(
                  'assets/illustrations/otp-illustration.svg',
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            StyledText(
              text: 'OTP Verification',
              color: NexusColors.textColor,
              fontSize: 20,
            ),
            const SizedBox(
              height: 5,
            ),
            StyledText(
              text:
                  "Enter the 6-digit verification code we just sent on your email address john@doe.com",
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: NexusColors.secondaryTextColor,
            ),
            const SizedBox(
              height: 10,
            ),
            Pinput(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              length: 5,
              defaultPinTheme: defaultPinTheme,
              focusedPinTheme: focusedPinTheme,
              validator: (s) {
                return s == '55555' ? null : 'Pin is incorrect';
              },
              pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
              showCursor: true,
              onCompleted: (pin) => print(pin),
            ),
            const SizedBox(
              height: 10,
            ),
            Center(
              child: GestureDetector(
                onTap: () {},
                child: RichText(
                    text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Didn’t you receive any code? ",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: NexusColors.textColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextSpan(
                      text: "Resend Code",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: NexusColors.primaryColor,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                )),
              ),
            ),
            const Spacer(),
            StyledButton(
                text: "Verify",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (builder) => ResetPasswordScreen()),
                  );
                }),
            SizedBox(
              height: bottomPadding,
            )
          ],
        ),
      ),
    );
  }
}
