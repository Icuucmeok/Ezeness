import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ezeness/data/repositories/explore_repository.dart';
import 'package:ezeness/res/app_res.dart';

import '../../../data/models/explore_response.dart';


part 'explore_home_state.dart';

class ExploreHomeCubit extends Cubit<ExploreHomeState> {
  final ExploreRepository _exploreRepository;
  ExploreHomeCubit(this._exploreRepository) : super(ExploreHomeInitial());

  void getExploreHomeResponse() async {
    emit(ExploreHomeLoading());
    try {
      final data =  await _exploreRepository.getExploreResponse(Constants.homeTabKey);
      emit(ExploreHomeLoaded(data!));
    } catch (e) {
      emit(ExploreHomeFailure(e));
    }
  }

}
