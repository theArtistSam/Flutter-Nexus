import 'package:flutter/material.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:nexus/utils/constants.dart';
import 'package:nexus/widgets/styled_widgets/styled_text.dart';

class StyledSnackbar {
  static void show({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) => _SnackbarWidget(
        message: message,
        duration: duration,
      ),
    );

    Overlay.of(context).insert(overlayEntry);

    Future.delayed(duration + const Duration(milliseconds: 300), () {
      overlayEntry.remove();
    });
  }
}

class _SnackbarWidget extends StatefulWidget {
  final String message;
  final Duration duration;

  const _SnackbarWidget({
    required this.message,
    required this.duration,
  });

  @override
  State<_SnackbarWidget> createState() => __SnackbarWidgetState();
}

class __SnackbarWidgetState extends State<_SnackbarWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _animationOffset;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _animationOffset = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top,
      left: 0,
      right: 0,
      child: SlideTransition(
        position: _animationOffset,
        child: Material(
          color: Colors.transparent,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
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
              padding: const EdgeInsets.all(20),
              child: StyledText(
                text: widget.message,
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
