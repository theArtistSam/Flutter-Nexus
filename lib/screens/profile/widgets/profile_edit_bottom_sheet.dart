import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nexus/blocs/profile_screen_bloc/bloc/profile_screen_bloc.dart';
import 'package:nexus/models/user_model.dart';
import 'package:nexus/utils/constants.dart';
import 'package:nexus/widgets/bottom_sheets/image_slider_bottom_sheet.dart';
import 'package:nexus/widgets/popup_menu.dart';
import 'package:nexus/widgets/styled_widgets/styled_button.dart';
import 'package:nexus/widgets/styled_widgets/styled_icon_button.dart';
import 'package:nexus/widgets/styled_widgets/styled_snackbar.dart';
import 'package:nexus/widgets/styled_widgets/styled_text.dart';
import 'package:nexus/widgets/styled_widgets/styled_textfield.dart';

class ProfileEditBottomSheet extends StatefulWidget {
  const ProfileEditBottomSheet({
    super.key,
    required this.onConfirm,
  });

  final VoidCallback onConfirm;
  @override
  State<ProfileEditBottomSheet> createState() => _ProfileEditBottomSheetState();
}

class _ProfileEditBottomSheetState extends State<ProfileEditBottomSheet> {
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController biographyController;

  @override
  void initState() {
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    biographyController = TextEditingController();

    final state =
        context.read<ProfileScreenBloc>().state as ProfileScreenInitial;
    final UserModel user = state.user!;

    _assignControllerValues(user: user);
    super.initState();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    biographyController.dispose();
    super.dispose();
  }

