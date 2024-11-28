import 'dart:async';
import 'dart:developer';

import 'package:ezeness/presentation/widgets/common/common.dart';
import 'package:flutter/material.dart';

class FutureSender {
  static send<T>(
    BuildContext context, {
    required FutureOr<T> Function() future,
    required void Function(dynamic e) onError,
    required void Function(T value) onSuccess,
  }) async {
    try {
      _showLoader(context);
      final result = await future();
      Navigator.of(context, rootNavigator: true).pop();
      onSuccess(result);
      log("success $result");
    } catch (e) {
      log("error $e");
      Navigator.of(context, rootNavigator: true).pop();
      onError(e);
    }
  }

  static _showLoader(BuildContext context) => showDialog(
        context: context,
        builder: (_) => const PopScope(
          canPop: false,
          child: CenteredCircularProgressIndicator(),
        ),
      );
}
