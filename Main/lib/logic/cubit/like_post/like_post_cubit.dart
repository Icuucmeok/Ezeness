import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ezeness/data/repositories/post_repository.dart';

import '../../../data/models/user/like_user_list.dart';
part 'like_post_state.dart';


class LikePostCubit extends Cubit<LikePostState> {
  final PostRepository _postRepository;
  LikePostCubit(this._postRepository) : super(LikePostInitial());


  void likeUnLikePost(int postId) async {
    emit(LikePostLoading());
    try {
      final data =  await _postRepository.likeUnLikePost(postId);
      emit(LikePostDone(data!));
    } catch (e) {
      emit(LikePostFailure(e));
    }
  }


  void getPostUsersLikeList(int postId) async {
    emit(LikePostUserListLoading());
    try {
      final data =  await _postRepository.getPostUsersLikeList(postId);
      emit(LikePostUserListDone(data!));
    } catch (e) {
      emit(LikePostUserListFailure(e));
    }
  }
}
