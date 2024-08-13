import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nexus/blocs/support_chat_bloc/bloc/support_chat_bloc.dart';
import 'package:nexus/models/support_model.dart';
import 'package:nexus/utils/constants.dart';
import 'package:nexus/widgets/datetime_tile.dart';
import 'package:nexus/widgets/bottom_sheets/image_slider_bottom_sheet.dart';
import 'package:nexus/widgets/styled_widgets/styled_icon_button.dart';
import 'package:nexus/widgets/styled_widgets/styled_snackbar.dart';
import 'package:nexus/widgets/styled_widgets/styled_text.dart';
import 'package:nexus/widgets/styled_widgets/styled_textfield.dart';

// ignore: must_be_immutable
class SupportChatScreen extends StatefulWidget {
  SupportChatScreen({super.key, required this.issue});
  SupportModel issue;
  @override
  State<SupportChatScreen> createState() => _SupportChatScreenState();
}

class _SupportChatScreenState extends State<SupportChatScreen> {
  late SupportChatBloc supportChatBloc;
  late TextEditingController textEditingController;
  late ScrollController scrollController;

  @override
  void initState() {
    textEditingController = TextEditingController();
    scrollController = ScrollController();
    supportChatBloc = SupportChatBloc();
    supportChatBloc.add(FetchMessages(documentId: widget.issue.issueId!));

    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    scrollController.dispose();
    supportChatBloc.close();
    super.dispose();
  }

