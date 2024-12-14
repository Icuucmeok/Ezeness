part of 'explore_social_post_cubit.dart';



abstract class ExploreSocialPostState extends Equatable {
  const ExploreSocialPostState();

  @override
  List<Object> get props => [];
}

class ExploreSocialPostInitial extends ExploreSocialPostState {}



class ExploreSocialPostListLoading extends ExploreSocialPostState {}
class ExploreSocialPostListFailure extends ExploreSocialPostState {
  final Object exception;

  const ExploreSocialPostListFailure(this.exception);
  @override
  List<Object> get props => [exception];
}
class ExploreSocialPostListLoaded extends ExploreSocialPostState {
  final PostList response;

  const ExploreSocialPostListLoaded(this.response);
  @override
  List<Object> get props => [response];

}
