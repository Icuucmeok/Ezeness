import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/app_file.dart';
import '../../../data/models/post/add_post_body.dart';
import '../../../data/models/post/post.dart';
import '../../../data/repositories/post_repository.dart';

part 'add_edit_post_state.dart';

class AddEditPostCubit extends Cubit<AddEditPostState> {
  final PostRepository _postRepository;
  AddEditPostCubit(this._postRepository) : super(AddEditPostInitial());

  void addPost(
      {required AddPostBody body, required List<AppFile> files}) async {
    emit(AddEditPostLoading());
    String? data;
    try {
      data = await _postRepository.addPost(
        body,
        onProgress: (p0) {
          emit(AddEditPostProgress(progress: p0));
        },
      );
      if (data != null)
        await _postRepository.uploadPostMedia(int.parse(data), files);

      emit(AddPostDone(data!));
    } catch (e) {
      if (data != null) _postRepository.deletePost(int.parse(data));
      emit(AddEditPostFailure(e));
    }
  }

  void updatePost(
      {required AddPostBody body,
      required List<AppFile> files,
      required int postId}) async {
    emit(AddEditPostLoading());
    try {
      final data = await _postRepository.updatePost(
        body,
        postId,
        onProgress: (p0) {
          emit(AddEditPostProgress(progress: p0));
        },
      );
      await _postRepository.uploadPostMedia(postId, files);
      emit(EditPostDone(data!));
    } catch (e) {
      emit(AddEditPostFailure(e));
    }
  }

  void validatePost(AddPostBody body) async {
    try {
      await _postRepository.validatePost(
        body,
        onProgress: (p0) {
          emit(AddEditPostProgress(progress: p0));
        },
      );

      emit(ValidatePostDone());
    } catch (e) {
      emit(ValidatePostFailure(e));
    }
  }
}
