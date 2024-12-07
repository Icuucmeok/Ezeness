part of 'bookmark_post_cubit.dart';


abstract class BookmarkPostState extends Equatable {
  const BookmarkPostState();

  @override
  List<Object> get props => [];
}

class BookmarkPostInitial extends BookmarkPostState {}

class BookmarkPostLoading extends BookmarkPostState {}
class BookmarkPostFailure extends BookmarkPostState {
  final Object exception;

  const BookmarkPostFailure(this.exception);
    @override
  List<Object> get props => [exception];
}
class BookmarkPostDone extends BookmarkPostState {
  final String response;

  const BookmarkPostDone(this.response);
  @override
  List<Object> get props => [response];

}

class BookmarkPostUserListLoading extends BookmarkPostState {}
class BookmarkPostUserListFailure extends BookmarkPostState {
  final Object exception;

  const BookmarkPostUserListFailure(this.exception);
  @override
  List<Object> get props => [exception];
}
class BookmarkPostUserListDone extends BookmarkPostState {
  final BookmarkUserList response;

  const BookmarkPostUserListDone(this.response);
  @override
  List<Object> get props => [response];

}


