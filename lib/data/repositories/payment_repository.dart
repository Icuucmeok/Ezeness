import 'dart:convert';

import '../../config/api_config.dart';
import '../data_providers/api_client.dart';
import '../utils/error_handler.dart';



class PaymentRepository {
  final ApiClient apiClient;

  PaymentRepository(this.apiClient);



  Future<String?> createPaymentIntent(String amount) async {

    String? response;
    try {
      response = await apiClient.invokeApi<String>(
        ApiConfig.createPayment,
        body: jsonEncode({
          "amount":amount,
        }),
        requestType: HttpRequestType.post,
      );

    } catch (e, s) {
      throw ErrorHandler(exception: e, stackTrace: s).rethrowError();
    }

    return response;
  }


}
