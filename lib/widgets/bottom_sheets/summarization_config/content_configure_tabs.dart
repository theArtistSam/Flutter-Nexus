import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus/blocs/summarization_config_bloc/bloc/summarization_config_bloc.dart';
import 'package:nexus/utils/constants.dart';
import 'package:nexus/widgets/styled_widgets/styled_text.dart';

// ignore: must_be_immutable
class ContentConfigureTabs extends StatefulWidget {
  const ContentConfigureTabs({super.key, required this.tabsText});

  final List<String> tabsText;

  @override
  State<ContentConfigureTabs> createState() => _ContentConfigureTabsState();
}

class _ContentConfigureTabsState extends State<ContentConfigureTabs> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SummarizationConfigBloc, SummarizationConfigState>(
      builder: (context, state) {
        if (state is SummarizationConfigInitial) {
          return Container(
            decoration: ShapeDecoration(
              color: NexusColors.accentColor,
              shape: SmoothRectangleBorder(
                borderRadius: SmoothBorderRadius(
                  cornerRadius: 15,
                  cornerSmoothing: 0.8,
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                children: [
                  tab(
                    selectedIndex: 0,
                    index: state.index,
                    text: widget.tabsText[0],
                  ),
                  tab(
                    selectedIndex: 1,
                    index: state.index,
                    text: widget.tabsText[1],
                  ),
                  tab(
                    selectedIndex: 2,
                    index: state.index,
                    text: widget.tabsText[2],
                  ),
                ],
              ),
            ),
          );
        }
        return const SizedBox();
      },
    );
  }

  tab({
    required int selectedIndex,
    required int index,
    required String text,
  }) =>
      Expanded(
        child: GestureDetector(
          onTap: () {
            if (!(selectedIndex == index)) {
              context
                  .read<SummarizationConfigBloc>()
                  .add(ChangeSummarizationLength(index: selectedIndex));
            }
          },
          child: Container(
            decoration: ShapeDecoration(
              color: index == selectedIndex
                  ? NexusColors.primaryColor
                  : NexusColors.accentColor,
              shape: SmoothRectangleBorder(
                borderRadius: SmoothBorderRadius(
                  cornerRadius: 10,
                  cornerSmoothing: 0.8,
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Center(
                child: StyledText(
                  text: text,
                  fontSize: 14,
                  color: index == selectedIndex
                      ? NexusColors.textColorLight
                      : NexusColors.textColor,
                  fontWeight: index == selectedIndex
                      ? FontWeight.w600
                      : FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      );
}
