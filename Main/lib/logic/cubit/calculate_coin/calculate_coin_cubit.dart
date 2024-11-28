import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ezeness/data/models/calculate_coin_model.dart';
import 'package:ezeness/data/repositories/gold_coin_repository.dart';

part 'calculate_coin_state.dart';

class CalculateCoinCubit extends Cubit<CalculateCoinState> {
  final GoldCoinRepository _goldCoinRepository;
  CalculateCoinCubit(this._goldCoinRepository) : super(CalculateCoinInitial());

  void calculateCoin() async {
    emit(CalculateCoinLoading());
    try {
      final data = await _goldCoinRepository.calculateCoin();
      emit(CalculateCoinDone(data!));
    } catch (e) {
      emit(CalculateCoinFailure(e));
    }
  }
}
