import 'package:flutter/material.dart';

import '../constants/utils.dart';

class LoaderService {

  /// Private constructor
  LoaderService._internal();

  /// Create the single instance (static final instance)
  static final LoaderService instance = LoaderService._internal();

  /// [factory] constructors don't always create a new instance of the class (factory returns the instance)
  factory LoaderService() => instance;

  static late OverlayEntry _overlayEntry;
  static bool _isVisible = false;

  static void show(BuildContext context) {
    if (_isVisible) return;

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          ModalBarrier(
            color: Colors.white.withValues(alpha: 0.5),
            dismissible: false,
          ),
          Center(child: commonLoader()),
        ],
      ),
    );

    Overlay.of(context, rootOverlay: true).insert(_overlayEntry);
    _isVisible = true;
  }

  static void hide() {
    if (!_isVisible) return;
    _overlayEntry.remove();
    _isVisible = false;
  }
}
