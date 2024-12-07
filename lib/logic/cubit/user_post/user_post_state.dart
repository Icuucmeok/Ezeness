part of 'user_post_cubit.dart';



abstract class UserPostState extends Equatable {
  const UserPostState();

  @override
  List<Object> get props => [];
}

class UserPostInitial extends UserPostState {}



class UserPostListLoading extends UserPostState {}
class UserPostListFailure extends UserPostState {
  final Object exception;

  const UserPostListFailure(this.exception);
  @override
  List<Object> get props => [exception];
}
class UserPostListLoaded extends UserPostState {
  final PostList response;

  const UserPostListLoaded(this.response);
  @override
  List<Object> get props => [response];

}
