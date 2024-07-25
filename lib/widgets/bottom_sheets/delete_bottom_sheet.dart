import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nexus/utils/constants.dart';
import 'package:nexus/widgets/styled_widgets/styled_button.dart';
import 'package:nexus/widgets/styled_widgets/styled_text.dart';

class DeleteBottomSheet extends StatelessWidget {
  const DeleteBottomSheet({
    super.key,
    required this.title,
    required this.message,
    required this.onDelete,
  });

  final String title;
  final String message;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Wrap(
      children: [
        Container(
          decoration: ShapeDecoration(
            color: NexusColors.backgroundColor,
            shape: const SmoothRectangleBorder(
              borderRadius: SmoothBorderRadius.only(
                topLeft: SmoothRadius(cornerRadius: 20, cornerSmoothing: 0.8),
                topRight: SmoothRadius(cornerRadius: 20, cornerSmoothing: 0.8),
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 60,
                    height: 5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: NexusColors.borderColor,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                StyledText(
                  text: title,
                  color: NexusColors.textColor,
                  fontSize: 20,
                ),
                const SizedBox(height: 10),
                StyledText(
                  text: message,
                  color: NexusColors.textColor.withOpacity(.8),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                Divider(
                  height: 40,
                  // COLOR: FIX
                  color: NexusColors.isDark
                      ? NexusColors.accentColor
                      : NexusColors.dividerColor,
                ),
                Row(
                  children: [
                    Expanded(
                      child: StyledButton(
                        text: 'Cancel',
                        onTap: () {
                          Navigator.pop(context);
                        },
                        isBordered: true,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: StyledButton(
                        text: 'Confirm',
                        onTap: onDelete,
                        isDeleteable: true,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: bottomPadding)
              ],
            ),
          ),
        ),
      ],
    );
  }
}
