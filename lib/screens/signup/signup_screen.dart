import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nexus/utils/constants.dart';
import 'package:nexus/widgets/styled_widgets/styled_button.dart';
import 'package:nexus/widgets/styled_widgets/styled_icon_button.dart';
import 'package:nexus/widgets/styled_widgets/styled_text.dart';
import 'package:nexus/widgets/styled_widgets/styled_textfield.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmpasswordController =
      TextEditingController();

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
                text: 'Name',
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
              StyledButton(
                text: "Register",
                onTap: () {},
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
