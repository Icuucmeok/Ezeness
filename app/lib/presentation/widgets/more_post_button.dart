import 'package:ezeness/logic/cubit/block_user/block_user_cubit.dart';
import 'package:ezeness/logic/cubit/delete_post/delete_post_cubit.dart';
import 'package:ezeness/logic/cubit/report/report_cubit.dart';
import 'package:ezeness/logic/cubit/subscribe_user_notification/subscribe_user_notification_cubit.dart';
import 'package:ezeness/presentation/utils/app_dialog.dart';
import 'package:ezeness/presentation/utils/app_toast.dart';
import 'package:ezeness/res/app_res.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/post/post.dart';
import '../../data/models/user/user.dart';
import '../../generated/l10n.dart';
import '../../logic/cubit/app_config/app_config_cubit.dart';
import '../router/app_router.dart';
import '../screens/profile/add_edit_post/add_edit_post_screen.dart';
import '../utils/app_modal_bottom_sheet.dart';
import 'common/common.dart';
import 'common/share_post_button.dart';

class MorePostButton extends StatefulWidget {
  final Post post;
  const MorePostButton({Key? key, required this.post}) : super(key: key);

  @override
  State<MorePostButton> createState() => _MorePostButtonState();
}

class _MorePostButtonState extends State<MorePostButton> {
  late SubscribeUserNotificationCubit _subscribeUserNotificationCubit;
  late DeletePostCubit _deletePostCubit;
  late BlockUserCubit _blockUserCubit;
  late ReportCubit _reportCubit;
  @override
  void initState() {
    _subscribeUserNotificationCubit =
        context.read<SubscribeUserNotificationCubit>();
    _deletePostCubit = context.read<DeletePostCubit>();
    _blockUserCubit = context.read<BlockUserCubit>();
    _reportCubit = context.read<ReportCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    User loginUser = context.read<AppConfigCubit>().getUser();
    return GestureDetector(
      onTap: () {
        AppModalBottomSheet.showMainModalBottomSheet(
          context: context,
          height: 200,
          scrollableContent: Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    Clipboard.setData(
                        ClipboardData(text: widget.post.id.toString()));
                    AppToast(message: "Copied to Clipboard").show();
                  },
                  child: Padding(
                    padding: const EdgeInsetsDirectional.only(start: 20.0),
                    child: Text(
                      "POST ID# ${widget.post.id ?? ""}",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w300,
                            color:
                                (Theme.of(context).brightness == Brightness.dark
                                    ? AppColors.whiteColor
                                    : AppColors.blackColor),
                          ),
                    ),
                  ),
                ),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SharePostButton(post: widget.post),
                    if (widget.post.user?.id != loginUser.id) ...{
                      MoreIconButton(
                        icon: CupertinoIcons.slash_circle,
                        onTapIcon: () {
                          Navigator.of(context).pop();
                          AppDialog.showConfirmationDialog(
                            context: context,
                            message: S.current.areYouSure +
                                "\n" +
                                S.current.block +
                                " ${widget.post.user!.name.toString()}",
                            onConfirm: () => _blockUserCubit
                                .blockUnBlockUser(widget.post.user!.id!),
                          );
                        },
                        value: S.current.block,
                      ),
                      BlocConsumer<SubscribeUserNotificationCubit,
                              SubscribeUserNotificationState>(
                          bloc: _subscribeUserNotificationCubit,
                          listener: (context, state) {
                            if (state is SubscribeUserNotificationDone) {
                              widget.post.user!.isSubscribeToNotification =
                                  !widget.post.user!.isSubscribeToNotification;
                            }
                          },
                          builder: (context, state) {
                            return MoreIconButton(
                              value: S.current.interested,
                              icon: widget.post.user!.isSubscribeToNotification
                                  ? CupertinoIcons.bell_fill
                                  : CupertinoIcons.bell,
                              onTapIcon: () {
                                _subscribeUserNotificationCubit
                                    .subscribeUnSubscribeUserNotification(
                                        widget.post.user!.id!);
                              },
                            );
                          }),
                      MoreIconButton(
                        value: S.current.report,
                        icon: CupertinoIcons.exclamationmark_bubble,
                        onTapIcon: () {
                          Navigator.of(context).pop();
                          AppDialog.showReportPostDialog(
                              context: context,
                              post: widget.post,
                              reportCubit: _reportCubit);
                        },
                      ),
                    },
                    if (widget.post.user?.id == loginUser.id) ...{
                      MoreIconButton(
                        icon: Icons.edit,
                        value: S.current.edit,
                        onTapIcon: () {
                          Navigator.of(context).pop();
                          Navigator.pushNamed(
                            AppRouter.mainContext,
                            AddEditPostScreen.routName,
                            arguments: {"post": widget.post},
                          );
                        },
                      ),
                      // MoreIconButton(
                      //   value: S.current.playList,
                      //   icon: CupertinoIcons.list_bullet,
                      //   onTapIcon: () {
                      //     Navigator.of(context).pop();
                      //     AppModalBottomSheet.showMainModalBottomSheet(
                      //       height: 300, context: context, content: PlayListWidget(post: widget.post,playListCubit: _playListCubit));
                      //   },
                      // ),
                      MoreIconButton(
                        icon: Icons.delete,
                        value: S.current.delete,
                        onTapIcon: () {
                          Navigator.of(context).pop();
                          AppDialog.showConfirmationDialog(
                            context: context,
                            onConfirm: () =>
                                _deletePostCubit.deletePost(widget.post.id!),
                          );
                        },
                      ),
                    },
                  ],
                ),
                Spacer(),
              ],
            ),
          ),
        );
      },
      child:
          Icon(Icons.more_vert, size: 35, color: Colors.white, shadows: const [
        Shadow(color: Colors.black45, offset: Offset(1, 1), blurRadius: 1.1),
      ]),
    );
  }
}
