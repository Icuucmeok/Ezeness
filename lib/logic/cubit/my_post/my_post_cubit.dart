import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/models/post/post_list.dart';
import '../../../data/repositories/post_repository.dart';

part 'my_post_state.dart';

class MyPostCubit extends Cubit<MyPostState> {
  final PostRepository _postRepository;
  MyPostCubit(this._postRepository) : super(MyPostInitial());

  void getMyPosts({String? search,int withLiftUp=1}) async {
    emit(MyPostListLoading());
    try {
      final data =
          await _postRepository.getMyPosts(search: search,withLiftUp: withLiftUp);
      emit(MyPostListLoaded(data!));
    } catch (e) {
      emit(MyPostListFailure(e));
    }
  }
}
