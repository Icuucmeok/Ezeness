import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ezeness/data/repositories/explore_repository.dart';
import 'package:ezeness/res/app_res.dart';

import '../../../data/models/explore_response.dart';


part 'explore_social_state.dart';

class ExploreSocialCubit extends Cubit<ExploreSocialState> {
  final ExploreRepository _exploreRepository;
  ExploreSocialCubit(this._exploreRepository) : super(ExploreSocialInitial());

  void getExploreSocialResponse() async {
    emit(ExploreSocialLoading());
    try {
      final data =  await _exploreRepository.getExploreResponse(Constants.socialTabKey);
      emit(ExploreSocialLoaded(data!));
    } catch (e) {
      emit(ExploreSocialFailure(e));
    }
  }

}
