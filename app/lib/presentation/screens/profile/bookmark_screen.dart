import 'package:ezeness/data/models/user/user.dart';
import 'package:ezeness/presentation/widgets/common/common.dart';
import 'package:ezeness/presentation/widgets/profile_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/post/post.dart';
import '../../../data/utils/error_handler.dart';
import '../../../generated/l10n.dart';
import '../../../logic/cubit/my_favourite/my_favourite_cubit.dart';
import '../../widgets/post_grid_view.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({Key? key}) : super(key: key);
  static const String routName = 'bookmark_screen';

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen>
    with TickerProviderStateMixin {
  late MyFavouriteCubit _myFavouriteCubit;

  @override
  void initState() {
    _myFavouriteCubit = context.read<MyFavouriteCubit>();
    _myFavouriteCubit.getMyFavourites();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TabController _tabController = TabController(
      length: 3,
      vsync: this,
    );
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text(S.current.saved)),
        body: BlocBuilder<MyFavouriteCubit, MyFavouriteState>(
            bloc: _myFavouriteCubit,
            builder: (context, state) {
              if (state is MyFavouriteListLoading) {
                return const CenteredCircularProgressIndicator();
              }
              if (state is MyFavouriteListFailure) {
                return ErrorHandler(exception: state.exception)
                    .buildErrorWidget(
                  context: context,
                  retryCallback: () => _myFavouriteCubit.getMyFavourites(),
                );
              }
              if (state is MyFavouriteListLoaded) {
                List<Post> favouritePostList =
                    state.response.favouritePostList!;
                List<User> favouriteUserList =
                    state.response.favouriteUserList ?? [];
                List<Post> favouriteProductsList =
                    state.response.favouriteProductsList!;

                return Column(
                  children: [
                    TabBar(
                      controller: _tabController,
                      tabs: [
                        Tab(text: S.current.products.toUpperCase()),
                        Tab(text: S.current.posts.toUpperCase()),
                        Tab(text: S.current.profiles.toUpperCase()),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        // physics: const NeverScrollableScrollPhysics(),
                        children: [
                          PostGridView(
                            favouriteProductsList,
                            isScroll: true,
                            onPostTapShowInList: true,
                          ),
                          PostGridView(
                            favouritePostList,
                            isScroll: true,
                            onPostTapShowInList: true,
                          ),
                          ProfileGridView(
                            favouriteUserList,
                            isScroll: true,
                            withFollowButton: true,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
              return Container();
            }),
      ),
    );
  }
}
