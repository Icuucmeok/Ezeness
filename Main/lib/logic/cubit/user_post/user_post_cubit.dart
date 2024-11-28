import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/models/post/post_list.dart';
import '../../../data/repositories/post_repository.dart';


part 'user_post_state.dart';

class UserPostCubit extends Cubit<UserPostState> {
  final PostRepository _postRepository;
  UserPostCubit(this._postRepository) : super(UserPostInitial());

  void getPostByUser(int userId) async {
    emit(UserPostListLoading());
    try {
      final data =  await _postRepository.getUserPosts(userId);
      emit(UserPostListLoaded(data!));
    } catch (e) {
      emit(UserPostListFailure(e));
    }
  }
}
