
import 'dart:convert';

import 'cart_model.dart';



class CartModelList {
  final List<CartModel>? cartModelList;


  CartModelList({
    this.cartModelList,
  });

  static parsed(rawJson){
    final parsed = jsonDecode(rawJson).cast<Map<String, dynamic>>();
    final list= parsed.map<CartModel>((json) => CartModel.fromJson(json)).toList();
    return CartModelList(cartModelList: list);
  }

}
