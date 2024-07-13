import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus/blocs/support_bloc/bloc/support_bloc.dart';
import 'package:nexus/models/support_model.dart';
import 'package:nexus/utils/constants.dart';
import 'package:nexus/widgets/styled_icon_button.dart';
import 'package:nexus/widgets/styled_text.dart';

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
    supportBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => supportBloc,
      child: Scaffold(
        backgroundColor: NexusColors.accentColorLight,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight + 5),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: AppBar(
              surfaceTintColor: Colors.transparent,
              backgroundColor: NexusColors.accentColorLight,
              leadingWidth: 30,
              leading: Transform.scale(
                scale: 1,
                child: StyledIconButton(
                    icon: 'back-arrow',
                    backgroundColor: NexusColors.accentColorLight,
                    iconColor: NexusColors.primaryColorLight,
                    onTap: () => Navigator.pop(context)),
              ),
              title: StyledText(text: 'Support', fontSize: 24),
              actions: [
                StyledIconButton(
                  isBordered: true,
                  backgroundColor: NexusColors.accentColor,
                  iconColor: NexusColors.primaryColor,
                  padding: 6,
                  icon: 'plus',
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            decoration: const ShapeDecoration(
              color: Colors.white,
              shape: SmoothRectangleBorder(
                borderRadius: SmoothBorderRadius.only(
                  topLeft: SmoothRadius(cornerRadius: 35, cornerSmoothing: 0.8),
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
                      List<SupportModel> issuesList = snapshot.data!;

                      return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: issuesList.length,
                        separatorBuilder: (BuildContext context, int index) =>
                            const SizedBox(height: 15),
                        itemBuilder: (BuildContext context, int index) {
                          SupportModel supportModel = issuesList[index];
                          return supportTile(issue: supportModel);
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
    );
  }

  supportTile({required SupportModel issue}) {
    String lastMessageTime = DateTimeConversion.formattedTime(
        datetime: issue.conversation!.last.timeStamp!);
    String lastMessage = issue.conversation!.last.text!;
    // ! use this for selection redering profile picture and
    // ! user name for the tile
    String senderId = issue.conversation!.last.senderId!;

    Color issueColor(String issue) {
      switch (issue) {
        case "Resolved":
          return const Color(0xFF2B9F03);

        case "Closed":
          return const Color(0xFFB50202);
      }
      return const Color(0xFFF29339);
    }

    return Stack(
      children: [
        Column(
          children: [
            Container(
              decoration: ShapeDecoration(
                color: NexusColors.accentColor,
                shape: const SmoothRectangleBorder(
                  borderRadius: SmoothBorderRadius.all(
                    SmoothRadius(
                      cornerRadius: 12,
                      cornerSmoothing: 0.8,
                    ),
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 10,
                  bottom: 30,
                  left: 10,
                  right: 10,
                ),
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
                          fontWeight: FontWeight.w500,
                          color: NexusColors.textColor.withOpacity(.5),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    StyledText(
                      text: lastMessage,
                      fontSize: 14,
                      color: NexusColors.textColor,
                      fontWeight: FontWeight.w500,
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            )
          ],
        ),
        Positioned(
          left: 10,
          bottom: 0,
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: NexusColors.accentColor,
                  border: Border.all(
                    color: NexusColors.backgroundColor,
                    width: 2,
                  ),
                  borderRadius: const SmoothBorderRadius.all(
                    SmoothRadius(
                      cornerRadius: 100,
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
                          text: issue.issueStatus!,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          // COLOR: FIX
                          color: issueColor(issue.issueStatus!))
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 5),
              Container(
                decoration: BoxDecoration(
                  color: NexusColors.accentColor,
                  border: Border.all(
                    color: NexusColors.backgroundColor,
                    width: 2,
                  ),
                  borderRadius: const SmoothBorderRadius.all(
                    SmoothRadius(
                      cornerRadius: 100,
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
                        text: issue.issueCategory ?? '',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        // COLOR: FIX
                        color: NexusColors.isDark
                            ? Colors.white
                            : NexusColors.primaryColor,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
