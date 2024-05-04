import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:nexus/utils/constants.dart';
import 'package:nexus/utils/styledText.dart';

class StyledTabs extends StatefulWidget {
  const StyledTabs({super.key});

  @override
  State<StyledTabs> createState() => _StyledTabsState();
}

class _StyledTabsState extends State<StyledTabs> {
  bool isTranslateSelected = false;
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
                    isTranslateSelected = !isTranslateSelected;
                  });
                },
                child: Container(
                  decoration: ShapeDecoration(
                    color: isTranslateSelected
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
                          text: 'Translate',
                          color: isTranslateSelected
                              ? NexusColors.textColorLight
                              : NexusColors.textColorDark,
                          fontWeight: isTranslateSelected
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
                    print(isTranslateSelected);
                    isTranslateSelected = !isTranslateSelected;
                  });
                },
                child: Container(
                  decoration: ShapeDecoration(
                    color: !isTranslateSelected
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
                          text: 'Summarize',
                          color: !isTranslateSelected
                              ? NexusColors.textColorLight
                              : NexusColors.textColorDark,
                          fontWeight: !isTranslateSelected
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
