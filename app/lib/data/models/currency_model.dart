import 'package:equatable/equatable.dart';

class CurrencyModel extends Equatable{
  final String currency;
  final String? countryName;

  CurrencyModel({required this.currency, this.countryName});

  @override
  List<Object> get props => [currency];
}