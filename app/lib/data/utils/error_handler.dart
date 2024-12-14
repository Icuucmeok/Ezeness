import 'dart:async';
import 'dart:developer';

import 'dart:io';

import 'package:ezeness/data/utils/errors.dart';
import 'package:ezeness/generated/l10n.dart';
import 'package:ezeness/logic/cubit/app_config/app_config_cubit.dart';
import 'package:ezeness/logic/cubit/session_controller/session_controller_cubit.dart';
import 'package:ezeness/presentation/utils/app_toast.dart';
import 'package:ezeness/presentation/widgets/common/error_widgets.dart';
import 'package:flutter/material.dart';

import 'package:provider/src/provider.dart';

import '../../presentation/utils/app_snackbar.dart';

class ErrorHandler<T> {
  final dynamic exception;
  final StackTrace? stackTrace;
  ErrorHandler({required this.exception, this.stackTrace}) {
    log('exception ' + exception.toString());
    log(
      'stack trace  ' + stackTrace.toString(),
    );
  }

  Exception rethrowError() {
    final e = exception;
    if (e is SocketException) {
      return NoInternetConnectionException<T>(
        message: S.current.noInternetConnection,
      );
    } else if (e is TimeoutException) {
      return NoInternetConnectionException<T>(
        message: S.current.noInternetConnection,
      );
    } else if (e is NoInternetConnectionException<T>) {
      return e;
    } else if (e is ServerException) {
      return ServerException<T>(
        message: e.message,
      );
    } else if (e is ForceUpdate) {
      //TODO: HANDLE FORCE UPDATE
    } else if (e is AppUnderMaintenance) {
      //TODO: HANDLE APP UNDER MAINTAINECE
    } else if (e is SessionExpiredException) {
      return e;
    } else if (e is ParsingException) {
      log('\n');
      log("can not parse response : ${e.message} ");
      log("stack : " + e.stack!);
      log('\n');
      return UnknownException<T>(
        message: S.current.anErrorOccured,
      );
    }
    return UnknownException<T>(
      message: S.current.anErrorOccured,
    );
  }

  Widget buildErrorWidget(
      {required BuildContext context,
      required VoidCallback retryCallback,
      TextStyle? textStyle}) {
    if (exception is NoInternetConnectionException) {
      return ButtonErrorWidget(
        textStyle: textStyle,
        onPressed: retryCallback,
        message: exception.message,
      );
    }
    if (exception is ServerException) {
      return ButtonErrorWidget(
        textStyle: textStyle,
        onPressed: retryCallback,
        message: exception.message,
      );
    } else if (exception is SessionExpiredException) {
      context
          .read<SessionControllerCubit>()
          .signOut(context.read<AppConfigCubit>());
      AppToast(message: exception.message).show();
      return LabelErrorWidget(message: exception.message);
    } else if (exception is UnknownException) {
      return ButtonErrorWidget(
        textStyle: textStyle,
        onPressed: retryCallback,
        message: exception.message,
      );
    }
    return ButtonErrorWidget(
      textStyle: textStyle,
      enableButton: false,
      onPressed: retryCallback,
    );
  }

  showErrorSnackBar({required BuildContext context}) {
    if (exception is SessionExpiredException) {
      handleError(context);
    }
    if (exception is ServerException ||
        exception is NoInternetConnectionException ||
        exception is UnknownException) {
      AppSnackBar(message: exception.message, context: context)
          .showErrorSnackBar();
    }
  }

  showErrorToast({required BuildContext context}) {
    if (exception is SessionExpiredException) {
      handleError(context);
    }
    if (exception is ServerException ||
        exception is NoInternetConnectionException ||
        exception is UnknownException) {
      AppToast(message: exception.message).show();
    }
  }

  String getErrorMessage() {
    if (exception is NoInternetConnectionException) {
      return (exception as NoInternetConnectionException).message;
    }
    if (exception is ServerException) {
      return (exception as ServerException).message;
    }
    return S.current.anErrorOccured;
  }

  void handleError(BuildContext context, {Function? sessionExpiredOverride}) {
    final e = exception;
    if (e is NoInternetConnectionException ||
        e is ServerException ||
        e is UnknownException) {
      AppToast(message: e.message).show();
      return;
    } else if (e is SessionExpiredException) {
      if (sessionExpiredOverride == null) {
        context
            .read<SessionControllerCubit>()
            .signOut(context.read<AppConfigCubit>());
        AppToast(message: exception.message).show();
      } else {
        sessionExpiredOverride();
      }

      return;
    }
    AppToast(
      message: S.current.anErrorOccured,
    ).show();
  }
}
