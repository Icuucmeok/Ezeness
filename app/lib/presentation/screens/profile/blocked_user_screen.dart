import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data/models/user/user.dart';
import '../../../../data/utils/error_handler.dart';
import '../../../generated/l10n.dart';
import '../../../logic/cubit/block_user/block_user_cubit.dart';
import '../../../logic/cubit/blocked_users/blocked_users_cubit.dart';
import '../../widgets/circle_avatar_icon_widget.dart';
import '../../widgets/common/common.dart';
import '../../widgets/pull_to_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BlockedUserScreen extends StatefulWidget {
  static const String routName = 'blocked_user_screen';
  const BlockedUserScreen({Key? key}) : super(key: key);

  @override
  State<BlockedUserScreen> createState() => _BlockedUserScreenState();
}

class _BlockedUserScreenState extends State<BlockedUserScreen>
    with TickerProviderStateMixin {
  late BlockedUsersCubit _blockedUsersCubit;
  late BlockUserCubit _blockUserCubit;
  late List<User> blockedUserList;
  @override
  void initState() {
    _blockedUsersCubit = context.read<BlockedUsersCubit>();
    _blockUserCubit = context.read<BlockUserCubit>();
    _blockedUsersCubit.getBlockedUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(S.current.blockedUsers)),
      body: BlocConsumer<BlockUserCubit, BlockUserState>(
          bloc: _blockUserCubit,
          listener: (context, state) {
            if (state is BlockUserDone) {
              blockedUserList.removeWhere(
                  (element) => element.id.toString() == state.response);
            }
          },
          builder: (context, state) {
            return PullToRefresh(
              onRefresh: () => _blockedUsersCubit.getBlockedUsers(),
              child: BlocBuilder<BlockedUsersCubit, BlockedUsersState>(
                  bloc: _blockedUsersCubit,
                  builder: (context, state) {
                    if (state is BlockedUsersLoading) {
                      return const CenteredCircularProgressIndicator();
                    }
                    if (state is BlockedUsersFailure) {
                      return ErrorHandler(exception: state.exception)
                          .buildErrorWidget(
                              context: context,
                              retryCallback: () =>
                                  _blockedUsersCubit.getBlockedUsers());
                    }
                    if (state is BlockedUsersLoaded) {
                      blockedUserList = state.response.blockedUserList!;
                      return blockedUserList.isEmpty
                          ? const EmptyCard(withIcon: false)
                          : ListView(
                              children: blockedUserList
                                  .map((e) => buildUserWidget(e))
                                  .toList(),
                            );
                    }
                    return Container();
                  }),
            );
          }),
    );
  }

  Widget buildUserWidget(User user) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.0.w),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
            child: CircleAvatarIconWidget(
              userProfileImage: user.image.toString(),
              size: 40,
            ),
          ),
          SizedBox(width: 8.w),
          Text(
            "${user.name}",
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w400,
              fontSize: 12.sp,
              color: Colors.white,
              shadows: [
                Shadow(
                    color: Colors.black45,
                    offset: Offset(1, 1),
                    blurRadius: 1.1),
              ],
            ),
          ),
          const Expanded(child: SizedBox()),
          InkWell(
            onTap: () {
              _blockUserCubit.blockUnBlockUser(user.id!);
            },
            child: Container(
              width: 80.w,
              padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 2.0.h),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                  Radius.circular(5.0),
                ),
                border: Border.all(color: Colors.grey.shade800, width: 1.w),
              ),
              child: Text(
                S.current.unBlock,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      // fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 12.sp,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
