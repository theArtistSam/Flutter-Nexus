import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus/blocs/styled_tabs_bloc/bloc/styled_tabs_bloc.dart';
import 'package:nexus/utils/constants.dart';
import 'package:nexus/widgets/styled_widgets/styled_text.dart';

// ignore: must_be_immutable
class StyledTabs extends StatefulWidget {
  StyledTabs({
    super.key,
    required this.leftTabText,
    required this.rightTabText,
    this.changeState,
  });

  String leftTabText;
  String rightTabText;
  void Function(bool isLeftSelected)? changeState;

  @override
  State<StyledTabs> createState() => _StyledTabsState();
}

class _StyledTabsState extends State<StyledTabs> {
  late StyledTabsBloc styledTabsBloc;

  @override
  void initState() {
    styledTabsBloc = StyledTabsBloc();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    styledTabsBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => styledTabsBloc,
      child: BlocBuilder<StyledTabsBloc, StyledTabsState>(
        builder: (context, state) {
          if (state is StyledTabsInitial) {
            bool isLeftSelected = state.isLeftSelected;
            return Container(
              decoration: ShapeDecoration(
                color: NexusColors.accentColor,
                shape: SmoothRectangleBorder(
                    borderRadius: SmoothBorderRadius(
                        cornerRadius: 15, cornerSmoothing: 0.8)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          if (!isLeftSelected) {
                            styledTabsBloc.add(
                              ToggleTabs(isLeftSelected: true),
                            );

                            // !isLeftSelected is used because state update afterwards
                            widget.changeState?.call(!isLeftSelected);
                          }
                        },
                        child: Container(
                          decoration: ShapeDecoration(
                            color: isLeftSelected
                                ? NexusColors.primaryColor
                                : NexusColors.accentColor,
                            shape: SmoothRectangleBorder(
                                borderRadius: SmoothBorderRadius(
                                    cornerRadius: 10, cornerSmoothing: 0.8)),
                          ),
                          child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Center(
                                child: StyledText(
                                  text: widget.leftTabText,
                                  color: isLeftSelected
                                      ? NexusColors.textColorLight
                                      : NexusColors.textColor,
                                  fontWeight: isLeftSelected
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
                          if (isLeftSelected) {
                            styledTabsBloc
                                .add(ToggleTabs(isLeftSelected: false));
                            widget.changeState?.call(!isLeftSelected);
                          }
                        },
                        child: Container(
                          decoration: ShapeDecoration(
                            color: !isLeftSelected
                                ? NexusColors.primaryColor
                                : NexusColors.accentColor,
                            shape: SmoothRectangleBorder(
                                borderRadius: SmoothBorderRadius(
                                    cornerRadius: 10, cornerSmoothing: 0.8)),
                          ),
                          child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Center(
                                child: StyledText(
                                  text: widget.rightTabText,
                                  color: !isLeftSelected
                                      ? NexusColors.textColorLight
                                      : NexusColors.textColor,
                                  fontWeight: !isLeftSelected
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
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}
