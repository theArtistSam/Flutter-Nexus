import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus/blocs/configure_tabs_bloc/bloc/configure_tabs_bloc.dart';
import 'package:nexus/utils/constants.dart';
import 'package:nexus/widgets/styled_text.dart';

// ignore: must_be_immutable
class ContentConfigureTabs extends StatefulWidget {
  ContentConfigureTabs({super.key, required this.tabsText});

  List<String> tabsText;
  void Function()? changeState;

  @override
  State<ContentConfigureTabs> createState() => _ContentConfigureTabsState();
}

class _ContentConfigureTabsState extends State<ContentConfigureTabs> {
  late ConfigureTabsBloc configureTabsBloc;

  @override
  void initState() {
    configureTabsBloc = ConfigureTabsBloc();
    super.initState();
  }

  @override
  void dispose() {
    configureTabsBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => configureTabsBloc,
      child: BlocBuilder<ConfigureTabsBloc, ConfigureTabsState>(
        builder: (context, state) {
          if (state is ConfigureTabsInitial) {
            print(state.index);
            return Container(
              // width: 100,
              decoration: ShapeDecoration(
                // color: Colors.redAccent,
                color: NexusColors.accentColorLight,
                shape: SmoothRectangleBorder(
                    borderRadius: SmoothBorderRadius(
                        cornerRadius: 15, cornerSmoothing: 0.8)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  children: [
                    tab(
                        selectedIndex: 0,
                        index: state.index,
                        text: widget.tabsText[0]),
                    tab(
                        selectedIndex: 1,
                        index: state.index,
                        text: widget.tabsText[1]),
                    tab(
                        selectedIndex: 2,
                        index: state.index,
                        text: widget.tabsText[2]),
                  ],
                ),
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  tab({selectedIndex, index, text}) => Expanded(
        child: GestureDetector(
          onTap: () {
            if (!(selectedIndex == index)) {
              configureTabsBloc.add(ToggleTabs(index: selectedIndex));
            }
          },
          child: Container(
            decoration: ShapeDecoration(
              color: index == selectedIndex
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
                    color: index == selectedIndex
                        ? NexusColors.textColorLight
                        : NexusColors.textColorDark,
                    fontWeight: index == selectedIndex
                        ? FontWeight.w600
                        : FontWeight.w500,
                  ),
                )),
          ),
        ),
      );
}
