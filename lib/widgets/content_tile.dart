// ignore_for_file: deprecated_member_use, file_names


import 'package:cached_network_image/cached_network_image.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nexus/utils/constants.dart';
import 'package:nexus/widgets/styled_widgets/styled_text.dart';

// ignore: must_be_immutable
class ContentTile extends StatelessWidget {
  const ContentTile({
    super.key,
    required this.title,
    required this.thumbnail,
    required this.date,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String date;
  final String icon;
  final String? thumbnail;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          SizedBox(
            height: 170,
            child: ClipSmoothRect(
              radius: SmoothBorderRadius(
                cornerRadius: 15,
                cornerSmoothing: 0.8,
              ),
              child: thumbnail == null
                  ? Image.asset(
                      'assets/images/content.png',
                      width: double.infinity,
                      fit: BoxFit.cover,
                    )
                  : CachedNetworkImage(
                      imageUrl: thumbnail!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      progressIndicatorBuilder: (context, url, progress) =>
                          Center(
                        child: CircularProgressIndicator(
                          value: progress.progress,
                        ),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0), // Start color (0% black)
                    Colors.black.withOpacity(0.5), // End color (90% black)
                  ],
                ),
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
          SizedBox(
            height: 170,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(),
                  StyledText(
                    text: title,
                    fontSize: 18,
                    color: NexusColors.textColorLight,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      StyledText(
                        // text: date,
                        text: DateTimeConversion.formattedDate(datetime: date),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: NexusColors.secondaryTextColorLight,
                      ),
                      const Spacer(),
                      SvgPicture.asset(
                        'assets/icons/$icon.svg',
                        color: NexusColors.secondaryTextColorLight,
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
