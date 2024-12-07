part of 'load_more_cubit.dart';

abstract class LoadMoreState extends Equatable {
  const LoadMoreState();

  @override
  List<Object> get props => [];
}

class LoadMoreInitial extends LoadMoreState {}

class LoadMoreLoading extends LoadMoreState {}
class LoadMoreDone extends LoadMoreState {}

// class LoadMoreLoaded extends LoadMoreState {
//   final dynamic list;
//
//   const LoadMoreLoaded(this.list);
//   @override
//   List<Object> get props => [list];
// }
class LoadMorePostByHashTagsLoaded extends LoadMoreState {
  final dynamic list;

  const LoadMorePostByHashTagsLoaded(this.list);
  @override
  List<Object> get props => [list];
}
class LoadMoreSectionPostExploreLoaded extends LoadMoreState {
  final dynamic list;

  const LoadMoreSectionPostExploreLoaded(this.list);
  @override
  List<Object> get props => [list];
}

class LoadMoreUsersExploreLoaded extends LoadMoreState {
  final dynamic list;

  const LoadMoreUsersExploreLoaded(this.list);
  @override
  List<Object> get props => [list];
}
class LoadMoreShopPostExploreLoaded extends LoadMoreState {
  final dynamic list;

  const LoadMoreShopPostExploreLoaded(this.list);
  @override
  List<Object> get props => [list];
}

class LoadMoreSocialPostExploreLoaded extends LoadMoreState {
  final dynamic list;

  const LoadMoreSocialPostExploreLoaded(this.list);
  @override
  List<Object> get props => [list];
}

class LoadMoreFailure extends LoadMoreState {
  final Object exception;

  const LoadMoreFailure(this.exception);
  @override
  List<Object> get props => [exception];
}

class LoadMoreHomeDiscoverLoaded extends LoadMoreState {
  final dynamic list;

  const LoadMoreHomeDiscoverLoaded(this.list);
  @override
  List<Object> get props => [list];
}
class LoadMoreShopDiscoverLoaded extends LoadMoreState {
  final dynamic list;

  const LoadMoreShopDiscoverLoaded(this.list);
  @override
  List<Object> get props => [list];
}
class LoadMoreSocialDiscoverLoaded extends LoadMoreState {
  final dynamic list;

  const LoadMoreSocialDiscoverLoaded(this.list);
  @override
  List<Object> get props => [list];
}
class LoadMoreKidsDiscoverLoaded extends LoadMoreState {
  final dynamic list;

  const LoadMoreKidsDiscoverLoaded(this.list);
  @override
  List<Object> get props => [list];
}

class LoadMoreUserPostLoaded extends LoadMoreState {
  final PostList list;

  const LoadMoreUserPostLoaded(this.list);
  @override
  List<Object> get props => [list];
}
class LoadMoreMyPostLoaded extends LoadMoreState {
  final PostList list;

  const LoadMoreMyPostLoaded(this.list);
  @override
  List<Object> get props => [list];
}

class LoadMorePostViewScreenLoaded extends LoadMoreState {
  final PostList list;

  const LoadMorePostViewScreenLoaded(this.list);
  @override
  List<Object> get props => [list];
}
class LoadMorePostListViewScreenLoaded extends LoadMoreState {
  final PostList list;

  const LoadMorePostListViewScreenLoaded(this.list);
  @override
  List<Object> get props => [list];
}
class LoadMoreSearchResponseLoaded extends LoadMoreState {
  final dynamic response;

  const LoadMoreSearchResponseLoaded(this.response);
  @override
  List<Object> get props => [response];
}

class LoadMoreNotificationListLoaded extends LoadMoreState {
  final dynamic response;

  const LoadMoreNotificationListLoaded(this.response);
  @override
  List<Object> get props => [response];
}

class LoadMoreSearchTagUpPostLoaded extends LoadMoreState {
final PostList list;

const LoadMoreSearchTagUpPostLoaded(this.list);
@override
List<Object> get props => [list];
}

class LoadMoreSearchTagUpProfileLoaded extends LoadMoreState {
  final UserList list;

  const LoadMoreSearchTagUpProfileLoaded(this.list);
  @override
  List<Object> get props => [list];
}