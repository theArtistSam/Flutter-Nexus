import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:nexus/utils/constants.dart';
import 'package:nexus/widgets/styledText.dart';

// ignore: must_be_immutable
class ContentConfigureTabs extends StatefulWidget {
  ContentConfigureTabs(
      {super.key, required this.tabsText, required this.index});

  int index;
  List<String> tabsText;
  void Function()? changeState;

  @override
  State<ContentConfigureTabs> createState() => _ContentConfigureTabsState();
}

class _ContentConfigureTabsState extends State<ContentConfigureTabs> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // width: 100,
      decoration: ShapeDecoration(
        // color: Colors.redAccent,
        color: NexusColors.accentColorLight,
        shape: SmoothRectangleBorder(
            borderRadius:
                SmoothBorderRadius(cornerRadius: 15, cornerSmoothing: 0.8)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Row(
          children: [
            tab(selectedIndex: 0, text: widget.tabsText[0]),
            tab(selectedIndex: 1, text: widget.tabsText[1]),
            tab(selectedIndex: 2, text: widget.tabsText[2]),
          ],
        ),
      ),
    );
  }

  tab({selectedIndex, text}) => Expanded(
        child: GestureDetector(
          onTap: () {
            setState(() {
              widget.index = selectedIndex;
            });
          },
          child: Container(
            decoration: ShapeDecoration(
              color: widget.index == selectedIndex
                  ? NexusColors.primaryColorLight
                  : NexusColors.accentColorLight,
              shape: SmoothRectangleBorder(
                  borderRadius: SmoothBorderRadius(
                      cornerRadius: 10, cornerSmoothing: 0.8)),
            ),
            child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Center(
                  child: StyledText(
                    text: text,
                    color: widget.index == selectedIndex
                        ? NexusColors.textColorLight
                        : NexusColors.textColorDark,
                    fontWeight: widget.index == selectedIndex
                        ? FontWeight.w600
                        : FontWeight.w500,
                  ),
                )),
          ),
        ),
      );
}
