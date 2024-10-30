part of 'like_post_cubit.dart';


abstract class LikePostState extends Equatable {
  const LikePostState();

  @override
  List<Object> get props => [];
}

class LikePostInitial extends LikePostState {}

class LikePostLoading extends LikePostState {}
class LikePostFailure extends LikePostState {
  final Object exception;

  const LikePostFailure(this.exception);
    @override
  List<Object> get props => [exception];
}
class LikePostDone extends LikePostState {
  final String response;

  const LikePostDone(this.response);
  @override
  List<Object> get props => [response];

}


class LikePostUserListLoading extends LikePostState {}
class LikePostUserListFailure extends LikePostState {
  final Object exception;

  const LikePostUserListFailure(this.exception);
  @override
  List<Object> get props => [exception];
}
class LikePostUserListDone extends LikePostState {
  final LikeUserList response;

  const LikePostUserListDone(this.response);
  @override
  List<Object> get props => [response];

}




