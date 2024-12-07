import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ezeness/data/models/user/user_list.dart';
import 'package:ezeness/data/repositories/explore_repository.dart';

import '../../../presentation/utils/helpers.dart';


part 'explore_users_state.dart';

class ExploreUsersCubit extends Cubit<ExploreUsersState> {
  final ExploreRepository _exploreRepository;
  ExploreUsersCubit(this._exploreRepository) : super(ExploreUsersInitial());

  static int usersRandomCode=0;
  void getExploreUsersList() async {
    emit(ExploreUsersListLoading());
    try {
      usersRandomCode=Helpers.getRandomNumber();
      final data =  await _exploreRepository.getExploreUsers();
      emit(ExploreUsersListLoaded(data!));
    } catch (e) {
      emit(ExploreUsersListFailure(e));
    }
  }

}
