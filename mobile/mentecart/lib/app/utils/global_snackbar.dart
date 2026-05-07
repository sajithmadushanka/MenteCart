import 'package:flutter/material.dart';

import '../../app/router/app_router.dart';

class GlobalSnackbar {
  static bool _isShowing = false;
  static void show(String message) {
    if (_isShowing) {
      return;
    }

    final context = rootNavigatorKey.currentContext;

    if (context == null) {
      return;
    }

    _isShowing = true;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message))).closed.then((_) {
      _isShowing = false;
    });
  }
}
