part of 'my_post_cubit.dart';



abstract class MyPostState extends Equatable {
  const MyPostState();

  @override
  List<Object> get props => [];
}

class MyPostInitial extends MyPostState {}



class MyPostListLoading extends MyPostState {}
class MyPostListFailure extends MyPostState {
  final Object exception;

  const MyPostListFailure(this.exception);
  @override
  List<Object> get props => [exception];
}
class MyPostListLoaded extends MyPostState {
  final PostList response;

  const MyPostListLoaded(this.response);
  @override
  List<Object> get props => [response];

}
