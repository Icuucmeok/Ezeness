part of 'post_cubit.dart';


abstract class PostState extends Equatable {
  const PostState();

  @override
  List<Object> get props => [];
}

class PostInitial extends PostState {}

class PostLoading extends PostState {}
class PostFailure extends PostState {
  final Object exception;

  const PostFailure(this.exception);
    @override
  List<Object> get props => [exception];
}
class PostLoaded extends PostState {
  final Post response;

  const PostLoaded(this.response);
  @override
  List<Object> get props => [response];

}


class PostListLoading extends PostState {}
class PostListFailure extends PostState {
  final Object exception;

  const PostListFailure(this.exception);
  @override
  List<Object> get props => [exception];
}
class PostListLoaded extends PostState {
  final PostList response;

  const PostListLoaded(this.response);
  @override
  List<Object> get props => [response];

}
