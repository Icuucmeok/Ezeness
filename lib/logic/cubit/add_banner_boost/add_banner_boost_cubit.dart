import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ezeness/data/models/app_file.dart';
import 'package:ezeness/data/repositories/boost_repository.dart';

part 'add_banner_boost_state.dart';

class AddBannerBoostCubit extends Cubit<AddBannerBoostState> {
  final BoostRepository boostRepository;

  AddBannerBoostCubit(this.boostRepository) : super(AddBannerBoostInitial());

  void addBannerBoost({
    required int? postId,
    required int planId,
    required AppFile file,
    required String? startDate,
  }) async {
    emit(AddBannerBoostLoading());
    try {
      await boostRepository.addBannerBoost(
          postId: postId, planId: planId, file: file, startDate: startDate);
      emit(AddBannerBoostDone());
    } catch (e) {
      emit(AddBannerBoostFailure(e));
    }
  }
}