  void _scrollToBottom() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Color _issueColor({required String issueStatus}) {
    switch (issueStatus) {
      case 'Closed':
        return NexusColors.closedColor;
      case 'Pending':
        return NexusColors.pendingColor;
      default:
        return NexusColors.resolvedColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    final double bottomPadding = MediaQuery.of(context).padding.bottom;
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    // Grid view count for products
    int gridCount() {
      if (width > 125) {
        return (width ~/ 125).toInt();
      }
      return 1;
    }

    return BlocProvider(
      create: (context) => supportChatBloc,
      child: Scaffold(
        // COLOR: FIX
        backgroundColor: NexusColors.isDark
            ? const Color(0XFF0A0A0A)
            : NexusColors.accentColorLight,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight + 5),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: AppBar(
              surfaceTintColor: Colors.transparent,
              backgroundColor: NexusColors.isDark
                  ? const Color(0XFF0A0A0A)
                  : NexusColors.accentColorLight,
              automaticallyImplyLeading: false,
              leadingWidth: 30,
              leading: Transform.scale(
                scale: 1,
                child: StyledIconButton(
                  icon: 'back-arrow',
                  backgroundColor: NexusColors.isDark
                      ? const Color(0XFF0A0A0A)
                      : NexusColors.accentColorLight,
                  // COLOR: FIX
                  iconColor: NexusColors.isDark
                      ? Colors.white
                      : NexusColors.primaryColorLight,
                  onTap: () => Navigator.pop(context),
                ),
              ),
              title: Row(
                children: [
                  ClipOval(
                    child: Image.asset(
                      'assets/images/profile-picture.png',
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      StyledText(
                        text: 'Admin',
                        fontSize: 16,
                        color: NexusColors.textColor,
                      ),
                      Row(
                        children: [
                          StyledText(
                            text: widget.issue.issueStatus!,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: _issueColor(
                              issueStatus: widget.issue.issueStatus!,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                StyledIconButton(
                  isBordered: true,
                  backgroundColor: NexusColors.isDark
                      ? const Color(0XFF0A0A0A)
                      : NexusColors.accentColor,
                  // COLOR: FIX
                  iconColor: NexusColors.isDark
                      ? Colors.white
                      : NexusColors.primaryColor,
                  // padding: 6,
                  height: 20,
                  icon: 'folder-minus',
                  onTap: () {
                    // *See if it can be fixed!
                    // *Still couldn't figure out
                    supportChatBloc
                        .add(FetchMessages(documentId: widget.issue.issueId!));

                    showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      builder: (context) => BlocProvider.value(
                        value: supportChatBloc,
                        child: createImagesBottomSheet(
                          height: height,
                          gridCount: gridCount(),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        body: SingleChildScrollView(
          controller: scrollController,
          child: Container(
            decoration: ShapeDecoration(
              color: NexusColors.backgroundColor,
              shape: const SmoothRectangleBorder(
                borderRadius: SmoothBorderRadius.only(
                  topLeft: SmoothRadius(
                    cornerRadius: 35,
                    cornerSmoothing: 0.8,
                  ),
                  topRight: SmoothRadius(
                    cornerRadius: 35,
                    cornerSmoothing: 0.8,
                  ),
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                top: 5,
                bottom: 85,
                right: 20,
                left: 20,
              ),
              child: BlocBuilder<SupportChatBloc, SupportChatState>(
                builder: (context, state) {
                  Stream<List<Message>> conversation =
                      (state as SupportChatInitial).conversation;

                  return StreamBuilder<List<Message>>(
                    stream: conversation,
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
                          child: Text('No issues yet'),
                        );
                      }
                      List<Message> messageList = snapshot.data!;

                      // Scroll to bottom after messages are loaded
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _scrollToBottom();
                      });

                      return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: messageList.length,
                        separatorBuilder: (BuildContext context, int index) =>
                            const SizedBox(height: 5),
                        itemBuilder: (BuildContext context, int index) {
                          Message message = messageList[index];
                          bool isLast = index == messageList.length - 1;
                          String adminId = 'bpReSCGFYZY9k1TuuCdW';

                          // *Render admin tile
                          bool isAdmin = messageList[index].senderId == adminId;
                          // *if next message is from admin then user is last
                          bool isUserLast = isLast ||
                              messageList[index + 1].senderId == adminId;

                          bool isTimeStampRequired = index == 0 ||
                              DateTimeConversion.isDifferentDay(
                                index: index,
                                messageList: messageList,
                                message: message,
                              );

                          print("$isTimeStampRequired :: ${message.text}");

                          if (isAdmin) {
                            return adminChat(
                              message: message,
                              isLast: !isUserLast || isLast,
                              isTimeStampRequired: isTimeStampRequired,
                            );
                          }
                          return userChat(
                            message: message,
                            isLast: isUserLast || isLast,
                            isTimeStampRequired: isTimeStampRequired,
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ),
        bottomSheet: widget.issue.issueStatus == 'Pending'
            ? Container(
                decoration: BoxDecoration(
                  color: NexusColors.backgroundColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      offset: const Offset(0, 0), // x, y values
                      blurRadius: 25,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      15,
                      10,
                      15,
                      10 + bottomPadding,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        StyledIconButton(
                          isBordered: true,
                          backgroundColor: NexusColors.backgroundColor,
                          // COLOR: FIX
                          iconColor: NexusColors.isDark
                              ? Colors.white
                              : NexusColors.primaryColor,
                          // padding: 6,
                          height: 20,
                          icon: 'gallery-add',
                          onTap: () async {
                            final XFile? image =
                                await ImageSelector.pickImage();
                            if (image != null) {
                              supportChatBloc.add(SendImageMessage(
                                documentId: widget.issue.issueId!,
                                senderId: widget.issue.userId!,
                                file: image,
                              ));
                            } else {
                              if (context.mounted) {
                                StyledSnackbar.show(
                                  context: context,
                                  message: 'Image not selected',
                                );
                              }
                            }
                          },
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: StyledTextfield(
                            maxlines: 3,
                            // FOR NOW LET"S KEEP IT SUMMARIZE
                            hintText: 'Describe your issue..',
                            controller: textEditingController,
                          ),
                        ),
                        const SizedBox(width: 10),
                        StyledIconButton(
                          icon: 'arrow-up',
                          backgroundColor: textEditingController.text.isEmpty
                              ? NexusColors.primaryColor.withOpacity(0.5)
                              : NexusColors.primaryColor,
                          onTap: () {
                            if (textEditingController.text.isNotEmpty) {
                              String message =
                                  textEditingController.text.trim();
                              supportChatBloc.add(
                                SendTextMessage(
                                  message: message,
                                  documentId: widget.issue.issueId!,
                                  senderId: widget.issue.userId!,
                                ),
                              );
                              textEditingController.text = '';
                            }
                          },
                        )
                      ],
                    )),
              )
            : const SizedBox(),
      ),
    );
  }

  adminChat({
    required Message message,
    required bool isLast,
    required isTimeStampRequired,
  }) {
    String status = message.status!.isSeen == true ? 'Seen' : 'Sent';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        isTimeStampRequired
            ? DatetimeTile(
                time: message.timeStamp!,
              )
            : const SizedBox(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            isLast
                ? Padding(
                    padding: const EdgeInsets.only(right: 10.0, bottom: 27),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/profile-picture.png',
                        width: 30,
                        height: 30,
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                : const SizedBox(
                    width: 40,
                  ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  message.messageType == 'text'
                      ? Padding(
                          padding: const EdgeInsets.only(right: 40.0),
                          child: Container(
                            decoration: ShapeDecoration(
                              color: NexusColors.primaryColor,
                              shape: SmoothRectangleBorder(
                                borderRadius: SmoothBorderRadius(
                                  cornerRadius: 15,
                                  cornerSmoothing: 0.8,
                                ),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: StyledText(
                                text: message.text!,
                                fontSize: 14,
                                color: NexusColors.textColorLight,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.only(right: 40.0),
                          child: ClipSmoothRect(
                            radius: const SmoothBorderRadius.all(
                              SmoothRadius(
                                cornerRadius: 10,
                                cornerSmoothing: 0.8,
                              ),
                            ),
                            child: Image.network(
                              message.imageLink!,
                              width: double.infinity,
                            ),
                          ),
                        ),
                  isLast
                      ? Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: StyledText(
                            text: "$status • ${DateTimeConversion.formattedTime(
                              datetime: message.timeStamp!,
                            )} ",
                            fontSize: 12,
                            color: NexusColors.secondaryTextColor,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: isLast ? 15 : 0),
      ],
    );
  }

  userChat({
    required Message message,
    required bool isLast,
    required isTimeStampRequired,
  }) {
    String status = message.status!.isSeen == true ? 'Seen' : 'Sent';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        isTimeStampRequired
            ? DatetimeTile(
                time: message.timeStamp!,
              )
            : const SizedBox(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  message.messageType == 'text'
                      ? Padding(
                          padding: const EdgeInsets.only(left: 40),
                          child: Container(
                            decoration: ShapeDecoration(
                              color: NexusColors.accentColor,
                              shape: SmoothRectangleBorder(
                                borderRadius: SmoothBorderRadius(
                                  cornerRadius: 15,
                                  cornerSmoothing: 0.8,
                                ),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: StyledText(
                                text: message.text!,
                                fontSize: 14,
                                color: NexusColors.textColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.only(left: 40.0),
                          child: ClipSmoothRect(
                            radius: const SmoothBorderRadius.all(
                              SmoothRadius(
                                cornerRadius: 15,
                                cornerSmoothing: 0.8,
                              ),
                            ),
                            child: Image.network(
                              message.imageLink!,
                              width: double.infinity,
                            ),
                          ),
                        ),
                  isLast
                      ? Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: StyledText(
                            text: "${DateTimeConversion.formattedTime(
                              datetime: message.timeStamp!,
                            )} • $status",
                            fontSize: 12,
                            color: NexusColors.secondaryTextColor,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
            ),
            // * Let's keep this for now and we'll see if it's required
            // isLast
            //     ? Padding(
            //         padding: const EdgeInsets.only(left: 10.0, bottom: 27),
            //         child: ClipOval(
            //           child: Image.asset(
            //             'assets/images/profile-picture.png',
            //             width: 30,
            //             height: 30,
            //             fit: BoxFit.cover,
            //           ),
            //         ),
            //       )
            //     : const SizedBox(
            //         width: 40,
            //       ),
          ],
        ),
        SizedBox(height: isLast ? 15 : 0),
      ],
    );
  }

  Widget createImagesBottomSheet({
    required double height,
    required int gridCount,
  }) {
    return Wrap(
      children: [
        Container(
          height: height - 40,
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
                      borderRadius: BorderRadius.circular(20),
                      color: NexusColors.borderColor,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                StyledText(
                  text: 'Images',
                  color: NexusColors.textColor,
                  fontSize: 20,
                ),
                const SizedBox(height: 15),
                Expanded(
                  child: BlocBuilder<SupportChatBloc, SupportChatState>(
                    bloc: supportChatBloc,
                    builder: (context, state) {
                      Stream<List<Message>> conversation =
                          (state as SupportChatInitial).conversation;

                      return StreamBuilder<List<Message>>(
                        stream: conversation,
                        builder: (context, snapshot) {
                          print(
                              "StreamBuilder snapshot: ${snapshot.connectionState}");
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            print("StreamBuilder error: ${snapshot.error}");
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            print("StreamBuilder no data");
                            return Center(
                              child: StyledText(
                                text: 'No content available',
                                fontSize: 14,
                                color: NexusColors.textColor,
                              ),
                            );
                          }

                          List<Message> conversation = snapshot.data!;

                          List<String> imageList = conversation
                              .where(
                                  (message) => message.messageType == 'image')
                              .map((message) => message.imageLink!)
                              .toList();

                          if (imageList.isEmpty) {
                            return Center(
                              child: StyledText(
                                text: 'No images available',
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: NexusColors.secondaryTextColor,
                              ),
                            );
                          }

                          return MasonryGridView.count(
                            crossAxisCount: gridCount,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            itemCount: imageList.length,
                            itemBuilder: (context, index) {
                              // print(
                              //     "Image message: ${imageList[index].toJson()}");
                              return ClipSmoothRect(
                                radius: const SmoothBorderRadius.all(
                                  SmoothRadius(
                                    cornerRadius: 10,
                                    cornerSmoothing: 0.8,
                                  ),
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet(
                                      isScrollControlled: true,
                                      context: context,
                                      builder: (context) =>
                                          ImageSliderBottomSheet(
                                        images: imageList,
                                      ),
                                    );
                                  },
                                  child: Container(
                                    color: NexusColors.accentColor,
                                    height: 125,
                                    child: Image.network(
                                      imageList[index],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
