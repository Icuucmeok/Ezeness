import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/models/app_file.dart';
import '../../../data/models/upgrade_store_plan/upgrade_store_plan_body.dart';
import '../../../data/models/upgrade_store_plan/upgrade_store_plan_list.dart';
import '../../../data/repositories/upgrade_store_repository.dart';

part 'upgrade_store_state.dart';

class UpgradeStoreCubit extends Cubit<UpgradeStoreState> {
  final UpgradeStoreRepository _upgradeStoreRepository;
  UpgradeStoreCubit(this._upgradeStoreRepository) : super(UpgradeStoreInitial());


  void upgradeToStorePlan({required UpgradeStorePlanBody body,required List<AppFile> files}) async {
    emit(UpgradeStoreLoading());
    try {
      final data =  await _upgradeStoreRepository.upgradeToStorePlan(body,files);
      emit(UpgradeStoreDone(data!));
    } catch (e) {
      emit(UpgradeStoreFailure(e));
    }
  }

  void getPlan() async {
    emit(GetPlanLoading());
    try {
      final data =  await _upgradeStoreRepository.getPlan();
      emit(GetPlanLoaded(data!));
    } catch (e) {
      emit(GetPlanFailure(e));
    }
  }

  void editStorePlan(int storeTypeId) async {
    emit(EditStorePlanLoading());
    try {
      final data =  await _upgradeStoreRepository.editStorePlan(storeTypeId);
      emit(EditStorePlanDone(data!));
    } catch (e) {
      emit(UpgradeStoreFailure(e));
    }
  }

  void editStoreInfo({required UpgradeStorePlanBody body,required List<AppFile> files}) async {
    emit(UpgradeStoreLoading());
    try {
      final data =  await _upgradeStoreRepository.editStoreInfo(body,files);
      emit(UpgradeStoreDone(data!));
    } catch (e) {
      emit(UpgradeStoreFailure(e));
    }
  }

}
