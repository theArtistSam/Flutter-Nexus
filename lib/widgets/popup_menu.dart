import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nexus/utils/constants.dart';
import 'package:nexus/widgets/styled_widgets/styled_text.dart';

class PopupMenu extends StatelessWidget {
  const PopupMenu({
    super.key,
    required this.onSelected,
    required this.items,
    required this.icon,
  });

  final void Function(String)? onSelected;
  final List<String> items;
  final String icon;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      shape: SmoothRectangleBorder(
        borderRadius: SmoothBorderRadius(
          cornerRadius: 12,
          cornerSmoothing: .8,
        ),
      ),
      padding: EdgeInsets.zero,
      color: NexusColors.accentColor,
      icon: SvgPicture.asset(
        'assets/icons/$icon.svg',
        color: NexusColors.textColor,
      ),
      onSelected: onSelected,
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        for (int i = 0; i < items.length; i++)
          PopupMenuItem<String>(
            value: items[i],
            child: StyledText(
              text: items[i],
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
      ],
    );
  }
}
