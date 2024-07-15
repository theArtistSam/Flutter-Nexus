import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nexus/screens/support/support_screen.dart';
import 'package:nexus/utils/constants.dart';
import 'package:nexus/widgets/styled_button.dart';
import 'package:nexus/widgets/styled_icon_button.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NexusColors.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StyledIconButton(
                icon: 'back-arrow',
                onTap: () => Navigator.pop(context),
              ),
              Switch(
                value: NexusColors.isDark,
                onChanged: (isDark) {
                  print(isDark);
                  setState(() {
                    NexusColors.isDark = isDark;
                  });
                },
              ),
              StyledButton(
                text: 'Support',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (builder) => const SupportScreen(),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
