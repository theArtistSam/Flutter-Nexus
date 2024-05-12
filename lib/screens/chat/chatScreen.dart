import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nexus/utils/constants.dart';
import 'package:nexus/widgets/styledText.dart';
import 'package:nexus/widgets/styledIconButton.dart';
import 'package:nexus/widgets/styledTabs.dart';
import 'package:nexus/widgets/styledTextfield.dart';

// ignore: must_be_immutable
class ChatScreen extends StatelessWidget {
  ChatScreen({super.key});

  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: NexusColors.accentColorLight,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight + 15),
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
              title: StyledText(text: 'Chat with AI', fontSize: 24),
              actions: [
                StyledIconButton(icon: 'menu', onTap: () {}),
              ],
            ),
          ),
        ),
        body: Container(
            decoration: const ShapeDecoration(
              color: Colors.white,
              shape: SmoothRectangleBorder(
                borderRadius: SmoothBorderRadius.only(
                    topLeft:
                        SmoothRadius(cornerRadius: 35, cornerSmoothing: 0.8),
                    topRight:
                        SmoothRadius(cornerRadius: 35, cornerSmoothing: 0.8)),
              ),
            ),
            child: Padding(
                padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                child: Column(children: [
                  StyledTabs(
                    leftTabText: 'Translate',
                    rightTabText: 'Summarize',
                    // isLeftSelected: false,
                  ),
                  const Divider(
                    height: 30,
                    color: NexusColors.dividerColor,
                  ),
                  Expanded(
                    child: ListView.separated(
                      // reverse: true,
                      itemCount: 6, // Number of items
                      separatorBuilder: (BuildContext context, int index) {
                        return const SizedBox(
                            height: 15); // Separator between items
                      },
                      itemBuilder: (BuildContext context, int index) {
                        if (index % 2 == 0) {
                          return userChat(
                              chat:
                                  "What were they eating? It didn't taste like anything she had ever eaten before and although she was famished, she didn't dare ask. She knew the answer would be one she didn't want to hear.");
                        }
                        return aiChat(
                            chat:
                                "وہ کیا کھا رہے تھے؟ اس کا ذائقہ ایسا نہیں تھا جو اس نے پہلے کبھی کھایا ہو اور اگرچہ وہ بھوکی تھی، اس نے پوچھنے کی ہمت نہیں کی۔ وہ جانتی تھی کہ جواب وہی ہوگا جو وہ سننا نہیں چاہتی تھی۔");
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 105,
                  )
                ]))),
        bottomSheet: Container(
          decoration: BoxDecoration(
            color: Colors.white,
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
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: StyledTextfield(
                    icon: null,
                    maxlines: 3,
                    hintText: 'Write text to translate',
                    controller: controller,
                  ),
                ),
                const SizedBox(width: 10),
                StyledIconButton(
                    icon: 'arrow-up',
                    backgroundColor: NexusColors.primaryColorLight,
                    onTap: () => {})
              ],
            ),
          ),
        ));
  }

  userChat({required chat}) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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
          Expanded(
              child: Container(
            decoration: ShapeDecoration(
              color: NexusColors.accentColorLight,
              shape: SmoothRectangleBorder(
                  borderRadius: SmoothBorderRadius(
                      cornerRadius: 15, cornerSmoothing: 0.8)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: StyledText(
                text: chat,
                fontWeight: FontWeight.w500,
              ),
            ),
          )),
        ],
      );

  aiChat({required chat}) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              child: Container(
            decoration: ShapeDecoration(
              color: NexusColors.primaryColorLight,
              shape: SmoothRectangleBorder(
                  borderRadius: SmoothBorderRadius(
                      cornerRadius: 15, cornerSmoothing: 0.8)),
            ),
            child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  chat,
                  style: GoogleFonts.notoNastaliqUrdu(
                    color: NexusColors.textColorLight,
                    height: 2,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.right,
                )),
          )),
          const SizedBox(width: 10),
          ClipOval(
            child: Image.asset(
              'assets/images/profile-picture.png',
              width: 30,
              height: 30,
              fit: BoxFit.cover,
            ),
          ),
        ],
      );
}
