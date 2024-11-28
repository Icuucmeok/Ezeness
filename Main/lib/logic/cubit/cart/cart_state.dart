part of 'cart_cubit.dart';


abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object> get props => [];
}

class CartInitial extends CartState {}

class GetMyCartLoading extends CartState {}
class GetMyCartFailure extends CartState {
  final Object exception;

  const GetMyCartFailure(this.exception);
    @override
  List<Object> get props => [exception];
}
class GetMyCartLoaded extends CartState {
  final CartModelList response;

  const GetMyCartLoaded(this.response);
  @override
  List<Object> get props => [response];

}

class AddToCartLoading extends CartState {}
class AddToCartFailure extends CartState {
  final Object exception;

  const AddToCartFailure(this.exception);
  @override
  List<Object> get props => [exception];
}
class AddToCartDone extends CartState {
  final String response;

  const AddToCartDone(this.response);
  @override
  List<Object> get props => [response];

}

class RemoveFromCartDone extends CartState {
  final String response;

  const RemoveFromCartDone(this.response);
  @override
  List<Object> get props => [response];

}

