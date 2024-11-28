import 'package:ezeness/data/models/user/user.dart';
import 'package:ezeness/data/models/user/user_list.dart';
import 'package:ezeness/logic/cubit/explore_users/explore_users_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/pagination_page.dart';
import '../../../data/utils/error_handler.dart';
import '../../../generated/l10n.dart';
import '../../../logic/cubit/loadMore/load_more_cubit.dart';
import '../../widgets/common/common.dart';
import '../../widgets/profile_grid_view.dart';

class ExploreUsersScreen extends StatefulWidget {
  static const String routName = 'explore_users_screen';
  const ExploreUsersScreen({Key? key})
      : super(key: key);

  @override
  State<ExploreUsersScreen> createState() => _ExploreUsersScreenState();
}

class _ExploreUsersScreenState extends State<ExploreUsersScreen> {
  late ExploreUsersCubit _exploreUsersCubit;
  late LoadMoreCubit _loadMoreCubit;
  List<User> usersList = [];
  ScrollController scrollController=ScrollController();
  PaginationPage usersPage = PaginationPage(currentPage: 2);
  @override
  void initState() {
    _exploreUsersCubit = context.read<ExploreUsersCubit>();
    _loadMoreCubit = context.read<LoadMoreCubit>();
    _exploreUsersCubit.getExploreUsersList();
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset &&
          _loadMoreCubit.state is! LoadMoreLoading) {
        _loadMoreCubit.loadMoreExploreUsers(usersPage);
      }
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(S.current.connect.toUpperCase())),
      body: BlocConsumer<ExploreUsersCubit, ExploreUsersState>(
          bloc: _exploreUsersCubit,
          listener: (context, state) {
            if (state is ExploreUsersListLoaded) {
              usersList=state.response.userList!;
            }
          },
          builder: (context, state) {
            if (state is ExploreUsersListLoading) {
              return const CenteredCircularProgressIndicator();
            }
            if (state is ExploreUsersListFailure) {
              return ErrorHandler(exception: state.exception)
                  .buildErrorWidget(
                context: context,
                retryCallback: () => _exploreUsersCubit.getExploreUsersList(),
              );
            }
            return ListView(
              controller: scrollController,
              children: [
                ProfileGridView(
                  usersList,
                  isScroll: false,
                  withFollowButton: true,
                ),
                BlocConsumer<LoadMoreCubit, LoadMoreState>(
                    bloc: _loadMoreCubit,
                    listener: (context, state) {
                      if (state is LoadMoreFailure) {
                        ErrorHandler(exception: state.exception)
                            .handleError(context);
                      }
                      if (state is LoadMoreUsersExploreLoaded) {
                        UserList temp = state.list;
                        if (temp.userList!.isNotEmpty) {
                          usersPage.currentPage++;
                          setState(() {
                            usersList.addAll(temp.userList!);
                          });
                        }
                      }
                    },
                    builder: (context, state) {
                      if (state is LoadMoreLoading) {
                        return const CenteredCircularProgressIndicator();
                      }
                      return Container();
                    }),
              ],
            );
          }),
    );
  }
}
