import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nexus/blocs/signin_bloc/bloc/signin_bloc.dart';
import 'package:nexus/screens/forgot_password/forgot_password_screen.dart';
import 'package:nexus/screens/home/home_screen.dart';
import 'package:nexus/utils/bottom_navbar/bottom_navbar.dart';
import 'package:nexus/utils/constants.dart';
import 'package:nexus/utils/enums.dart';
import 'package:nexus/widgets/styled_widgets/styled_button.dart';
import 'package:nexus/widgets/styled_widgets/styled_icon_button.dart';
import 'package:nexus/widgets/styled_widgets/styled_snackbar.dart';
import 'package:nexus/widgets/styled_widgets/styled_text.dart';
import 'package:nexus/widgets/styled_widgets/styled_textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  late SigninBloc signinBloc;
  @override
  void initState() {
    super.initState();
    signinBloc = SigninBloc();
  }

  @override
  void dispose() {
    super.dispose();

    _emailController.dispose();
    _passwordController.dispose();

    signinBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    final double topPadding = MediaQuery.of(context).padding.top;
    final double bottomPadding = MediaQuery.of(context).padding.bottom;
    return BlocProvider(
      create: (context) => signinBloc,
      child: Scaffold(
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
                      child:
                          SvgPicture.asset('assets/illustrations/avatar.svg'),
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
                BlocListener<SigninBloc, SigninState>(
                  listener: (context, state) {
                    if (state is SigninInitial) {
                      if (state.infoStatus == ValidInfoStatus.valid) {
                        StyledSnackbar.show(
                          context: context,
                          message: 'Login Successful!',
                        );
                        // Use pushReplacement to remove the login screen from the stack
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (builder) => BottomNavBar(),
                          ),
                          (route) =>
                              false, // Removes all previous routes from the stack
                        );
                      } else if (state.infoStatus == ValidInfoStatus.invalid) {
                        StyledSnackbar.show(
                          context: context,
                          message: 'Failed to Login!',
                        );
                      }
                    }
                  },
                  child: StyledButton(
                    text: "Login",
                    onTap: () async {
                      final String email = _emailController.text.trim();
                      final String password = _passwordController.text.trim();

                      signinBloc.add(ValidateSignin(
                        email: email,
                        password: password,
                      ));
                    },
                  ),
                ),
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
      ),
    );
  }
}
