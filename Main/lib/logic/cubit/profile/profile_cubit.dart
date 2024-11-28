import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ezeness/data/models/user/user.dart';
import 'package:ezeness/data/models/user/user_list.dart';
import 'package:ezeness/data/repositories/profile_repository.dart';

import '../../../data/models/app_file.dart';
import '../../../data/models/auth/edit_profile_body.dart';
import '../app_config/app_config_cubit.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository _profileRepository;
  ProfileCubit(this._profileRepository) : super(ProfileInitial());

  Future<void> getMyProfileSync(AppConfigCubit appConfigCubit) async {
    emit(ProfileLoading());
    try {
      final data = await _profileRepository.getMyProfile();
      emit(ProfileLoaded(data!));
      appConfigCubit.setUser(data);
    } catch (e) {
      emit(ProfileFailure(e));
    }
  }

  void getMyProfile(AppConfigCubit appConfigCubit) async {
    emit(ProfileLoading());
    try {
      final data = await _profileRepository.getMyProfile();
      emit(ProfileLoaded(data!));
      appConfigCubit.setUser(data);
    } catch (e) {
      emit(ProfileFailure(e));
    }
  }

  void getUserProfile(int id) async {
    emit(ProfileLoading());
    try {
      final data = await _profileRepository.getUserProfile(id);
      emit(ProfileLoaded(data!));
    } catch (e) {
      emit(ProfileFailure(e));
    }
  }

  void editProfile({
    required EditProfileBody body,
    AppFile? image,
    AppFile? coverImage,
  }) async {
    emit(EditProfileLoading());
    try {
      final data = await _profileRepository.editProfile(body, image , coverImage);
      emit(EditProfileDone(data!));
    } catch (e) {
      emit(EditProfileFailure(e));
    }
  }

  void getUsers({String search=''}) async {
    emit(ProfileLoading());
    try {
      final data = await _profileRepository.getUsers(search:search);
      emit(ProfileListLoaded(data!));
    } catch (e) {
      emit(ProfileFailure(e));
    }
  }
}
