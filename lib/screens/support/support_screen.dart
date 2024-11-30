import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus/blocs/support_bloc/bloc/support_bloc.dart';
import 'package:nexus/models/support_model.dart';
import 'package:nexus/screens/support/support_chat_screen.dart';
import 'package:nexus/screens/support/widgets/support_category_bottom_sheet.dart';
import 'package:nexus/utils/constants.dart';
import 'package:nexus/widgets/styled_widgets/styled_icon_button.dart';
import 'package:nexus/widgets/styled_widgets/styled_text.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  late SupportBloc supportBloc;
  @override
  void initState() {
    supportBloc = SupportBloc();
    supportBloc.add(FetchIssues());
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    supportBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return BlocProvider(
      create: (context) => supportBloc,
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
              // COLOR: FIX
              backgroundColor: NexusColors.isDark
                  ? const Color(0XFF0A0A0A)
                  : NexusColors.accentColorLight,
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
              title: StyledText(
                text: 'Support',
                color: NexusColors.textColor,
                fontSize: 24,
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
                  padding: 6,
                  icon: 'plus',
                  onTap: () {
                    showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      builder: (context) => const SupportCategoryBottomSheet(),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: height - (kToolbarHeight + 5) - 53,
            ),
            child: DecoratedBox(
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
                padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                child: BlocBuilder<SupportBloc, SupportState>(
                  builder: (context, state) {
                    Stream<List<SupportModel>> issues =
                        (state as SupportInitial).issues;

                    return StreamBuilder<List<SupportModel>>(
                      stream: issues,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text('Error: ${snapshot.error}'),
                          );
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const Center(
                            child: Text('No issues yet'),
                          );
                        }
                        List<SupportModel> issuesList = snapshot.data!;

                        return ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: issuesList.length,
                          separatorBuilder: (BuildContext context, int index) =>
                              const SizedBox(height: 15),
                          itemBuilder: (BuildContext context, int index) {
                            SupportModel supportModel = issuesList[index];
                            print(issuesList.length);
                            return supportTile(
                              issue: supportModel,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (builder) => SupportChatScreen(
                                      issue: supportModel,
                                    ),
                                  ),
                                );
                              },
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
        ),
      ),
    );
  }

  supportTile({required SupportModel issue, required VoidCallback onTap}) {
    String lastMessageTime = DateTimeConversion.getTime(
      datetime: issue.conversation!.last.timeStamp!,
    );
    bool isNewIssue = issue.conversation!.isEmpty;
    bool isMessage = issue.conversation!.last.messageType == 'text';
    String lastMessage =
        isMessage ? issue.conversation!.last.text! : '🖼️ Sent an image*';

    if (isNewIssue) {
      lastMessage = 'New issue*';
    }

    // ! use this for selection redering profile picture and
    // ! user name for the tile
    String senderId = issue.conversation!.last.senderId!;

    Color issueColor(String issue) {
      switch (issue) {
        case "Resolved":
          return NexusColors.resolvedColor;

        case "Closed":
          return NexusColors.closedColor;
      }
      return NexusColors.pendingColor;
    }

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            decoration: ShapeDecoration(
              color: NexusColors.accentColor,
              shape: const SmoothRectangleBorder(
                borderRadius: SmoothBorderRadius.all(
                  SmoothRadius(
                    cornerRadius: 15,
                    cornerSmoothing: 0.8,
                  ),
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          ClipOval(
                            child: Image.asset(
                              'assets/images/profile-picture.png',
                              width: 30,
                              height: 30,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 10),
                          StyledText(
                            text: senderId == 'bpReSCGFYZY9k1TuuCdW'
                                ? 'Admin'
                                : 'Dunn Oliver',
                            fontSize: 16,
                            color: NexusColors.textColor,
                          ),
                          const Spacer(),
                          StyledText(
                            text: lastMessageTime,
                            fontSize: 12,
                            color: NexusColors.secondaryTextColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      StyledText(
                        text: lastMessage,
                        fontSize: 14,
                        color: NexusColors.secondaryTextColor,
                        fontWeight: FontWeight.w500,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: 0,
                  thickness: 1.5,
                  color: NexusColors.backgroundColor,
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      StyledText(
                        text: "● ${issue.issueStatus!}",
                        fontSize: 12,
                        color: issueColor(issue.issueStatus!),
                        fontWeight: FontWeight.w500,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      StyledText(
                        text: "● ${issue.issueCategory!}",
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        // COLOR: FIX
                        color: NexusColors.isDark
                            ? NexusColors.textColor
                            : NexusColors.primaryColorLight,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
