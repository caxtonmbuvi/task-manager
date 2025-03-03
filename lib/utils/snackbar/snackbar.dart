
import 'package:flutter/material.dart';
import 'package:task_manager/utils/snackbar/widgets/custom_error.dart';
import 'package:task_manager/utils/snackbar/widgets/custom_success.dart';
import 'package:task_manager/utils/snackbar/widgets/slide_in.dart';

OverlayEntry? _currentOverlayEntry;

void showTopSnackBar(
  BuildContext context,
  String message, {
  required bool isSuccess,
}) {
  // Remove any existing overlay to prevent overlap.
  _currentOverlayEntry?.remove();

  // Define the new overlay entry.
  _currentOverlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: MediaQuery.of(context).viewInsets.top + 50.0,
      left: 20,
      right: 20,
      child: Material(
        color: Colors.transparent,
        child: SlideIn(
          child: isSuccess
              ? CustomSuccess(message: message)
              : CustomError(message: message),
        ),
      ),
    ),
  );

  // Insert the new overlay.
  final overlay = Overlay.of(context);
  overlay.insert(_currentOverlayEntry!);

  // Schedule removal of the overlay.
  Future.delayed(
    const Duration(seconds: 3),
    () {
      _currentOverlayEntry?.remove();
      _currentOverlayEntry = null;
    },
  );
}
