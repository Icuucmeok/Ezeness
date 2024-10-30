import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/models/post/post_list.dart';
import '../../../data/repositories/post_repository.dart';


part 'playlist_post_state.dart';

class PlaylistPostCubit extends Cubit<PlaylistPostState> {
  final PostRepository _postRepository;
  PlaylistPostCubit(this._postRepository) : super(PlaylistPostInitial());

  void getPostsByPlaylistId(int id) async {
    emit(PlaylistPostListLoading());
    try {
      final data =  await _postRepository.getPostsByPlaylistId(id);
      emit(PlaylistPostListLoaded(data!));
    } catch (e) {
      emit(PlaylistPostListFailure(e));
    }
  }
}
