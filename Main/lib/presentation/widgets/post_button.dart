import 'package:ezeness/data/models/post/post.dart';
import 'package:ezeness/presentation/utils/app_modal_bottom_sheet.dart';
import 'package:ezeness/presentation/utils/helpers.dart';
import 'package:ezeness/presentation/widgets/common/common.dart';
import 'package:ezeness/res/app_res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';

import '../../logic/cubit/session_controller/session_controller_cubit.dart';

class PostButton extends StatefulWidget {
  final Post post;
  final bool isLarge;

  const PostButton({
    Key? key,
    required this.post,
    this.isLarge = false,
  }) : super(key: key);

  @override
  State<PostButton> createState() => _PostButtonState();
}

class _PostButtonState extends State<PostButton> {
  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = context.read<SessionControllerCubit>().isLoggedIn();
    return Container(
      height: widget.isLarge ? 50 : 30,
      width: widget.isLarge ? 50 : 50,
      child: CustomElevatedButton(
        padding: EdgeInsets.zero,
        margin: EdgeInsets.zero,
        backgroundColor: AppColors.greyTextColor.withOpacity(0.9),
        onPressed: isLoggedIn || widget.post.postType == Constants.callUpKey
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
        child: Icon(
          widget.post.postType == Constants.callUpKey
              ? IconlyBold.call
              : IconlyBold.plus,
          color: Colors.white,
          size: 22,
        ),
        borderColor: Colors.transparent,
      ),
    );
  }
}
