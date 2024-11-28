part of 'explore_post_cubit.dart';



abstract class ExplorePostState extends Equatable {
  const ExplorePostState();

  @override
  List<Object> get props => [];
}

class ExplorePostInitial extends ExplorePostState {}



class ExploreSectionPostListLoading extends ExplorePostState {}
class ExploreSectionPostListFailure extends ExplorePostState {
  final Object exception;

  const ExploreSectionPostListFailure(this.exception);
  @override
  List<Object> get props => [exception];
}
class ExploreSectionPostListLoaded extends ExplorePostState {
  final PostList response;

  const ExploreSectionPostListLoaded(this.response);
  @override
  List<Object> get props => [response];

}
