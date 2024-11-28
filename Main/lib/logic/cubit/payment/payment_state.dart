part of 'payment_cubit.dart';


abstract class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object> get props => [];
}

class PaymentInitial extends PaymentState {}

class PaymentLoading extends PaymentState {}
class PaymentFailure extends PaymentState {
  final Object exception;

  const PaymentFailure(this.exception);
    @override
  List<Object> get props => [exception];
}
class PaymentLoaded extends PaymentState {
  final String response;

  const PaymentLoaded(this.response);
  @override
  List<Object> get props => [response];

}









