import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ezeness/data/repositories/gold_coin_repository.dart';

part 'convert_coin_state.dart';

class ConvertCoinCubit extends Cubit<ConvertCoinState> {
  final GoldCoinRepository _goldCoinRepository;
  ConvertCoinCubit(this._goldCoinRepository) : super(ConvertCoinInitial());

  void convertCoin() async {
    emit(ConvertCoinLoading());
    try {
      await _goldCoinRepository.convertCoin();
      emit(ConvertCoinDone());
    } catch (e) {
      emit(ConvertCoinFailure(e));
    }
  }
}
