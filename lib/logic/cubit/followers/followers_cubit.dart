import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/models/followers.dart';
import '../../../data/repositories/following_repository.dart';

part 'followers_state.dart';

class FollowersCubit extends Cubit<FollowersState> {
  final FollowingRepository _followingRepository;
  FollowersCubit(this._followingRepository) : super(FollowersInitial());



  void getFollowers(int userId) async {
    emit(FollowersLoading());
    try {
      final data =  await _followingRepository.getFollowers(userId);
      emit(FollowersLoaded(data!));
    } catch (e) {
      emit(FollowersFailure(e));
    }
  }

}
