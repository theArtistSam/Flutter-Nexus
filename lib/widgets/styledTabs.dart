import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:nexus/utils/constants.dart';
import 'package:nexus/widgets/styledText.dart';

// ignore: must_be_immutable
class StyledTabs extends StatefulWidget {
  StyledTabs(
      {super.key,
      required this.leftTabText,
      required this.rightTabText,
      required this.isLeftSelected,
      this.changeState});

  String leftTabText;
  String rightTabText;
  bool isLeftSelected;
  void Function()? changeState;

  @override
  State<StyledTabs> createState() => _StyledTabsState();
}

class _StyledTabsState extends State<StyledTabs> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        color: NexusColors.accentColorLight,
        shape: SmoothRectangleBorder(
            borderRadius:
                SmoothBorderRadius(cornerRadius: 15, cornerSmoothing: 0.8)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    widget.isLeftSelected = !widget.isLeftSelected;
                    widget.changeState?.call();
                  });
                },
                child: Container(
                  decoration: ShapeDecoration(
                    color: widget.isLeftSelected
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
                          text: widget.leftTabText,
                          color: widget.isLeftSelected
                              ? NexusColors.textColorLight
                              : NexusColors.textColorDark,
                          fontWeight: widget.isLeftSelected
                              ? FontWeight.w600
                              : FontWeight.w500,
                        ),
                      )),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    widget.isLeftSelected = !widget.isLeftSelected;
                    widget.changeState?.call();
                  });
                },
                child: Container(
                  decoration: ShapeDecoration(
                    color: !widget.isLeftSelected
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
                          text: widget.rightTabText,
                          color: !widget.isLeftSelected
                              ? NexusColors.textColorLight
                              : NexusColors.textColorDark,
                          fontWeight: !widget.isLeftSelected
                              ? FontWeight.w600
                              : FontWeight.w500,
                        ),
                      )),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
