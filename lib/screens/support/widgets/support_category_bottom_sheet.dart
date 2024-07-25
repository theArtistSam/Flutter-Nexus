import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nexus/blocs/support_category_bottom_sheet_bloc/bloc/support_category_bottom_sheet_bloc.dart';
import 'package:nexus/blocs/support_bloc/bloc/support_bloc.dart';
import 'package:nexus/blocs/support_chat_bloc/bloc/support_chat_bloc.dart';
import 'package:nexus/models/category_model.dart';
import 'package:nexus/repositories/support_repository.dart';
import 'package:nexus/utils/constants.dart';
import 'package:nexus/widgets/category_tile.dart';
import 'package:nexus/widgets/styled_widgets/styled_button.dart';
import 'package:nexus/widgets/styled_widgets/styled_text.dart';

class SupportCategoryBottomSheet extends StatefulWidget {
  const SupportCategoryBottomSheet({
    super.key,
  });

  @override
  State<SupportCategoryBottomSheet> createState() =>
      _SupportCategoryBottomSheetState();
}

class _SupportCategoryBottomSheetState
    extends State<SupportCategoryBottomSheet> {
  late SupportCategoryBottomSheetBloc supportCategoryBottomSheetBloc;

  @override
  void initState() {
    supportCategoryBottomSheetBloc = SupportCategoryBottomSheetBloc();
    supportCategoryBottomSheetBloc.add(FetchIssueCategories());

    super.initState();
  }

  @override
  void dispose() {
    supportCategoryBottomSheetBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => supportCategoryBottomSheetBloc,
      child: Wrap(
        children: [
          Container(
            // height: height - 40,
            decoration: ShapeDecoration(
              color: NexusColors.backgroundColor,
              shape: const SmoothRectangleBorder(
                borderRadius: SmoothBorderRadius.all(
                  SmoothRadius(
                    cornerRadius: 20,
                    cornerSmoothing: 0.8,
                  ),
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 60,
                      height: 5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          20,
                        ),
                        color: NexusColors.borderColor,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  StyledText(
                    text: 'Issue category',
                    color: NexusColors.textColor,
                    fontSize: 20,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height - 210,
                    child: BlocBuilder<SupportCategoryBottomSheetBloc,
                        SupportCategoryBottomSheetState>(
                      builder: (context, state) {
                        final currentState =
                            (state as SupportCategoryBottomSheetInitial);
                        final issues = currentState.issues;
                        return ListView.separated(
                          itemCount: issues.length,
                          separatorBuilder: (BuildContext context, int index) =>
                              const SizedBox(height: 15),
                          itemBuilder: (BuildContext context, int index) {
                            final issue = issues[index];
                            return CategoryTile(
                              title: issue.type!,
                              tagline: issue.tagline!,
                              icon: issue.icon!,
                              isSelected: currentState.selectedIndex == index,
                              onTap: () {
                                supportCategoryBottomSheetBloc.add(
                                  SelectIssueCategory(index: index),
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  StyledButton(
                    text: 'Proceed',
                    onTap: () async {
                      final state = (supportCategoryBottomSheetBloc.state
                          as SupportCategoryBottomSheetInitial);
                      final int index = state.selectedIndex;
                      final issues = state.issues;

                      // * Push to support chat screen
                      // * PROVIDE THE USER ID HERE *
                      bool issueStatus = await SupportRepository()
                          .checkIssueStatus(userId: 'Bd4umkyLqOLnMpdOLZ0E');
                      // ignore: use_build_context_synchronously
                      if (!issueStatus) {
                        supportCategoryBottomSheetBloc.add(
                          AddIssue(
                            issueCategory: issues[index].type!,
                            userId: 'Bd4umkyLqOLnMpdOLZ0E',
                          ),
                        );
                        Navigator.pop(context);
                      } else {
                        print('AN ISSUE IS ALREADY PENDING');
                      }
                    },
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).padding.bottom,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
