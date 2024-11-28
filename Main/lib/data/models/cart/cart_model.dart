import 'dart:convert';

import '../pick_location_model.dart';
import '../post/post.dart';

class CartModel {
  final Post post;
  final int orderCount;
  final bool isDelivery;
  final PickLocationModel? deliveryLocation;
  final String? orderDate;
  final bool isVip;

 static double calculateOrderTotalAmount(List<CartModel> cart){
    double totalAmount=0;
    cart.forEach((e) {
      double itemsPrice=e.post.price!*e.orderCount;
      double postTotalPrice=(e.post.discount!=null && e.post.discount!=0)?
      (itemsPrice-(itemsPrice*e.post.discount!)/100)+(e.isDelivery?e.post.deliveryCharge!:0)
          :itemsPrice+(e.isDelivery?e.post.deliveryCharge!:0);
      totalAmount+=postTotalPrice;
    });
    return totalAmount;
  }
  CartModel({
   required this.post,
   required this.orderCount,
    required this.isDelivery,
    this.isVip=false,
    this.orderDate,
    this.deliveryLocation,

  });

  factory CartModel.fromJson(Map<String, dynamic> json) =>
      CartModel(
        post: Post.fromJson(json['post']),
        orderCount: json['orderCount'] as int,
        isDelivery: json['isDelivery'] as bool,
        isVip: json['isVip'] as bool,
        orderDate: json['orderDate'] as String?,
        deliveryLocation:json['deliveryLocation']==null?null:PickLocationModel.fromJson(json['deliveryLocation']),
      );

  CartModel copyWith({
     Post? post,
     int? orderCount,
     bool? isDelivery,
     PickLocationModel? deliveryLocation,
     String? orderDate,
     bool? isVip,

  }) =>
      CartModel(
        post: post ?? this.post,
        orderCount: orderCount ?? this.orderCount,
        isDelivery: isDelivery ?? this.isDelivery,
        deliveryLocation: deliveryLocation ?? this.deliveryLocation,
        orderDate: orderDate ?? this.orderDate,
        isVip: isVip ?? this.isVip,

      );

  Map<String, dynamic> toMap() {
    return {
      "post": post.toMap(),
      "orderCount": orderCount,
      "isDelivery": isDelivery,
      "deliveryLocation": deliveryLocation?.toMap(),
      "orderDate": orderDate,
      "isVip": isVip,
    };
  }

  String toJson() => json.encode(toMap());
}
