part of 'post_comment_cubit.dart';


abstract class PostCommentState extends Equatable {
  const PostCommentState();

  @override
  List<Object> get props => [];
}

class PostCommentInitial extends PostCommentState {}

class PostCommentLoading extends PostCommentState {}
class PostCommentFailure extends PostCommentState {
  final Object exception;

  const PostCommentFailure(this.exception);
    @override
  List<Object> get props => [exception];
}
class PostCommentLoaded extends PostCommentState {
  final CommentList response;

  const PostCommentLoaded(this.response);
  @override
  List<Object> get props => [response];

}




