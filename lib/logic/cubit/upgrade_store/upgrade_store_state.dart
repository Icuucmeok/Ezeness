part of 'upgrade_store_cubit.dart';


abstract class UpgradeStoreState extends Equatable {
  const UpgradeStoreState();

  @override
  List<Object> get props => [];
}

class UpgradeStoreInitial extends UpgradeStoreState {}

class UpgradeStoreLoading extends UpgradeStoreState {}
class UpgradeStoreFailure extends UpgradeStoreState {
  final Object exception;

  const UpgradeStoreFailure(this.exception);
    @override
  List<Object> get props => [exception];
}
class UpgradeStoreDone extends UpgradeStoreState {
  final String response;

  const UpgradeStoreDone(this.response);
  @override
  List<Object> get props => [response];
}


class GetPlanLoading extends UpgradeStoreState {}
class GetPlanLoaded extends UpgradeStoreState {
  final UpgradeStorePlanList response;

  const GetPlanLoaded(this.response);
  @override
  List<Object> get props => [response];

}
class GetPlanFailure extends UpgradeStoreState {
  final Object exception;

  const GetPlanFailure(this.exception);
  @override
  List<Object> get props => [exception];
}

class EditStorePlanLoading extends UpgradeStoreState {}
class EditStorePlanFailure extends UpgradeStoreState {
  final Object exception;

  const EditStorePlanFailure(this.exception);
  @override
  List<Object> get props => [exception];
}
class EditStorePlanDone extends UpgradeStoreState {
  final String response;

  const EditStorePlanDone(this.response);
  @override
  List<Object> get props => [response];
}



