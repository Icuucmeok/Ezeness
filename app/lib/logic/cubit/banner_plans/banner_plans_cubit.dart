import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ezeness/data/models/boost/plans/boost_plans_list.dart';
import 'package:ezeness/data/repositories/boost_repository.dart';

part 'banner_plans_state.dart';

class BannerPlansCubit extends Cubit<BannerPlansState> {
  final BoostRepository boostRepository;

  BannerPlansCubit(this.boostRepository) : super(BannerPlansInitial());

  void getBannersPlans({required int? postType, required int? isKids}) async {
    emit(BannerPlansLoading());
    try {
      final data = await boostRepository.getBannersPlans(
        postType: postType,
        isKids: isKids,
      );
      emit(BannerPlansDone(data));
    } catch (e) {
      emit(BannerPlansFailure(e));
    }
  }
}
