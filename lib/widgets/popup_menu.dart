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
  final List<PopupItem> items;
  final String icon;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      surfaceTintColor: NexusColors.backgroundColor,
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
          _item(item: items[i].name, status: items[i].value)
      ],
    );
  }

  // _stringItem({required String item}) => PopupMenuItem<String>(
  //       value: item,
  //       child: StyledText(
  //         text: item,
  //         fontSize: 14,
  //         fontWeight: FontWeight.w500,
  //       ),
  //     );

  _item({required String item, required bool status}) => PopupMenuItem<String>(
        value: item,
        child: Row(
          children: [
            StyledText(
              text: item,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            const Spacer(),
            status
                ? SvgPicture.asset(
                    'assets/icons/tick-circle.svg',
                    color: NexusColors.textColor,
                  )
                : const SizedBox()
          ],
        ),
      );
}

class PopupItem {
  final String name;
  final bool value;
  const PopupItem({required this.name, this.value = false});
}
