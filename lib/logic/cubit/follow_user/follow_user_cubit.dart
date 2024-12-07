import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/repositories/following_repository.dart';
part 'follow_user_state.dart';


class FollowUserCubit extends Cubit<FollowUserState> {
  final FollowingRepository _followingRepository;
  FollowUserCubit(this._followingRepository) : super(FollowUserInitial());


  void followUnFollowUser(int userId) async {
    emit(FollowUserLoading());
    try {
      final data =  await _followingRepository.followUnFollowUser(userId);
      emit(FollowUserDone(data!));
    } catch (e) {
      emit(FollowUserFailure(e));
    }
  }
}
