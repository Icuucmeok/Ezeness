import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ezeness/data/models/calculate_coin_model.dart';
import 'package:ezeness/data/repositories/gold_coin_repository.dart';

part 'calculate_coin_state.dart';

class CalculateCoinCubit extends Cubit<CalculateCoinState> {
  final GoldCoinRepository _goldCoinRepository;

  CalculateCoinCubit(this._goldCoinRepository) : super(CalculateCoinInitial());

  void calculateCoin({bool isTesting = false}) async {
    emit(CalculateCoinLoading());
    try {
      if (isTesting) {
        // for testing only remove for publishing
        final calculateCoinModel = CalculateCoinModel(
          amount: 100.0,
          coins: 50,
          vat: 15.0,
          handling: 5.0,
          exchangeRate: 1.2,
        );
        emit(CalculateCoinDone(calculateCoinModel));
      } else {
        final data = await _goldCoinRepository.calculateCoin();
        emit(CalculateCoinDone(data!));
      }
    } catch (e) {
      emit(CalculateCoinFailure(e));
    }
  }
}
