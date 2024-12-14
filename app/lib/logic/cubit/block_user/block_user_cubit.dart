import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ezeness/data/repositories/profile_repository.dart';
part 'block_user_state.dart';


class BlockUserCubit extends Cubit<BlockUserState> {
  final ProfileRepository _profileRepository;
  BlockUserCubit(this._profileRepository) : super(BlockUserInitial());


  void blockUnBlockUser(int userId) async {
    emit(BlockUserLoading());
    try {
     final data =  await _profileRepository.blockUnBlockUser(userId);
     emit(BlockUserDone(data!));
    } catch (e) {
      emit(BlockUserFailure(e));
    }
  }
}
