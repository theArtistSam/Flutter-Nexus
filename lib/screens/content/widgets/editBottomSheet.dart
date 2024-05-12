import 'dart:math';

import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nexus/blocs/editBottomSheet_bloc/bloc/edit_bottom_sheet_bloc.dart';
import 'package:nexus/utils/constants.dart';
import 'package:nexus/widgets/styledButton.dart';
import 'package:nexus/widgets/styledIconButton.dart';
import 'package:nexus/widgets/styledTabs.dart';
import 'package:nexus/widgets/styledText.dart';
import 'package:nexus/widgets/styledTextfield.dart';

class EditBottomSheet extends StatefulWidget {
  const EditBottomSheet({super.key});

  @override
  State<EditBottomSheet> createState() => _EditBottomSheetState();
}

class _EditBottomSheetState extends State<EditBottomSheet> {
  late EditBottomSheetBloc editBottomSheetBloc;
  final tags = ['sfs fsf', 'sfsdfdfsf', 'dsfs', 'sfsdf', 'sdf42142 sdf'];

  @override
  void initState() {
    editBottomSheetBloc = EditBottomSheetBloc();
    super.initState();
  }

  @override
  void dispose() {
    editBottomSheetBloc.close();
    super.dispose();
  }

  void changeView(bool isLeftSelected) {
    editBottomSheetBloc.add(ToggleView(isLeftSelected: isLeftSelected));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => editBottomSheetBloc,
      child: SingleChildScrollView(
        child: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Wrap(
            children: [
              Container(
                decoration: const ShapeDecoration(
                  color: Colors.white,
                  shape: SmoothRectangleBorder(
                    borderRadius: SmoothBorderRadius.only(
                        topLeft: SmoothRadius(
                            cornerRadius: 20, cornerSmoothing: 0.8),
                        topRight: SmoothRadius(
                            cornerRadius: 20, cornerSmoothing: 0.8)),
                  ),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                      StyledTabs(
                        leftTabText: 'Details',
                        rightTabText: 'Tags',
                        changeState: changeView,
                        // isLeftSelected: false
                      ),
                      const Divider(
                        color: NexusColors.dividerColor,
                        height: 30,
                      ),
                      // editBottomSheetContent()

                      const SizedBox(height: 10),
                      BlocBuilder<EditBottomSheetBloc, EditBottomSheetState>(
                        builder: (context, state) {
                          if (state is EditBottomSheetInitial) {
                            return state.isLeftSelected
                                ? editBottomSheetContent()
                                : tagsBottomSheetContent(
                                    tags: tags, onTap: () {});
                          } else {
                            return const SizedBox();
                          }
                        },
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  tagTile({tagTitle, onTap}) => Padding(
        padding: const EdgeInsets.all(5),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius:
                SmoothBorderRadius(cornerRadius: 10, cornerSmoothing: .8),
            onTap: onTap,
            child: Ink(
              decoration: ShapeDecoration(
                color: NexusColors.accentColorLight,
                shape: SmoothRectangleBorder(
                  borderRadius:
                      SmoothBorderRadius(cornerRadius: 10, cornerSmoothing: .8),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/cancel.svg',
                      color: NexusColors.primaryColorLight,
                    ),
                    StyledText(
                      text: tagTitle ?? '',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: NexusColors.primaryColorLight,
                    ),
                    const SizedBox(
                      width: 10,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      );

  tagsBottomSheetContent({tags, onTap}) => Column(
        children: [
          Row(
            children: [
              Expanded(
                child: StyledTextfield(
                  icon: 'hashtag-square',
                  hintText: 'Add a tag',
                  controller: TextEditingController(),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              StyledIconButton(icon: 'arrow-up', onTap: () {})
            ],
          ),
          SizedBox(
            width: double.infinity,
            height: 523,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Wrap(children: [
                for (var tag in tags) tagTile(tagTitle: tag, onTap: onTap)
              ]),
            ),
          ),
        ],
      );

  editBottomSheetContent() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                  borderRadius: SmoothBorderRadius(
                      cornerRadius: 15, cornerSmoothing: 0.8),
                  child: Image.asset('assets/images/content.png',
                      height: 180, width: double.infinity, fit: BoxFit.cover)),
              Positioned.fill(
                  child: Container(
                // height: 410,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(.1), // Start color (0% black)
                      Colors.black.withOpacity(0.5), // End color (90% black)
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    // crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/icons/pencil-filled.svg',
                        color: Colors.white,
                      ),
                      const SizedBox(width: 5),
                      StyledText(
                        text: 'Change Thumbnail',
                        fontWeight: FontWeight.w500,
                        color: NexusColors.textColorLight,
                      )
                    ],
                  ),
                ),
              )),
            ],
          ),
          const SizedBox(height: 20),
          StyledText(text: 'Video Title', fontSize: 18),
          const SizedBox(height: 10),
          StyledTextfield(
            icon: null,
            hintText: 'Add video title...',
            controller: TextEditingController(),
            maxlines: 5,
          ),
          const SizedBox(height: 20),
          StyledText(text: 'Select Folder', fontSize: 18),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            decoration: ShapeDecoration(
                // color: Colors.amber,
                shape: SmoothRectangleBorder(
                    side: const BorderSide(
                        width: 2, color: NexusColors.borderColor),
                    borderRadius: SmoothBorderRadius(
                        cornerRadius: 15, cornerSmoothing: 0.8))),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  borderRadius: SmoothBorderRadius(
                      cornerRadius: 15, cornerSmoothing: 0.8),
                  icon: SvgPicture.asset(
                    'assets/icons/small-arrow-down.svg',
                    color: NexusColors.primaryColorLight,
                  ),
                  // value: dropdownValue,
                  items: <String>['A', 'B', 'C', 'D'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: StyledText(
                        text: value,
                        color: NexusColors.primaryColorLight,
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
            ),
          ),
          const Divider(
            height: 50,
            color: NexusColors.dividerColor,
          ),
          StyledButton(text: 'Delete Video', onTap: () {}, isDeleteable: true),
          const SizedBox(
            height: 15,
          ),
          StyledButton(text: 'Confirm Changes', onTap: () {}),
          const SizedBox(
            height: 20,
          ),
        ],
      );
}
