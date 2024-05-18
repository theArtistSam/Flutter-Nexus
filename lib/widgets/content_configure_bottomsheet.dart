import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nexus/screens/content/widgets/content_configure_tabs.dart';
import 'package:nexus/utils/constants.dart';
import 'package:nexus/widgets/styled_button.dart';
import 'package:nexus/widgets/styled_text.dart';

class ContentConfigureBottomSheet extends StatelessWidget {
  const ContentConfigureBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Wrap(
      children: [
        Container(
          decoration: const ShapeDecoration(
            color: Colors.white,
            shape: SmoothRectangleBorder(
              borderRadius: SmoothBorderRadius.only(
                  topLeft: SmoothRadius(cornerRadius: 20, cornerSmoothing: 0.8),
                  topRight:
                      SmoothRadius(cornerRadius: 20, cornerSmoothing: 0.8)),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Center(
                child: Container(
                  width: 60,
                  height: 5,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: NexusColors.borderColor),
                ),
              ),
              const SizedBox(height: 15),
              DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  borderRadius:
                      SmoothBorderRadius(cornerRadius: 15, cornerSmoothing: .8),
                  icon: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: SvgPicture.asset(
                      'assets/icons/small-arrow-down.svg',
                      color: Colors.black,
                    ),
                  ),
                  // value: dropdownValue,
                  hint: StyledText(text: 'Summarization Length'),
                  items: <String>['Standard Length', 'Custom Length']
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: StyledText(
                        text: value,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    // setState(() {
                    //   dropdownValue = newValue!;
                    // });
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ContentConfigureTabs(
                tabsText: const ['Short', 'Medium', 'Long'],
                // index: 1,
              ),
              const SizedBox(
                height: 10,
              ),
              StyledText(text: 'Summarization Style'),
              const SizedBox(
                height: 10,
              ),
              ContentConfigureTabs(
                tabsText: const ['Creative', 'Balanaced', 'Precise'],
                // index: 1
              ),
              const Divider(
                height: 50,
                color: NexusColors.dividerColor,
              ),
              StyledButton(text: 'Confirm changes', onTap: () {}),
              SizedBox(height: bottomPadding),
            ]),
          ),
        )
      ],
    );
  }
}
