part of 'upgrade_username_cubit.dart';


abstract class UpgradeUserNameState extends Equatable {
  const UpgradeUserNameState();

  @override
  List<Object> get props => [];
}

class UpgradeUserNameInitial extends UpgradeUserNameState {}

class UpgradeUserNameLoading extends UpgradeUserNameState {}
class UpgradeUserNameFailure extends UpgradeUserNameState {
  final Object exception;

  const UpgradeUserNameFailure(this.exception);
    @override
  List<Object> get props => [exception];
}
class UpgradeUserNameDone extends UpgradeUserNameState {
  final String response;

  const UpgradeUserNameDone(this.response);
  @override
  List<Object> get props => [response];
}


class GetPlanLoading extends UpgradeUserNameState {}
class GetPlanLoaded extends UpgradeUserNameState {
  final UpgradeUsernamePlanList response;

  const GetPlanLoaded(this.response);
  @override
  List<Object> get props => [response];

}
class GetPlanFailure extends UpgradeUserNameState {
  final Object exception;

  const GetPlanFailure(this.exception);
  @override
  List<Object> get props => [exception];
}



class GetMySuggestionLoading extends UpgradeUserNameState {}
class MySuggestionLoaded extends UpgradeUserNameState {
  final List<String> response;

  const MySuggestionLoaded(this.response);
  @override
  List<Object> get props => [response];

}
class MySuggestionFailure extends UpgradeUserNameState {
  final Object exception;

  const MySuggestionFailure(this.exception);
  @override
  List<Object> get props => [exception];
}
