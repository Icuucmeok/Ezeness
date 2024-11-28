part of 'bookmark_user_cubit.dart';


abstract class BookmarkUserState extends Equatable {
  const BookmarkUserState();

  @override
  List<Object> get props => [];
}

class BookmarkUserInitial extends BookmarkUserState {}

class BookmarkUserLoading extends BookmarkUserState {}
class BookmarkUserFailure extends BookmarkUserState {
  final Object exception;

  const BookmarkUserFailure(this.exception);
    @override
  List<Object> get props => [exception];
}
class BookmarkUserDone extends BookmarkUserState {
  final String response;

  const BookmarkUserDone(this.response);
  @override
  List<Object> get props => [response];

}




