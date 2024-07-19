import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nexus/utils/constants.dart';
import 'package:nexus/widgets/styled_text.dart';

class CategoryTile extends StatelessWidget {
  const CategoryTile({
    super.key,
    required this.onTap,
    required this.title,
    required this.tagline,
    required this.icon,
    required this.isSelected,
  });

  final VoidCallback onTap;
  final String title;
  final String tagline;
  final String icon;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: const SmoothBorderRadius.all(
          SmoothRadius(cornerRadius: 10, cornerSmoothing: 0.8),
        ),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            color: NexusColors.accentColor,
            border: isSelected
                ? Border.all(
                    color: NexusColors.isDark
                        ? Colors.white
                        : NexusColors.primaryColor,
                    width: 2,
                  )
                : null,
            borderRadius: const SmoothBorderRadius.all(
              SmoothRadius(cornerRadius: 10, cornerSmoothing: 0.8),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/$icon.svg',
                      height: 30,
                      // COLOR: FIX
                      color: NexusColors.isDark
                          ? Colors.white
                          : NexusColors.primaryColor,
                    ),
                    const Spacer(),
                    isSelected
                        ? SvgPicture.asset(
                            'assets/icons/tick-circle.svg',
                            // COLOR: FIX
                            color: NexusColors.isDark
                                ? Colors.white
                                : NexusColors.primaryColor,
                          )
                        : const SizedBox(),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                StyledText(
                  text: title,
                  color: NexusColors.textColor,
                ),
                const SizedBox(
                  height: 5,
                ),
                StyledText(
                  text: tagline,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: NexusColors.secondaryTextColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
