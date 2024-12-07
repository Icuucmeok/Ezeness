import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ezeness/data/models/comment/comment_list.dart';
import 'package:ezeness/data/repositories/post_repository.dart';
part 'post_comment_state.dart';


class PostCommentCubit extends Cubit<PostCommentState> {
  final PostRepository _postRepository;
  PostCommentCubit(this._postRepository) : super(PostCommentInitial());


  void getComments(int postId) async {
    emit(PostCommentLoading());
    try {
      final data =  await _postRepository.getComments(postId);
      emit(PostCommentLoaded(data!));
    } catch (e) {
      emit(PostCommentFailure(e));
    }
  }
}