  void _assignControllerValues({required UserModel user}) {
    firstNameController.text = user.firstName!;
    lastNameController.text = user.lastName!;
    biographyController.text = user.biography!;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Wrap(
        children: [
          Container(
            height: MediaQuery.of(context).size.height - 50,
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
              padding: const EdgeInsets.symmetric(
                vertical: 15,
              ),
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
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 7),
                    child: Row(
                      children: [
                        StyledText(
                          text: 'Edit Profile',
                          color: NexusColors.textColor,
                          fontSize: 20,
                        ),
                        const Spacer(),
                        PopupMenu(
                          onSelected: (value) async {
                            Future<void> handleImageSelection(String message,
                                Function(XFile) onImageSelected) async {
                              final XFile? image =
                                  await ImageSelector.pickImage();
                              if (image != null) {
                                if (context.mounted) {
                                  onImageSelected(image);
                                }
                              } else {
                                if (context.mounted) {
                                  StyledSnackbar.show(
                                      context: context, message: message);
                                }
                              }
                            }

                            switch (value) {
                              case 'Edit Profile Image':
                                await handleImageSelection(
                                  "Profile Image not selected",
                                  (image) => context
                                      .read<ProfileScreenBloc>()
                                      .add(AddProfileImage(image: image)),
                                );
                                break;
                              case 'Edit Background':
                                await handleImageSelection(
                                  "Background Image not selected",
                                  (image) => context
                                      .read<ProfileScreenBloc>()
                                      .add(AddBackgroundImage(image: image)),
                                );
                                break;
                              default:
                            }
                          },
                          items: const [
                            PopupItem(name: 'Edit Profile Image'),
                            PopupItem(name: 'Edit Background'),
                          ],
                          icon: 'dots-circle',
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: BlocBuilder<ProfileScreenBloc, ProfileScreenState>(
                        builder: (context, state) {
                          final currentState = state as ProfileScreenInitial;
                          final UserModel user = currentState.user!;
                          final XFile? profileImage = currentState.profileImage;
                          final XFile? backgroundImage =
                              currentState.backgroundImage;

                          // * Assign values
                          //_assignControllerValues(user: user);

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                  height: 225,
                                  child: Stack(
                                    children: [
                                      _backgroundImage(
                                        backgroundImage: backgroundImage,
                                        context: context,
                                        user: user,
                                      ),
                                      _profileImage(
                                        profileImage: profileImage,
                                        context: context,
                                        user: user,
                                      )
                                    ],
                                  )),
                              const SizedBox(
                                height: 15,
                              ),
                              SizedBox(
                                height: 90,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          StyledText(
                                            text: 'First Name',
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          StyledTextfield(
                                            hintText: 'Enter first name',
                                            controller: firstNameController,
                                            onChanged: (value) {
                                              user.firstName = value.trim();
                                            },
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          StyledText(
                                            text: 'Last Name',
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          StyledTextfield(
                                            hintText: 'Enter last name',
                                            controller: lastNameController,
                                            onChanged: (value) {
                                              user.lastName = value.trim();
                                            },
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              StyledText(
                                text: 'Biography',
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              StyledTextfield(
                                hintText: 'Enter biography',
                                maxlines: 3,
                                controller: biographyController,
                                onChanged: (value) {
                                  user.biography = value.trim();
                                },
                              ),
                              Spacer(),
                              StyledButton(
                                text: 'Confirm Changes',
                                onTap: widget.onConfirm,
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).padding.bottom,
                              )
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _profileImage({
    required XFile? profileImage,
    required UserModel user,
    required BuildContext context,
  }) {
    return Positioned(
      left: 25,
      bottom: 0,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: ShapeDecoration(
              color: NexusColors.backgroundColor,
              shape: SmoothRectangleBorder(
                borderRadius: SmoothBorderRadius(
                  cornerRadius: 15,
                  cornerSmoothing: 0.8,
                ),
                side: BorderSide(
                  color: NexusColors.backgroundColor,
                  width: 1.5,
                ),
              ),
            ),
            child: ClipSmoothRect(
              radius: SmoothBorderRadius(
                cornerRadius: 14,
                cornerSmoothing: 0.8,
              ),
              child: profileImage != null
                  ? Image.file(
                      File(profileImage.path),
                      fit: BoxFit.cover,
                      width: 100,
                      height: 100,
                    )
                  : GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (builder) => ImageSliderBottomSheet(
                            images: [user.profilePic!],
                          ),
                        );
                      },
                      child: CachedNetworkImage(
                        imageUrl: user.profilePic!,
                        fit: BoxFit.cover,
                        width: 100,
                        height: 100,
                        placeholder: (BuildContext context, String url) =>
                            Container(
                          width: 110,
                          height: 110,
                          color: NexusColors.accentColor,
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
            ),
          ),
          profileImage != null
              ? StyledIconButton(
                  icon: 'trash',
                  onTap: () {
                    context.read<ProfileScreenBloc>().add(
                          RemoveBackgroundImage(),
                        );
                  },
                  backgroundColor: const Color.fromRGBO(0, 0, 0, 0.451),
                )
              : const SizedBox()
        ],
      ),
    );
  }

  Widget _backgroundImage({
    required XFile? backgroundImage,
    required UserModel user,
    required BuildContext context,
  }) {
    return Stack(
      alignment: Alignment.center,
      children: [
        ClipSmoothRect(
          radius: SmoothBorderRadius(
            cornerRadius: 15,
            cornerSmoothing: .8,
          ),
          child: backgroundImage != null
              ? Image.file(
                  File(backgroundImage.path),
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                )
              : CachedNetworkImage(
                  width: double.infinity,
                  height: 180,
                  fit: BoxFit.cover,
                  imageUrl: user.backgroundPic!,
                  placeholder: (BuildContext context, String url) => Container(
                    width: double.infinity,
                    height: 180,
                    color: NexusColors.accentColor,
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
        ),
        backgroundImage != null
            ? StyledIconButton(
                icon: 'trash',
                onTap: () {
                  context.read<ProfileScreenBloc>().add(
                        RemoveBackgroundImage(),
                      );
                },
                backgroundColor: Colors.black45,
              )
            : StyledIconButton(
                icon: 'maximize',
                onTap: () {
                  showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    builder: (builder) => ImageSliderBottomSheet(
                      images: [user.backgroundPic!],
                    ),
                  );
                },
                backgroundColor: Colors.black45,
              )
      ],
    );
  }
}
