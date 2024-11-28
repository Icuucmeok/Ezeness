import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/models/user/blocked_user_list.dart';
import '../../../data/repositories/profile_repository.dart';

part 'blocked_users_state.dart';

class BlockedUsersCubit extends Cubit<BlockedUsersState> {
  final ProfileRepository _profileRepository;
  BlockedUsersCubit(this._profileRepository) : super(BlockedUsersInitial());



  void getBlockedUsers() async {
    emit(BlockedUsersLoading());
    try {
      final data =  await _profileRepository.getBlockedUsers();
      emit(BlockedUsersLoaded(data!));
    } catch (e) {
      emit(BlockedUsersFailure(e));
    }
  }

}
