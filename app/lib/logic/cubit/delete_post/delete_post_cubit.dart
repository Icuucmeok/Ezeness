import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ezeness/data/repositories/post_repository.dart';
part 'delete_post_state.dart';


class DeletePostCubit extends Cubit<DeletePostState> {
  final PostRepository _postRepository;
  DeletePostCubit(this._postRepository) : super(DeletePostInitial());
  void deletePost(int postId) async {
    emit(DeletePostLoading());
    try {
      final data =  await _postRepository.deletePost(postId);
      emit(DeletePostDone(data!));
    } catch (e) {
      emit(DeletePostFailure(e));
    }
  }
}
