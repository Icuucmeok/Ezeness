import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ezeness/data/models/cart/cart_model.dart';
import '../../../data/models/cart/cart_model_list.dart';
import '../../../data/repositories/cart_repository.dart';


part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final CartRepository _cartRepository;
  CartCubit(this._cartRepository) : super(CartInitial());



  void getMyCart() async {
    emit(GetMyCartLoading());
    try {
      final data =  await _cartRepository.getMyCart();
      emit(GetMyCartLoaded(data!));
    } catch (e) {
      emit(GetMyCartFailure(e));
    }
  }



  void addToMyCart(CartModel body) async {
    emit(AddToCartLoading());
    try {
      final data =  await _cartRepository.addToMyCart(body);
      emit(AddToCartDone(data!));

    } catch (e) {
      emit(AddToCartFailure(e));
    }
  }

  void removeFromMyCart(int index) async {
    emit(AddToCartLoading());
    try {
      final data =  await _cartRepository.removeFromMyCart(index);
      emit(RemoveFromCartDone(data!));

    } catch (e) {
      emit(AddToCartFailure(e));
    }
  }
}
