import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nexus/blocs/signup_bloc/bloc/signup_bloc.dart';
import 'package:nexus/utils/constants.dart';
import 'package:nexus/utils/enums.dart';
import 'package:nexus/widgets/styled_widgets/styled_button.dart';
import 'package:nexus/widgets/styled_widgets/styled_icon_button.dart';
import 'package:nexus/widgets/styled_widgets/styled_snackbar.dart';
import 'package:nexus/widgets/styled_widgets/styled_text.dart';
import 'package:nexus/widgets/styled_widgets/styled_textfield.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmpasswordController =
      TextEditingController();

  late SignupBloc signupBloc;

  @override
  void initState() {
    super.initState();
    signupBloc = SignupBloc();
  }

  @override
  void dispose() {
    super.dispose();
    _confirmpasswordController.dispose();
    _passwordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();

    signupBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    final double topPadding = MediaQuery.of(context).padding.top;
    final double bottomPadding = MediaQuery.of(context).padding.bottom;
    return BlocProvider(
      create: (context) => signupBloc,
      child: Scaffold(
        backgroundColor: NexusColors.backgroundColor,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight + 5),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: AppBar(
              surfaceTintColor: Colors.transparent,
              backgroundColor: NexusColors.backgroundColor,
              leadingWidth: 30,
              leading: Transform.scale(
                scale: 1,
                child: StyledIconButton(
                  icon: 'back-arrow',
                  backgroundColor: NexusColors.backgroundColor,
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
                  text: 'Register',
                  color: NexusColors.textColor,
                  fontSize: 20,
                ),
                const SizedBox(
                  height: 5,
                ),
                StyledText(
                  text: "Get started by entering your Personal information",
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: NexusColors.secondaryTextColor,
                ),
                const SizedBox(
                  height: 10,
                ),
                StyledText(
                  text: 'Full Name',
                  fontSize: 18,
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: StyledTextfield(
                        hintText: 'First name',
                        controller: _firstNameController,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: StyledTextfield(
                        hintText: 'Last name',
                        controller: _lastNameController,
                      ),
                    ),
                  ],
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
                  height: 15,
                ),
                StyledText(
                  text: 'Confirm Password',
                  fontSize: 18,
                ),
                const SizedBox(
                  height: 10,
                ),
                StyledTextfield(
                  hintText: 'Enter confirm password',
                  isPassword: true,
                  controller: _confirmpasswordController,
                ),
                const SizedBox(
                  height: 50,
                ),
                BlocListener<SignupBloc, SignupState>(
                  listener: (context, state) {
                    if (state is SignupInitial) {
                      // Handle user creation status
                      if (state.userCreatedStatus == CreateUserStatus.success) {
                        StyledSnackbar.show(
                          context: context,
                          message: 'User created successfully!',
                        );
                        Navigator.pop(context);
                        StyledSnackbar.show(
                          context: context,
                          message: 'Please Sign in',
                        );

                        // Navigate to another screen or reset form
                      } else if (state.userCreatedStatus ==
                          CreateUserStatus.error) {
                        StyledSnackbar.show(
                          context: context,
                          message: 'Failed to create user. Please try again.',
                        );
                      } else if (state.userCreatedStatus ==
                          CreateUserStatus.alreadyExists) {
                        StyledSnackbar.show(
                          context: context,
                          message: 'The user already exists!',
                        );
                      }
                      // Handle validation status
                      if (state.infoStatus == ValidInfoStatus.invalid) {
                        StyledSnackbar.show(
                          context: context,
                          message: 'Please fill out all fields correctly!',
                        );
                      } else if (state.infoStatus == ValidInfoStatus.valid) {
                        signupBloc.add(CreateUser(
                          email: _emailController.text.trim(),
                          password: _passwordController.text,
                          firstName: _firstNameController.text.trim(),
                          lastName: _lastNameController.text.trim(),
                        ));
                      }
                    }
                  },
                  child: StyledButton(
                    text: "Register",
                    onTap: () async {
                      signupBloc.add(ValidateInformation(
                        firstName: _firstNameController.text,
                        lastName: _lastNameController.text,
                        email: _emailController.text,
                        password: _passwordController.text,
                        confirmPassword: _confirmpasswordController.text,
                      ));
                    },
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
