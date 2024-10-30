import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ezeness/data/repositories/post_repository.dart';

import '../../../data/models/comment/comment.dart';
part 'comment_state.dart';


class CommentCubit extends Cubit<CommentState> {
  final PostRepository _postRepository;
  CommentCubit(this._postRepository) : super(CommentInitial());


  void addComment({required int postId,required String comment}) async {
    emit(CommentLoading());
    try {
      final data =  await _postRepository.addComment(postId,comment);
      emit(CommentAdded(data!));
    } catch (e) {
      emit(CommentFailure(e));
    }
  }

  void deleteComment(int id) async {
    emit(CommentLoading());
    try {
      final data =  await _postRepository.deleteComment(id);
      emit(CommentDeleted(data!));
    } catch (e) {
      emit(CommentFailure(e));
    }
  }

  void deleteReply(int id) async {
    emit(CommentLoading());
    try {
      final data =  await _postRepository.deleteComment(id);
      emit(CommentReplyDeleted(data!));
    } catch (e) {
      emit(CommentFailure(e));
    }
  }

  void setCommentToReply(CommentModel? comment) async {
    emit(CommentReplyToCommentSet(comment));
  }

  void likeUnLikeComment(int id) async {
    emit(CommentLoading());
    try {
      final data =  await _postRepository.likeUnLikeComment(id);
      emit(CommentLikeUnLike(data!));
    } catch (e) {
      emit(CommentFailure(e));
    }
  }

  void addReply({required int postId,required int commentId,required String comment}) async {
    emit(CommentLoading());
    try {
      final data =  await _postRepository.addComment(postId,comment,commentId: commentId);
      emit(CommentReplyAdded(data!));
    } catch (e) {
      emit(CommentFailure(e));
    }
  }
}
