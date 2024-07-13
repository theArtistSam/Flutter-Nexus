import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nexus/blocs/category_bottom_sheet_bloc/bloc/category_bottom_sheet_bloc.dart';
import 'package:nexus/models/issue_model.dart';
import 'package:nexus/utils/constants.dart';
import 'package:nexus/widgets/styled_button.dart';
import 'package:nexus/widgets/styled_text.dart';

class CategoryBottomSheet extends StatefulWidget {
  const CategoryBottomSheet({
    super.key,
  });

  @override
  State<CategoryBottomSheet> createState() => _CategoryBottomSheetState();
}

class _CategoryBottomSheetState extends State<CategoryBottomSheet> {
  late CategoryBottomSheetBloc categoryBottomSheetBloc;

  @override
  void initState() {
    categoryBottomSheetBloc = CategoryBottomSheetBloc();
    categoryBottomSheetBloc.add(FetchCategories());

    super.initState();
  }

  @override
  void dispose() {
    categoryBottomSheetBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => categoryBottomSheetBloc,
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
                    child: BlocBuilder<CategoryBottomSheetBloc,
                        CategoryBottomSheetState>(
                      builder: (context, state) {
                        final currentState =
                            (state as CategoryBottomSheetInitial);
                        final issues = currentState.issues;
                        return ListView.separated(
                          itemCount: issues.length,
                          separatorBuilder: (BuildContext context, int index) =>
                              const SizedBox(height: 15),
                          itemBuilder: (BuildContext context, int index) {
                            final issue = issues[index];
                            return categoryTile(
                              issue: issue,
                              onTap: () {
                                categoryBottomSheetBloc.add(
                                  SelectCategory(index: index),
                                );
                              },
                              isSelected: currentState.selectedIndex == index,
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
                    onTap: () {
                      final state = (categoryBottomSheetBloc.state
                          as CategoryBottomSheetInitial);
                      final int index = state.selectedIndex;
                      final issues = state.issues;

                      // !Push to support chat screen
                      print("$index ${issues[index].type}");
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

  categoryTile(
          {required IssueModel issue,
          required VoidCallback onTap,
          required bool isSelected}) =>
      Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: const SmoothBorderRadius.all(
            SmoothRadius(cornerRadius: 10, cornerSmoothing: 0.8),
          ),
          onTap: onTap,
          child: Ink(
            decoration: BoxDecoration(
              color: NexusColors.accentColor,
              border: isSelected
                  ? Border.all(
                      color: NexusColors.isDark
                          ? Colors.white
                          : NexusColors.primaryColor,
                      width: 2,
                    )
                  : null,
              borderRadius: const SmoothBorderRadius.all(
                SmoothRadius(cornerRadius: 10, cornerSmoothing: 0.8),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SvgPicture.asset(
                        'assets/icons/${issue.icon}.svg',
                        height: 30,
                        // COLOR: FIX
                        color: NexusColors.isDark
                            ? Colors.white
                            : NexusColors.primaryColor,
                      ),
                      const Spacer(),
                      isSelected
                          ? SvgPicture.asset(
                              'assets/icons/tick-circle.svg',
                              // COLOR: FIX
                              color: NexusColors.isDark
                                  ? Colors.white
                                  : NexusColors.primaryColor,
                            )
                          : const SizedBox(),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  StyledText(
                    text: issue.type!,
                    color: NexusColors.textColor,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  StyledText(
                    text: issue.tagline!,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: NexusColors.textColor.withOpacity(.5),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
