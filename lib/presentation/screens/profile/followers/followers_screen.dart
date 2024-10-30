import 'package:ezeness/data/models/followers.dart';
import 'package:ezeness/res/app_res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data/models/user/user.dart';
import '../../../../data/utils/error_handler.dart';
import '../../../../generated/l10n.dart';
import '../../../../logic/cubit/follow_user/follow_user_cubit.dart';
import '../../../../logic/cubit/followers/followers_cubit.dart';
import '../../../widgets/common/common.dart';
import '../../../widgets/pull_to_refresh.dart';
import '../../../widgets/user_widget.dart';

class FollowersScreen extends StatefulWidget {
  static const String routName = 'followers_screen';
  final User user;
  const FollowersScreen({required this.user, Key? key}) : super(key: key);

  @override
  State<FollowersScreen> createState() => _FollowersScreenState();
}

class _FollowersScreenState extends State<FollowersScreen>
    with TickerProviderStateMixin {
  late FollowersCubit _followersCubit;
  late FollowUserCubit _followUserCubit;
  @override
  void initState() {
    _followersCubit = context.read<FollowersCubit>();
    _followUserCubit = context.read<FollowUserCubit>();
    _followersCubit.getFollowers(widget.user.id!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TabController _tabController = TabController(length: 3, vsync: this);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "@${widget.user.proUsername ?? widget.user.username}",
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).primaryColorDark.withOpacity(0.7),
              fontWeight: FontWeight.normal,
              fontSize: 16),
        ),
      ),
      body: BlocBuilder<FollowersCubit, FollowersState>(
          bloc: _followersCubit,
          builder: (context, state) {
            if (state is FollowersLoading) {
              return const CenteredCircularProgressIndicator();
            }
            if (state is FollowersFailure) {
              return ErrorHandler(exception: state.exception).buildErrorWidget(
                  context: context,
                  retryCallback: () =>
                      _followersCubit.getFollowers(widget.user.id!));
            }
            if (state is FollowersLoaded) {
              Followers response = state.response;
              return Column(
                children: [
                  TabBar(
                    controller: _tabController,
                    tabs: [
                      Tab(
                        child: Text(
                          S.current.uTagging + " ${response.followingCount}",
                          style: TextStyle(color: AppColors.greyDark)
                        ),
                      ),
                      Tab(
                        child: Text(
                          S.current.taggers + " ${response.followersCount}",
                            style: TextStyle(color: AppColors.gold)
                        ),
                      ),
                      Tab(
                        child: Text(
                          S.current.taggingUp + " ${response.mutualCount}",
                            style: TextStyle(color: Colors.green)
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        PullToRefresh(
                          onRefresh: () =>
                              _followersCubit.getFollowers(widget.user.id!),
                          child: ListView(
                            children: response.following!
                                .map((e) => UserWidget(e, _followUserCubit))
                                .toList(),
                          ),
                        ),
                        PullToRefresh(
                          onRefresh: () =>
                              _followersCubit.getFollowers(widget.user.id!),
                          child: ListView(
                            children: response.followers!
                                .map((e) => UserWidget(e, _followUserCubit))
                                .toList(),
                          ),
                        ),
                        PullToRefresh(
                          onRefresh: () =>
                              _followersCubit.getFollowers(widget.user.id!),
                          child: ListView(
                            children: response.mutual!
                                .map((e) => UserWidget(e, _followUserCubit))
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
            return Container();
          }),
    );
  }
}
