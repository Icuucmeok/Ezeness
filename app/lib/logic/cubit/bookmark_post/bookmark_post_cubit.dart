import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ezeness/data/repositories/post_repository.dart';

import '../../../data/models/user/bookmark_user_list.dart';
part 'bookmark_post_state.dart';


class BookmarkPostCubit extends Cubit<BookmarkPostState> {
  final PostRepository _postRepository;
  BookmarkPostCubit(this._postRepository) : super(BookmarkPostInitial());


  void bookmarkUnBookmarkPost(int postId) async {
    emit(BookmarkPostLoading());
    try {
      final data =  await _postRepository.bookmarkUnBookmarkPost(postId);
      emit(BookmarkPostDone(data!));
    } catch (e) {
      emit(BookmarkPostFailure(e));
    }
  }
  void getPostUsersBookmarkList(int postId) async {
    emit(BookmarkPostUserListLoading());
    try {
      final data =  await _postRepository.getPostUsersBookmarkList(postId);
      emit(BookmarkPostUserListDone(data!));
    } catch (e) {
      emit(BookmarkPostUserListFailure(e));
    }
  }
}
