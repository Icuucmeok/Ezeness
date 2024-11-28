part of 'convert_coin_cubit.dart';

class ConvertCoinState extends Equatable {
  const ConvertCoinState();

  @override
  List<Object> get props => [];
}

class ConvertCoinInitial extends ConvertCoinState {}

class ConvertCoinLoading extends ConvertCoinState {}

class ConvertCoinFailure extends ConvertCoinState {
  final Object exception;

  const ConvertCoinFailure(this.exception);
  @override
  List<Object> get props => [exception];
}

class ConvertCoinDone extends ConvertCoinState {
  const ConvertCoinDone();
}
