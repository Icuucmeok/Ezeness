// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CalculateCoinModel {
  final num amount;
  final num coins;
  final num vat;
  final num handling;
  final num exchangeRate;
  CalculateCoinModel({
    required this.amount,
    required this.coins,
    required this.vat,
    required this.handling,
    required this.exchangeRate,
  });

  factory CalculateCoinModel.fromJson(Map<String, dynamic> json) {
    return CalculateCoinModel(
      amount: json['amount'],
      coins: json['coins'],
      exchangeRate: json['exchange_rate'],
      handling: json['handling'],
      vat: json['vat'],
    );
  }

  static parsed(rawJson) {
    return CalculateCoinModel.fromJson(jsonDecode(rawJson)["data"]);
  }
}
