import 'dart:convert';



class PayItemBody {
  final String name;
  final double price;
  final int quantity;



  PayItemBody({required this.name,required this.price,required this.quantity});


  Map<String, dynamic> toMap() {
    return {
    };
  }

  String toJson() => json.encode(toMap());

  
}
