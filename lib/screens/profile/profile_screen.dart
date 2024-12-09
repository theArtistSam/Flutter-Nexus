import 'package:cached_network_image/cached_network_image.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nexus/blocs/profile_screen_bloc/bloc/profile_screen_bloc.dart';
import 'package:nexus/models/post_model.dart';
import 'package:nexus/models/user_model.dart';
import 'package:nexus/repositories/local_storage_repository.dart';
import 'package:nexus/screens/profile/widgets/profile_edit_bottom_sheet.dart';
import 'package:nexus/utils/constants.dart';
import 'package:nexus/widgets/bottom_sheets/post_bottom_sheet.dart';
import 'package:nexus/widgets/post_tile.dart';
import 'package:nexus/widgets/styled_widgets/styled_icon_button.dart';
import 'package:nexus/widgets/styled_widgets/styled_snackbar.dart';
import 'package:nexus/widgets/styled_widgets/styled_text.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
    required this.userId,
  });

  final String userId;
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final ProfileScreenBloc profileScreenBloc;

  @override
  void initState() {
    profileScreenBloc = ProfileScreenBloc(userId: widget.userId);
    super.initState();
  }

  @override
  void dispose() {
    profileScreenBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topbarHeight = MediaQuery.of(context).padding.top;
    return BlocProvider(
      create: (context) => profileScreenBloc,
      child: Scaffold(
        backgroundColor: NexusColors.isDark
            ? const Color(0XFF0A0A0A)
            : NexusColors.accentColorLight,
        body: SingleChildScrollView(
          child: Column(
            children: [
              BlocBuilder<ProfileScreenBloc, ProfileScreenState>(
                builder: (context, state) {
                  final currentState = state as ProfileScreenInitial;
                  final UserModel? user = currentState.user;

                  return Container(
                    color: NexusColors.backgroundColor,
                    child: Stack(
                      children: [
                        CachedNetworkImage(
                          imageUrl: user?.backgroundPic ?? '',
                          fit: BoxFit.cover,
                          height: 250,
                          width: double.infinity,
                          placeholder: (BuildContext context, String url) =>
                              Container(
                            width: double.infinity,
                            color: NexusColors.accentColor,
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                            25,
                            topbarHeight,
                            25,
                            0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  StyledIconButton(
                                    icon: 'back-arrow',
                                    onTap: () => Navigator.pop(context),
                                    backgroundColor: Colors.black26,
                                    padding: 15,
                                  ),
                                  const Spacer(),
                                  StyledIconButton(
                                    icon: 'pencil-filled',
                                    height: 20,
                                    onTap: () {
                                      bool isConfirmed = false;
                                      final state = (profileScreenBloc.state
                                          as ProfileScreenInitial);
                                      final UserModel user = state.user!;

                                      showModalBottomSheet(
                                          isScrollControlled: true,
                                          context: context,
                                          builder: (context) {
                                            return BlocProvider.value(
                                              value: profileScreenBloc,
                                              child: ProfileEditBottomSheet(
                                                onConfirm: () {
                                                  isConfirmed = true;
                                                  // Add an event to update content
                                                  profileScreenBloc.add(
                                                    UpdateUserCredientials(),
                                                  );
                                                  StyledSnackbar.show(
                                                    context: context,
                                                    message: "Content updated",
                                                  );
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            );
                                          } // Add actual content
                                          ).whenComplete(
                                        () {
                                          if (!isConfirmed) {
                                            profileScreenBloc.add(
                                              RevertChanges(user: user),
                                            );
                                          }
                                        },
                                      );
                                    },
                                    padding: 11.5,
                                    backgroundColor: Colors.black26,
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 90,
                              ),
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
                                  child: CachedNetworkImage(
                                    imageUrl: user?.profilePic ?? '',
                                    fit: BoxFit.cover,
                                    width: 100,
                                    height: 100,
                                    placeholder:
                                        (BuildContext context, String url) =>
                                            Container(
                                      width: double.infinity,
                                      color: NexusColors.accentColor,
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  StyledText(
                                    text:
                                        "${user?.firstName ?? ''} ${user?.lastName ?? ''}",
                                    fontWeight: FontWeight.w600,
                                  ),
                                  const SizedBox(width: 10),
                                  SvgPicture.asset(
                                    'assets/icons/tick-circle.svg',
                                    color: NexusColors.primaryColor,
                                  )
                                ],
                              ),
                              StyledText(
                                text:
                                    "@${user?.email?.split('@').first ?? ''}  • ${DateTimeConversion.formattedDate(datetime: user?.startDate ?? '2022-09-20 10:27:21.240752')}",
                                fontSize: 14,
                                color: NexusColors.secondaryTextColor,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              StyledText(
                                text: "\"${user?.biography ?? ''}\"",
                                fontSize: 14,
                                color: NexusColors.textColor.withOpacity(.7),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 10,
              ),
              BlocBuilder<ProfileScreenBloc, ProfileScreenState>(
                builder: (context, state) {
                  final currentState = state as ProfileScreenInitial;
                  final UserModel? user = currentState.user;

                  return Container(
                    color: NexusColors.backgroundColor,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 15,
                      ),
                      child: Row(
                        children: [
                          ClipOval(
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              width: 50,
                              height: 50,
                              imageUrl: user?.profilePic ?? '',
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                  isScrollControlled: true,
                                  context: context,
                                  builder: (context) => const PostBottomSheet(),
                                );
                              },
                              child: Container(
                                decoration: ShapeDecoration(
                                  shape: SmoothRectangleBorder(
                                    side: BorderSide(
                                      width: 2,
                                      color: NexusColors.borderColor,
                                    ),
                                    borderRadius: SmoothBorderRadius(
                                      cornerRadius: 15,
                                      cornerSmoothing: .8,
                                    ),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 10,
                                  ),
                                  child: Row(
                                    children: [
                                      StyledText(
                                        text: 'Share your thoughts ...',
                                        // COLOR: FIX
                                        color: NexusColors.isDark
                                            ? Colors.white
                                            : NexusColors.primaryColor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      const Spacer(),
                                      SvgPicture.asset(
                                        'assets/icons/gallery-add.svg',
                                        color: NexusColors.isDark
                                            ? Colors.white
                                            : NexusColors.primaryColor,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),
              BlocBuilder<ProfileScreenBloc, ProfileScreenState>(
                builder: (context, state) {
                  final currentState = state as ProfileScreenInitial;
                  Stream<List<PostModel>> posts = currentState.posts;
                  final UserModel? user = currentState.user;

                  return StreamBuilder<List<PostModel>>(
                    stream: posts,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('Error: ${snapshot.error}'),
                        );
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                          child: Text('No content available'),
                        );
                      }
                      List<PostModel> postList = snapshot.data!;

                      return ListView.separated(
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(0),
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: postList.length,
                        separatorBuilder: (BuildContext context, int index) =>
                            const SizedBox(height: 10),
                        itemBuilder: (BuildContext context, int index) {
                          PostModel postModel = postList[index];

                          return PostTile(
                            post: postModel,
                            userId: user?.userId ?? '',
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget _editBottomSheet() {
  //   return   }
}
