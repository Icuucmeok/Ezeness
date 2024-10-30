import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ezeness/data/repositories/explore_repository.dart';
import 'package:ezeness/res/app_res.dart';

import '../../../data/models/explore_response.dart';


part 'explore_kids_state.dart';

class ExploreKidsCubit extends Cubit<ExploreKidsState> {
  final ExploreRepository _exploreRepository;
  ExploreKidsCubit(this._exploreRepository) : super(ExploreKidsInitial());

  void getExploreKidsResponse() async {
    emit(ExploreKidsLoading());
    try {
      final data =  await _exploreRepository.getExploreResponse(Constants.kidsTabKey);
      emit(ExploreKidsLoaded(data!));
    } catch (e) {
      emit(ExploreKidsFailure(e));
    }
  }

}
