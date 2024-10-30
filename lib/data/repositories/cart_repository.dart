import 'dart:convert';

import 'package:ezeness/res/app_res.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data_providers/api_client.dart';
import '../models/cart/cart_model.dart';
import '../models/cart/cart_model_list.dart';
import '../utils/error_handler.dart';



class CartRepository {
  final ApiClient apiClient;

  CartRepository(this.apiClient);
  late SharedPreferences prefs;

  Future<CartModelList?> getMyCart() async {
    prefs=await SharedPreferences.getInstance();
    CartModelList? response;
    try {
      response=CartModelList.parsed(prefs.getString(Constants.cartItemsKey)??"[]");
    } catch (e, s) {
      throw ErrorHandler(exception: e, stackTrace: s).rethrowError();
    }

    return response;
  }

  Future<String?> addToMyCart(CartModel body) async {
    String? response;
    try {
      List<CartModel> myCart=(await getMyCart())!.cartModelList!;
      myCart.add(body);
      String json = jsonEncode(myCart.map((e) => e.toMap()).toList()).toString();
      prefs.setString(Constants.cartItemsKey, json);
      response="ok";
    } catch (e, s) {
      throw ErrorHandler(exception: e, stackTrace: s).rethrowError();
    }
    return response;
  }

  Future<String?> removeFromMyCart(int index) async {
    String? response;
    try {
      List<CartModel> myCart=(await getMyCart())!.cartModelList!;
      myCart.removeAt(index);
      String json = jsonEncode(myCart.map((e) => e.toMap()).toList()).toString();
      prefs.setString(Constants.cartItemsKey, json);
      response="ok";
    } catch (e, s) {
      throw ErrorHandler(exception: e, stackTrace: s).rethrowError();
    }
    return response;
  }

}
