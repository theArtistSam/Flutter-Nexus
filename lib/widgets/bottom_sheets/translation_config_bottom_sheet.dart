import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nexus/blocs/summarization_config_bloc/bloc/summarization_config_bloc.dart';
import 'package:nexus/blocs/translation_config_bloc/bloc/translation_config_bloc.dart';
import 'package:nexus/models/chat_model.dart';
import 'package:nexus/widgets/bottom_sheets/summarization_config/content_configure_tabs.dart';
import 'package:nexus/utils/constants.dart';
import 'package:nexus/widgets/styled_widgets/styled_button.dart';
import 'package:nexus/widgets/styled_widgets/styled_snackbar.dart';
import 'package:nexus/widgets/styled_widgets/styled_tabs.dart';
import 'package:nexus/widgets/styled_widgets/styled_text.dart';

class TranslationConfigBottomSheet extends StatefulWidget {
  const TranslationConfigBottomSheet({
    super.key,
    required this.translationConfig,
    required this.chatId,
  });

  final TranslationConfig translationConfig;
  final String chatId;
  // TODO : Use this for the future functionality
  // final void Function({required TranslationConfig translationConfig}) onConfirm;
  @override
  State<TranslationConfigBottomSheet> createState() =>
      _SummarizationConfigBottomSheetState();
}

class _SummarizationConfigBottomSheetState
    extends State<TranslationConfigBottomSheet> {
  late TranslationConfigBloc translationConfigBloc;
  @override
  void initState() {
    translationConfigBloc = TranslationConfigBloc(
        translationConfig: widget.translationConfig, chatId: widget.chatId);
    super.initState();
  }

  @override
  void dispose() {
    translationConfigBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return BlocProvider(
      create: (context) => translationConfigBloc,
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
                    StyledText(
                      text: 'Source Language',
                      color: NexusColors.textColor,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    BlocBuilder<TranslationConfigBloc, TranslationConfigState>(
                      builder: (context, state) {
                        final currentState = state as TranslationConfigInitial;
                        final List<String> sourceLaungages =
                            currentState.translationConfig.sourceLanguages!;
                        return _dropdown(languages: sourceLaungages);
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    StyledText(
                      text: 'Target Language',
                      color: NexusColors.textColor,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    BlocBuilder<TranslationConfigBloc, TranslationConfigState>(
                      builder: (context, state) {
                        final currentState = state as TranslationConfigInitial;
                        final List<String> targetLanguages =
                            currentState.translationConfig.targetLanguages!;
                        return _dropdown(languages: targetLanguages);
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Divider(
                      height: 50,
                      color: NexusColors.secondaryTextColor.withOpacity(.15),
                    ),
                    StyledButton(
                      text: 'Confirm changes',
                      onTap: () {
                        // TODO: Update the source and target languages
                        StyledSnackbar.show(
                          context: context,
                          message: 'A Future Functionality',
                        );
                        Navigator.pop(context);
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

  Widget _dropdown({required List<String> languages}) {
    return Container(
      width: double.infinity,
      decoration: ShapeDecoration(
        // color: Colors.amber,
        shape: SmoothRectangleBorder(
          side: BorderSide(
            width: 2,
            color: NexusColors.borderColor,
          ),
          borderRadius: SmoothBorderRadius(
            cornerRadius: 15,
            cornerSmoothing: 0.8,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            borderRadius: SmoothBorderRadius(
              cornerRadius: 15,
              cornerSmoothing: 0.8,
            ),
            dropdownColor: NexusColors.accentColor,
            icon: SvgPicture.asset(
              'assets/icons/small-arrow-down.svg',
              color:
                  NexusColors.isDark ? Colors.white : NexusColors.primaryColor,
            ),
            value: languages[0],
            items: [
              ...languages.map((String language) {
                return DropdownMenuItem<String>(
                  value: language,
                  child: StyledText(
                    text: language,
                    fontWeight: FontWeight.w500,
                    color: NexusColors.isDark
                        ? Colors.white
                        : NexusColors.primaryColor,
                  ),
                );
              }),
            ],
            onChanged: (String? id) {
              // TODO: A Future functionality for selecting languages.
            },
          ),
        ),
      ),
    );
  }
}
