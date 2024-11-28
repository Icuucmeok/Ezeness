import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:ezeness/data/models/user/user.dart';
import 'package:ezeness/data/models/user/user_list.dart';
import 'package:ezeness/data/repositories/profile_repository.dart';
import 'package:ezeness/data/utils/error_handler.dart';
import 'package:ezeness/data/utils/errors.dart';

part 'mention_state.dart';

class MentionCubit extends Cubit<MentionState> {
  final ProfileRepository _profileRepository;
  MentionCubit(this._profileRepository) : super(MentionInitial());

  void getMention(String search) async {
    emit(MentionLoading());
    try {
      final data = await _profileRepository.getUsers(search: search);
      emit(MentionLoaded(data!));
    } catch (e) {
      emit(MentionFailure(e));
    }
  }

  Future<User?> getUserByName(String userName) async {
    try {
      userName = userName.replaceAll("@", '');
      final data = await _profileRepository.getUsers(search: userName);

      User? result = data?.userList
          ?.firstWhereOrNull((element) => element.username == userName);

      if (result == null)
        throw ServerException(
          message: "The user you are trying to reach does not exist!",
        );
      return result;
    } catch (e, s) {
      throw ErrorHandler(exception: e, stackTrace: s).rethrowError();
    }
  }
}
