part of 'calculate_coin_cubit.dart';

class CalculateCoinState extends Equatable {
  const CalculateCoinState();

  @override
  List<Object> get props => [];
}

class CalculateCoinInitial extends CalculateCoinState {}

class CalculateCoinLoading extends CalculateCoinState {}

class CalculateCoinFailure extends CalculateCoinState {
  final Object exception;

  const CalculateCoinFailure(this.exception);
  @override
  List<Object> get props => [exception];
}

class CalculateCoinDone extends CalculateCoinState {
  final CalculateCoinModel response;

  const CalculateCoinDone(this.response);
  @override
  List<Object> get props => [response];
}
