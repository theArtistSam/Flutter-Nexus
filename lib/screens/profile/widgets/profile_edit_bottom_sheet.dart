import 'package:cached_network_image/cached_network_image.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nexus/blocs/profile_screen_bloc/bloc/profile_screen_bloc.dart';
import 'package:nexus/models/user_model.dart';
import 'package:nexus/utils/constants.dart';
import 'package:nexus/widgets/popup_menu.dart';
import 'package:nexus/widgets/styled_widgets/styled_button.dart';
import 'package:nexus/widgets/styled_widgets/styled_snackbar.dart';
import 'package:nexus/widgets/styled_widgets/styled_text.dart';
import 'package:nexus/widgets/styled_widgets/styled_textfield.dart';

class ProfileEditBottomSheet extends StatefulWidget {
  const ProfileEditBottomSheet({super.key});

  @override
  State<ProfileEditBottomSheet> createState() => _ProfileEditBottomSheetState();
}

class _ProfileEditBottomSheetState extends State<ProfileEditBottomSheet> {
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController biographyController;
  @override
  void initState() {
    // TODO: implement initState
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    biographyController = TextEditingController();

    final state =
        (context.read<ProfileScreenBloc>().state as ProfileScreenInitial);
    final String firstName = state.user?.firstName ?? '';
    final String lastName = state.user?.lastName ?? '';
    final String biographyName = state.user?.biography ?? '';

    firstNameController.text = firstName;
    lastNameController.text = lastName;
    biographyController.text = biographyName;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    firstNameController.dispose();
    lastNameController.dispose();
    biographyController.dispose();
    super.dispose();
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
                            switch (value) {
                              case 'Edit thumbnail':
                                // Use image picker to pick the image from gallery
                                final XFile? image =
                                    await ImageSelector.pickImage();

                                if (image != null) {
                                  if (context.mounted) {
                                    // context.read<ContentScreenBloc>().add(
                                    //       AddThumbnail(file: image),
                                    //     );
                                  }
                                } else {
                                  if (context.mounted) {
                                    StyledSnackbar.show(
                                      context: context,
                                      message: "Image not selected",
                                    );
                                  }
                                }
                                break;
                              default:
                            }
                          },
                          items: const [
                            PopupItem(name: 'Edit Profile'),
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
                          final UserModel? user =
                              (state as ProfileScreenInitial).user;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 225,
                                child: Stack(
                                  children: [
                                    ClipSmoothRect(
                                      radius: SmoothBorderRadius(
                                        cornerRadius: 15,
                                        cornerSmoothing: .8,
                                      ),
                                      child: CachedNetworkImage(
                                        width: double.infinity,
                                        height: 180,
                                        fit: BoxFit.cover,
                                        imageUrl: user?.backgroundPic ?? '',
                                        placeholder: (BuildContext context,
                                                String url) =>
                                            Container(
                                          width: double.infinity,
                                          height: 180,
                                          color: NexusColors.accentColor,
                                        ),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                      ),
                                    ),
                                    Positioned(
                                      left: 25,
                                      bottom: 0,
                                      child: Container(
                                        decoration: ShapeDecoration(
                                          color: NexusColors.backgroundColor,
                                          shape: SmoothRectangleBorder(
                                            borderRadius: SmoothBorderRadius(
                                              cornerRadius: 15,
                                              cornerSmoothing: 0.8,
                                            ),
                                            side: BorderSide(
                                              color:
                                                  NexusColors.backgroundColor,
                                              width: 1.5,
                                            ),
                                          ),
                                        ),
                                        child: ClipSmoothRect(
                                          radius: SmoothBorderRadius(
                                            cornerRadius: 14,
                                            cornerSmoothing: 0.8,
                                          ),
                                          child: CachedNetworkImage(
                                            imageUrl: user?.profilePic ?? '',
                                            fit: BoxFit.cover,
                                            width: 100,
                                            height: 100,
                                            placeholder: (BuildContext context,
                                                    String url) =>
                                                Container(
                                              width: 110,
                                              height: 110,
                                              color: NexusColors.accentColor,
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(Icons.error),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
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
                              ),
                              Spacer(),
                              StyledButton(
                                text: 'Confirm Changes',
                                onTap: () {},
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
}
