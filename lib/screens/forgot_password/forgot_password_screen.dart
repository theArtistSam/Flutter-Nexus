import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nexus/screens/otp/otp_screen.dart';
import 'package:nexus/screens/reset_password/reset_password_screen.dart';
import 'package:nexus/utils/constants.dart';
import 'package:nexus/widgets/styled_widgets/styled_button.dart';
import 'package:nexus/widgets/styled_widgets/styled_icon_button.dart';
import 'package:nexus/widgets/styled_widgets/styled_text.dart';
import 'package:nexus/widgets/styled_widgets/styled_textfield.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // final double topPadding = MediaQuery.of(context).padding.top;
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: SizedBox(
                  height: 160,
                  child: SvgPicture.asset(
                    'assets/illustrations/forget-password-illustration.svg',
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              StyledText(
                text: 'Forgot Password',
                color: NexusColors.textColor,
                fontSize: 20,
              ),
              const SizedBox(
                height: 5,
              ),
              StyledText(
                text:
                    "Don't worry! It occurs. Please enter the email address linked with your account",
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: NexusColors.secondaryTextColor,
              ),
              const SizedBox(
                height: 10,
              ),
              StyledText(
                text: 'Email',
                fontSize: 18,
              ),
              const SizedBox(
                height: 10,
              ),
              StyledTextfield(
                hintText: 'Enter email',
                controller: _emailController,
              ),
              const SizedBox(
                height: 230,
              ),
              StyledButton(
                text: "Send Code",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (builder) => OtpScreen()),
                  );
                },
              ),
              const SizedBox(
                height: 10,
              ),
              StyledButton(
                text: "Cancel",
                isBordered: true,
                onTap: () {},
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: bottomPadding,
              )
            ],
          ),
        ),
      ),
    );
  }
}
