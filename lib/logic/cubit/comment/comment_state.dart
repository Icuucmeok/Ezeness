part of 'comment_cubit.dart';


abstract class CommentState extends Equatable {
  const CommentState();

  @override
  List<Object> get props => [];
}

class CommentInitial extends CommentState {}

class CommentLoading extends CommentState {}
class CommentFailure extends CommentState {
  final Object exception;

  const CommentFailure(this.exception);
    @override
  List<Object> get props => [exception];
}
class CommentAdded extends CommentState {
  final CommentModel response;

  const CommentAdded(this.response);
  @override
  List<Object> get props => [response];

}
class CommentReplyAdded extends CommentState {
  final CommentModel response;

  const CommentReplyAdded(this.response);
  @override
  List<Object> get props => [response];

}
class CommentLikeUnLike extends CommentState {
  final String response;

  const CommentLikeUnLike(this.response);
  @override
  List<Object> get props => [response];

}
class CommentDeleted extends CommentState {
  final String response;

  const CommentDeleted(this.response);
  @override
  List<Object> get props => [response];

}
class CommentReplyDeleted extends CommentState {
  final String response;

  const CommentReplyDeleted(this.response);
  @override
  List<Object> get props => [response];

}
class CommentReplyToCommentSet extends CommentState {
  final CommentModel? response;

  const CommentReplyToCommentSet(this.response);
  @override
  List<Object> get props => [if(response!=null)response!];

}


