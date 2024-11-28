import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ezeness/data/repositories/playlist_repository.dart';

import '../../../../data/models/playlist/playlist.dart';

part 'play_list_state.dart';

class PlayListCubit extends Cubit<PlayListState> {
  final PlayListRepository _playListRepository;

  PlayListCubit(this._playListRepository) : super(PlaylistInitial());

  Future<void> addRemovePostPlayList({required int postId, required int playlistId}) async {
    emit(PlaylistLoading());
    try {
      final data =  await _playListRepository.addRemovePostPlayList(postId,playlistId);
      emit(PlaylistPostAddedRemoved(data!));
    } catch (e) {
      emit(PlaylistFailure(e));
    }
  }

  Future<void> createPlayList(String name) async {
    emit(PlaylistLoading());
    try {
      final data =  await _playListRepository.createPlayList(name);
      emit(PlaylistAdded(data!));
    } catch (e) {
      emit(PlaylistFailure(e));
    }
  }

}
