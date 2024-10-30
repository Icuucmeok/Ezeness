import 'dart:io';
import 'dart:ui';
import 'package:ezeness/data/models/user/user.dart';
import 'package:ezeness/logic/cubit/play_list/cubit/play_list_cubit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:animations/animations.dart';
import 'package:ezeness/generated/l10n.dart';
import 'package:ezeness/logic/cubit/report/report_cubit.dart';
import 'package:ezeness/presentation/utils/helpers.dart';
import 'package:ezeness/res/app_res.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import '../../data/models/post/post.dart';
import '../../data/utils/error_handler.dart';
import '../../logic/cubit/app_config/app_config_cubit.dart';
import '../../logic/cubit/session_controller/session_controller_cubit.dart';
import '../widgets/common/common.dart';
import 'app_snackbar.dart';
import 'app_toast.dart';

class AppDialog {
  AppDialog._();
  static late BuildContext appDialogContext;
  static dynamic showMainAppDialog<T>({
    required BuildContext context,
    required String title,
    required Widget content,
  }) {
    return showModal(
        context: context,
        configuration: const FadeScaleTransitionConfiguration(
            barrierColor: Colors.black12),
        filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
        builder: (context) {
          appDialogContext = context;
          return AlertDialog(
            scrollable: true,
            titlePadding: EdgeInsets.all(0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: Container(
              padding: EdgeInsets.all(Constants.mainPadding),
              decoration: const BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(15.0),
                  )),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(title,
                        style: Theme.of(context).textTheme.bodyLarge),
                  ),
                  IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(Icons.clear))
                ],
              ),
            ),
            content: content,
          );
        });
  }

  static showLoadingDialog({required BuildContext context}) {
    return showModal(
        context: context,
        configuration: const FadeScaleTransitionConfiguration(
          barrierColor: Colors.black12,
          barrierDismissible: false,
        ),
        filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
        builder: (context) {
          appDialogContext = context;
          return Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(15),
            ),
            child: CenteredCircularProgressIndicator(),
          );
        });
  }

  static dynamic showConfirmationDialog<T>({
    required BuildContext context,
    required VoidCallback onConfirm,
    String? message,
    String? content,
  }) {
    return showModal(
        context: context,
        configuration: const FadeScaleTransitionConfiguration(
            barrierColor: Colors.black12),
        filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
        builder: (context) {
          appDialogContext = context;
          return AlertDialog(
            scrollable: true,
            titlePadding: EdgeInsets.all(0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: Container(
              padding: EdgeInsets.all(Constants.mainPadding),
              decoration: const BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(15.0),
                  )),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(message ?? S.current.areYouSure,
                        style: Theme.of(context).textTheme.bodyLarge),
                  ),
                  IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(Icons.clear))
                ],
              ),
            ),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (content != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 14),
                    child: Text(
                      content,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: CustomElevatedButton(
                        withBorderRadius: true,
                        backgroundColor: AppColors.primaryColor,
                        onPressed: () {
                          Navigator.pop(context);
                          onConfirm();
                        },
                        child: Text(
                          S.current.confirm,
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge
                              ?.copyWith(
                                  fontSize: 15.sp, color: AppColors.whiteColor),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: CustomOutlineButton(
                        withBorderRadius: true,
                        bgColor: Colors.transparent,
                        textColor: AppColors.primaryColor,
                        borderColor:
                            Theme.of(context).primaryColorDark.withOpacity(0.5),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        labelText: S.current.cancel,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }

  static closeAppDialog() {
    Navigator.of(appDialogContext).pop();
  }

  static dynamic showDeleteAccountDialog<T>({required BuildContext context}) {
    final _keyForm = GlobalKey<FormState>();
    final TextEditingController passwordController = TextEditingController();
    return showModal(
        context: context,
        configuration: const FadeScaleTransitionConfiguration(
            barrierColor: Colors.black12),
        filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
        builder: (context) {
          appDialogContext = context;
          return AlertDialog(
            scrollable: true,
            titlePadding: EdgeInsets.all(0),
            backgroundColor: Theme.of(context).brightness == Brightness.dark
                ? AppColors.darkColor
                : AppColors.whiteColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: Container(
              padding: EdgeInsets.all(Constants.mainPadding),
              decoration: const BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(15.0),
                  )),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(S.current.areYouSureDeleteAccount,
                        style: Theme.of(context).textTheme.bodyLarge),
                  ),
                  IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(Icons.clear))
                ],
              ),
            ),
            content:
                BlocConsumer<SessionControllerCubit, SessionControllerState>(
                    listener: (context, state) {
              if (state is SessionControllerDeleteAccountDone) {
                Navigator.pop(context);
                context
                    .read<SessionControllerCubit>()
                    .signOut(context.read<AppConfigCubit>());
              }
              if (state is SessionControllerError) {
                ErrorHandler(exception: state.exception)
                    .showErrorToast(context: context);
              }
            }, builder: (context, state) {
              return Form(
                key: _keyForm,
                child: Column(
                  children: [
                    EditTextField(
                      controller: passwordController,
                      label: S.current.password,
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: CustomElevatedButton(
                            backgroundColor: Colors.red,
                            borderColor: Colors.red,
                            onPressed: () {
                              if (!_keyForm.currentState!.validate()) {
                                return;
                              }
                              context
                                  .read<SessionControllerCubit>()
                                  .deleteAccount(
                                      password: passwordController.text);
                            },
                            child: Text(S.current.confirm,
                                style: Theme.of(context)
                                    .textTheme
                                    .displayLarge
                                    ?.copyWith(
                                        fontSize: 15.sp, color: Colors.white)),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: CustomOutlineButton(
                            borderRadius: 100,
                            bgColor: Colors.transparent,
                            withBorderRadius: true,
                            textColor: AppColors.primaryColor,
                            borderColor: Theme.of(context)
                                .primaryColorDark
                                .withOpacity(0.5),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            labelText: S.current.cancel,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
          );
        });
  }

  static dynamic showSendInvitationDialog<T>({required BuildContext context}) {
    TextEditingController controllerName = TextEditingController();
    TextEditingController controllerEmail = TextEditingController();
    final _keyInvitationForm = GlobalKey<FormState>();
    return AppDialog.showMainAppDialog(
      context: context,
      title: S.current.getInvitationCode,
      content: BlocConsumer<SessionControllerCubit, SessionControllerState>(
          listener: (context, state) {
        if (state is SessionControllerInvitationError) {
          ErrorHandler(exception: state.exception)
              .showErrorToast(context: context);
        }
        if (state is SessionControllerInvitationSent) {
          AppSnackBar(message: S.current.sentSuccessfully, context: context)
              .showSuccessSnackBar();
          Navigator.pop(context);
        }
      }, builder: (context, state) {
        return Form(
          key: _keyInvitationForm,
          child: Column(
            children: [
              EditTextField(
                  controller: controllerName, label: S.current.fullName),
              SizedBox(height: 12.h),
              EditTextField(
                  controller: controllerEmail, label: S.current.email),
              CustomElevatedButton(
                isLoading: state is SessionControllerInvitationLoading,
                margin: EdgeInsets.only(top: 30, bottom: 30),
                backgroundColor: AppColors.primaryColor,
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  if (!_keyInvitationForm.currentState!.validate()) {
                    return;
                  }
                  context.read<SessionControllerCubit>().sendInvitation(
                      name: controllerName.text, email: controllerEmail.text);
                },
                child: Text(S.current.invite,
                    style: Theme.of(context)
                        .textTheme
                        .displayLarge
                        ?.copyWith(fontSize: 15, color: Colors.white)),
              ),
            ],
          ),
        );
      }),
    );
  }

  static dynamic showReportPostDialog<T>(
      {required BuildContext context,
      required Post post,
      required ReportCubit reportCubit}) {
    return AppDialog.showMainAppDialog(
      context: context,
      title: S.current.report,
      content: BlocConsumer<ReportCubit, ReportState>(
          bloc: reportCubit,
          listener: (context, state) {
            if (state is ReportFailure) {
              ErrorHandler(exception: state.exception)
                  .showErrorToast(context: context);
            }
            if (state is ReportPostDone) {
              AppSnackBar(
                      message: S.current.thankYouForReporting, context: context)
                  .showSuccessSnackBar();
              Navigator.pop(context);
            }
          },
          builder: (context, state) {
            return state is ReportLoading
                ? CenteredCircularProgressIndicator()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...AppData.reasonsList
                          .map((e) => TextButton(
                              onPressed: () {
                                reportCubit.reportPost(
                                    postId: post.id!, reasonId: e.id!);
                              },
                              child: Text(e.reason.toString(),
                                  style:
                                      Theme.of(context).textTheme.bodyLarge)))
                          .toList(),
                    ],
                  );
          }),
    );
  }

  static dynamic showShareProfileDialog<T>(
      {required BuildContext context,
      required String userLink,
      required User user}) {
    return showModal(
        context: context,
        configuration: const FadeScaleTransitionConfiguration(
            barrierColor: Colors.black12),
        filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
        builder: (context) {
          final GlobalKey qrGlobalKey = GlobalKey();
          String linkToShare =
              "🤩 Checkout this amazing profile on A New Social Media Platform 'EZENESS'\n$userLink";
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 35, vertical: 30),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: AppColors.blackColor,
                  ),
                  child: Column(
                    children: [
                      RepaintBoundary(
                        key: qrGlobalKey,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: QrImageView(
                            data: userLink,
                            backgroundColor: AppColors.blackColor,
                            eyeStyle: QrEyeStyle(
                              eyeShape: QrEyeShape.circle,
                              color: Colors.white,
                            ),
                            dataModuleStyle: QrDataModuleStyle(
                              dataModuleShape: QrDataModuleShape.circle,
                              color: Colors.white,
                            ),
                            version: QrVersions.auto,
                            size: 180.0,
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      Text(
                        "@${user.getUserName() ?? ""}",
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(color: AppColors.whiteColor),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "ID#${user.id ?? ""}",
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(color: AppColors.whiteColor),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.transparent,
                            border: Border.all(color: AppColors.whiteColor),
                          ),
                          child: IconButton(
                            onPressed: () async {
                              File qrImage =
                                  await Helpers.captureWidget(qrGlobalKey);
                              await Share.shareXFiles([XFile(qrImage.path)],
                                  text: linkToShare);
                            },
                            padding: EdgeInsets.zero,
                            icon: Icon(
                              CupertinoIcons.paperplane,
                              color: AppColors.whiteColor,
                            ),
                          ),
                        ),
                        Text(
                          S.current.share,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: AppColors.whiteColor),
                        )
                      ],
                    ),
                    SizedBox(width: 40.w),
                    Column(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.transparent,
                            border: Border.all(color: AppColors.whiteColor),
                          ),
                          child: IconButton(
                            onPressed: () {
                              Clipboard.setData(ClipboardData(text: userLink));
                              AppToast(message: "Copied to Clipboard").show();
                            },
                            padding: EdgeInsets.zero,
                            icon: Icon(Icons.copy, color: AppColors.whiteColor),
                          ),
                        ),
                        Text(
                          S.current.copy,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: AppColors.whiteColor),
                        )
                      ],
                    ),
                    // SizedBox(width: 20.w),
                    // CircleAvatar(
                    //   radius: 25,
                    //   backgroundColor: Colors.white,
                    //   child: IconButton(
                    //     onPressed: () async {
                    //       await Share.share(linkToShare);
                    //     },
                    //     padding: EdgeInsets.zero,
                    //     icon: Icon(Icons.share, color: Colors.grey.shade900),
                    //   ),
                    // ),
                  ],
                ),
              ],
            ),
          );
        });
  }

  static dynamic showNewPlaylistDialog<T>(
      BuildContext context, PlayListCubit playListCubit) {
    TextEditingController controllerName = TextEditingController();
    final _playListForm = GlobalKey<FormState>();

    AppDialog.showMainAppDialog(
      context: context,
      title: 'New playlist',
      content: Form(
        key: _playListForm,
        child: Column(
          children: [
            EditTextField(
              controller: controllerName,
              label: 'Title',
            ),
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    AppDialog.closeAppDialog();
                  },
                  child: Text(
                    'Cancel',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.primaryColor,
                        ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    if (!_playListForm.currentState!.validate()) {
                      return;
                    }
                    playListCubit.createPlayList(
                      controllerName.text,
                    );
                    AppDialog.closeAppDialog();
                  },
                  child: Text('Create',
                      style: Theme.of(context)
                          .textTheme
                          .displayLarge
                          ?.copyWith(fontSize: 12, color: Colors.white)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
