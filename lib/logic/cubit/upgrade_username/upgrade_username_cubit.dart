import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ezeness/data/models/upgrade_username_plan/upgrade_username_plan_list.dart';
import '../../../data/repositories/upgrade_username_repository.dart';

part 'upgrade_username_state.dart';

class UpgradeUserNameCubit extends Cubit<UpgradeUserNameState> {
  final UpgradeUserNameRepository _upgradeUserNameRepository;
  UpgradeUserNameCubit(this._upgradeUserNameRepository) : super(UpgradeUserNameInitial());


  void subscribeToPlan({required int planId,required String proUsername}) async {
    emit(UpgradeUserNameLoading());
    try {
      final data =  await _upgradeUserNameRepository.subscribeToPlan(planId,proUsername);
      emit(UpgradeUserNameDone(data!));
    } catch (e) {
      emit(UpgradeUserNameFailure(e));
    }
  }

  void editUserName(String proUsername) async {
    emit(UpgradeUserNameLoading());
    try {
      final data =  await _upgradeUserNameRepository.editUserName(proUsername);
      emit(UpgradeUserNameDone(data!));
    } catch (e) {
      emit(UpgradeUserNameFailure(e));
    }
  }

  void getPlan() async {
    emit(GetPlanLoading());
    try {
      final data =  await _upgradeUserNameRepository.getPlan();
      emit(GetPlanLoaded(data!));
    } catch (e) {
      emit(GetPlanFailure(e));
    }
  }

  void getMySuggestion() async {
    emit(GetMySuggestionLoading());
    try {
      final data =  await _upgradeUserNameRepository.getMySuggestion();
      emit(MySuggestionLoaded(data!));
    } catch (e) {
      emit(UpgradeUserNameFailure(e));
    }
  }

}
