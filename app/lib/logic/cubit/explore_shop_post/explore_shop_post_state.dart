part of 'explore_shop_post_cubit.dart';



abstract class ExploreShopPostState extends Equatable {
  const ExploreShopPostState();

  @override
  List<Object> get props => [];
}

class ExploreShopPostInitial extends ExploreShopPostState {}



class ExploreShopPostListLoading extends ExploreShopPostState {}
class ExploreShopPostListFailure extends ExploreShopPostState {
  final Object exception;

  const ExploreShopPostListFailure(this.exception);
  @override
  List<Object> get props => [exception];
}
class ExploreShopPostListLoaded extends ExploreShopPostState {
  final PostList response;

  const ExploreShopPostListLoaded(this.response);
  @override
  List<Object> get props => [response];

}
