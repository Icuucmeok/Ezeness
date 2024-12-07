import 'package:ezeness/config/api_config.dart';
import 'package:ezeness/data/data_providers/api_client.dart';
import 'package:ezeness/data/models/calculate_coin_model.dart';
import 'package:ezeness/data/utils/error_handler.dart';

class GoldCoinRepository {
  final ApiClient apiClient;
  bool isTesting; // for testing only
  GoldCoinRepository(this.apiClient, {this.isTesting = false});

  Future<CalculateCoinModel?> calculateCoin() async {
    CalculateCoinModel? response;
    try {
      response = await apiClient.invokeApi<CalculateCoinModel>(
        ApiConfig.calculateCoin,
        requestType: HttpRequestType.get,
      );
    } catch (e, s) {
      throw ErrorHandler(exception: e, stackTrace: s).rethrowError();
    }

    if (isTesting) {
      // for testing remove for publishing
      final calculateCoinModel = CalculateCoinModel(
        amount: 100.0,
        coins: 50,
        vat: 15.0,
        handling: 5.0,
        exchangeRate: 1.2,
      );
      return calculateCoinModel;
    } else {
      return response;
    }
  }

  Future<String?> convertCoin({bool isTesting = false}) async {
    String? response;
    try {
      response = await apiClient.invokeApi(
        ApiConfig.convertCoin,
        requestType: HttpRequestType.get,
      );
    } catch (e, s) {
      throw ErrorHandler(exception: e, stackTrace: s).rethrowError();
    }

    if (isTesting) {
    } else {
      return response;
    }
    print("response from convert coin is $response");
    return null;
  }
}
