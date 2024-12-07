import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ezeness/data/repositories/explore_repository.dart';
import 'package:ezeness/res/app_res.dart';

import '../../../data/models/explore_response.dart';


part 'explore_shop_state.dart';

class ExploreShopCubit extends Cubit<ExploreShopState> {
  final ExploreRepository _exploreRepository;
  ExploreShopCubit(this._exploreRepository) : super(ExploreShopInitial());

  void getExploreShopResponse() async {
    emit(ExploreShopLoading());
    try {
      final data =  await _exploreRepository.getExploreResponse(Constants.shopTabKey);
      emit(ExploreShopLoaded(data!));
    } catch (e) {
      emit(ExploreShopFailure(e));
    }
  }

}
