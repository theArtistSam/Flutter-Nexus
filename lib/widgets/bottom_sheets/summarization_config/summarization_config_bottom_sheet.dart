import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus/blocs/summarization_config_bloc/bloc/summarization_config_bloc.dart';
import 'package:nexus/models/chat_model.dart';
import 'package:nexus/models/model_configs/summarization_config.dart';
import 'package:nexus/widgets/bottom_sheets/summarization_config/content_configure_tabs.dart';
import 'package:nexus/utils/constants.dart';
import 'package:nexus/widgets/styled_widgets/styled_button.dart';
import 'package:nexus/widgets/styled_widgets/styled_snackbar.dart';
import 'package:nexus/widgets/styled_widgets/styled_tabs.dart';
import 'package:nexus/widgets/styled_widgets/styled_text.dart';

class SummarizationConfigBottomSheet extends StatefulWidget {
  const SummarizationConfigBottomSheet({
    super.key,
    required this.summarizationConfig,
    required this.docId,
    required this.onConfirm,
  });

  final SummarizationConfig summarizationConfig;
  final String docId;
  final void Function({required SummarizationConfig summarizationConfig})
      onConfirm;
  @override
  State<SummarizationConfigBottomSheet> createState() =>
      _SummarizationConfigBottomSheetState();
}

class _SummarizationConfigBottomSheetState
    extends State<SummarizationConfigBottomSheet> {
  late SummarizationConfigBloc summarizationConfigBloc;
  @override
  void initState() {
    summarizationConfigBloc = SummarizationConfigBloc(
        summarizationConfig: widget.summarizationConfig, chatId: widget.docId);
    super.initState();
  }

  @override
  void dispose() {
    summarizationConfigBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return BlocProvider(
      create: (context) => summarizationConfigBloc,
      child: Wrap(
        children: [
          Container(
            decoration: ShapeDecoration(
              color: NexusColors.backgroundColor,
              shape: const SmoothRectangleBorder(
                borderRadius: SmoothBorderRadius.only(
                  topLeft: SmoothRadius(
                    cornerRadius: 20,
                    cornerSmoothing: 0.8,
                  ),
                  topRight: SmoothRadius(
                    cornerRadius: 20,
                    cornerSmoothing: 0.8,
                  ),
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
                    const SizedBox(
                      height: 10,
                    ),
                    StyledText(
                      text: 'Summarization Style',
                      color: NexusColors.textColor,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    StyledTabs(
                      leftTabText: "Extractive",
                      rightTabText: "Abstractive",
                      isLeftSelected:
                          widget.summarizationConfig.type == 'extractive',
                      changeState: (isLeftSelected) {
                        // TODO: Make sure to check for the premium user!
                        summarizationConfigBloc.add(
                          ChangeSummarizationStyle(
                            isExtractive: isLeftSelected,
                          ),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    StyledText(
                      text: 'Summarization Length',
                      color: NexusColors.textColor,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    BlocProvider.value(
                      value: summarizationConfigBloc,
                      child: ContentConfigureTabs(
                        tabsText: const ['Short', 'Medium', 'Long'],
                      ),
                    ),
                    Divider(
                      height: 50,
                      color: NexusColors.secondaryTextColor.withOpacity(.15),
                    ),
                    StyledButton(
                      text: 'Confirm changes',
                      onTap: () {
                        final state = summarizationConfigBloc.state
                            as SummarizationConfigInitial;

                        Navigator.pop(context);

                        // * Use the fn callback to update the state
                        widget.onConfirm(
                            summarizationConfig: state.summarizationConfig);
                      },
                    ),
                    SizedBox(height: bottomPadding),
                  ]),
            ),
          )
        ],
      ),
    );
  }
}
