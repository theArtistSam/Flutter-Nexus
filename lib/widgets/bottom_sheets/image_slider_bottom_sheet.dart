import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:nexus/widgets/styled_widgets/styled_text.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

// ignore: must_be_immutable
class ImageSliderBottomSheet extends StatelessWidget {
  const ImageSliderBottomSheet({super.key, required this.images});
  final List<String> images;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    return Wrap(
      children: [
        Stack(
          children: [
            SizedBox(
              height: height - 50,
              child: ClipSmoothRect(
                radius: SmoothBorderRadius(
                  cornerRadius: 25,
                  cornerSmoothing: .8,
                ),
                child: PhotoViewGallery.builder(
                  itemCount: images.length,
                  builder: (BuildContext context, int index) {
                    return PhotoViewGalleryPageOptions(
                      minScale: PhotoViewComputedScale.contained * 1,
                      imageProvider: NetworkImage(images[index]),
                    );
                  },
                ),
              ),
            ),
            Positioned(
              top: 15,
              left: width / 2 - 30,
              child: Container(
                width: 60,
                height: 5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0), // Black with full opacity
                      Colors.black.withOpacity(
                        0.7,
                      ), // Black with 0 opacity (transparent)
                    ],
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10 + bottomPadding,
                  ),
                  child: Row(
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
                      const StyledText(
                        text: 'Dunn Oliver',
                        fontSize: 16,
                        color: Colors.white,
                      ),
                      const Spacer(),
                      StyledText(
                        text: 'December 24, 2024',
                        fontSize: 12,
                        color: Colors.white.withOpacity(.7),
                        fontWeight: FontWeight.w500,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
