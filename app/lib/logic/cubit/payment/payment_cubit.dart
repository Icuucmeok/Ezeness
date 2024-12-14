import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/repositories/payment_repository.dart';

part 'payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  final PaymentRepository _paymentRepository;
  PaymentCubit(this._paymentRepository) : super(PaymentInitial());


  void createPaymentIntent(String amount) async {
    emit(PaymentLoading());
    try {
      final data =  await _paymentRepository.createPaymentIntent(amount);
      emit(PaymentLoaded(data!));
    } catch (e) {
      emit(PaymentFailure(e));
    }
  }
}
