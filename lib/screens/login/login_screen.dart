import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nexus/screens/forgot_password/forgot_password_screen.dart';
import 'package:nexus/utils/constants.dart';
import 'package:nexus/widgets/styled_widgets/styled_button.dart';
import 'package:nexus/widgets/styled_widgets/styled_icon_button.dart';
import 'package:nexus/widgets/styled_widgets/styled_text.dart';
import 'package:nexus/widgets/styled_widgets/styled_textfield.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ClipOval(
                  child: Container(
                    width: 100,
                    height: 100,
                    color: NexusColors.accentColor,
                    child: SvgPicture.asset('assets/illustrations/avatar.svg'),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              StyledText(
                text: 'Login',
                color: NexusColors.textColor,
                fontSize: 20,
              ),
              const SizedBox(
                height: 5,
              ),
              StyledText(
                text: "Sign in to keep exploring the app",
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
                height: 20,
              ),
              StyledText(
                text: 'Password',
                fontSize: 18,
              ),
              const SizedBox(
                height: 10,
              ),
              StyledTextfield(
                hintText: 'Enter password',
                isPassword: true,
                controller: _passwordController,
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (builder) => ForgotPasswordScreen()));
                },
                child: Text(
                  "Forgot Password?",
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: NexusColors.textColor,
                    fontWeight: FontWeight.w400,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const SizedBox(
                height: 120,
              ),
              StyledButton(
                  text: "Login",
                  onTap: () {
                    // Navigator.push(context,
                    //     MaterialPageRoute(builder: (builder) => LoginScreen()));
                  }),
              const SizedBox(
                height: 12,
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 1.5,
                      decoration: BoxDecoration(
                        color: NexusColors.borderColor,
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: StyledText(
                      text: "Or Login with",
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: NexusColors.borderColor,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 1.5,
                      decoration: BoxDecoration(
                        color: NexusColors.borderColor,
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 12,
              ),
              // TODO: Add the color here
              StyledButton(
                icon: 'google-drive',
                text: "Google",
                isBordered: true,
                onTap: () {},
              ),
              const SizedBox(
                height: 20,
              ),
              // TODO: Change this
              Center(
                child: GestureDetector(
                  onTap: () {},
                  child: RichText(
                      text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Don't have an account? ",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: NexusColors.textColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextSpan(
                        text: "Register",
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
