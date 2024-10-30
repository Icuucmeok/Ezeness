import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ezeness/data/repositories/post_repository.dart';

import '../../../data/models/user/liftup_user_list.dart';
part 'liftup_post_state.dart';


class LiftUpPostCubit extends Cubit<LiftUpPostState> {
  final PostRepository _postRepository;
  LiftUpPostCubit(this._postRepository) : super(LiftUpPostInitial());


  void liftUpUnLiftUpPost(int postId) async {
    emit(LiftUpPostLoading());
    try {
      final data =  await _postRepository.liftUpUnLiftUpPost(postId);
      emit(LiftUpPostDone(data!));
    } catch (e) {
      emit(LiftUpPostFailure(e));
    }
  }

  void getPostUsersLiftUpList(int postId) async {
    emit(LiftUpPostUserListLoading());
    try {
      final data =  await _postRepository.getPostUsersLiftUpList(postId);
      emit(LiftUpPostUserListDone(data!));
    } catch (e) {
      emit(LiftUpPostUserListFailure(e));
    }
  }

}
