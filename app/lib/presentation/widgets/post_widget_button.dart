import 'package:flutter/material.dart';
import 'package:ezeness/data/models/post/post.dart';
import 'package:ezeness/presentation/utils/app_modal_bottom_sheet.dart';
import 'package:ezeness/presentation/utils/helpers.dart';
import 'package:ezeness/res/app_res.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import '../../logic/cubit/session_controller/session_controller_cubit.dart';

class PostWidgetButton extends StatefulWidget {
  final Post post;

  const PostWidgetButton({
    Key? key,
    required this.post,
  }) : super(key: key);

  @override
  State<PostWidgetButton> createState() => _PostWidgetButtonState();
}

class _PostWidgetButtonState extends State<PostWidgetButton> {
  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = context.read<SessionControllerCubit>().isLoggedIn();
    return GestureDetector(
      onTap: isLoggedIn || widget.post.postType == Constants.callUpKey
          ? () {
              if (widget.post.postType == Constants.callUpKey) {
                AppModalBottomSheet.showCallNumberBottomSheet(
                    context: context,
                    number: widget.post.contactCallNumber.toString());
                return;
              }
              AppModalBottomSheet.showAddToCartBottomSheet(
                  context: context, post: widget.post);
            }
          : Helpers.onGustTapButton,
      child: Container(
        padding: EdgeInsets.all(6.5),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? AppColors.darkColor
              : AppColors.whiteColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [Helpers.boxShadow(context)],
        ),
        child: Icon(
          widget.post.postType == Constants.callUpKey
              ? IconlyBold.call
              : IconlyBold.plus,
          color: Theme.of(context).brightness == Brightness.dark
              ? AppColors.whiteColor
              : AppColors.grey,
          size: 20,
        ),
      ),
    );
  }
}
