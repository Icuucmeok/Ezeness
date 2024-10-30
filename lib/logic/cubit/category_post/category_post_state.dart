part of 'category_post_cubit.dart';



abstract class CategoryPostState extends Equatable {
  const CategoryPostState();

  @override
  List<Object> get props => [];
}

class CategoryPostInitial extends CategoryPostState {}



class CategoryPostListLoading extends CategoryPostState {}
class CategoryPostListFailure extends CategoryPostState {
  final Object exception;

  const CategoryPostListFailure(this.exception);
  @override
  List<Object> get props => [exception];
}
class CategoryPostListLoaded extends CategoryPostState {
  final PostList response;

  const CategoryPostListLoaded(this.response);
  @override
  List<Object> get props => [response];

}
