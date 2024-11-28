import 'package:ezeness/config/api_config.dart';
import 'package:ezeness/data/data_providers/api_client.dart';
import 'package:ezeness/data/models/calculate_coin_model.dart';
import 'package:ezeness/data/utils/error_handler.dart';

class GoldCoinRepository {
  final ApiClient apiClient;
  GoldCoinRepository(this.apiClient);

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

    return response;
  }

  Future<String?> convertCoin() async {
    String? response;
    try {
      response = await apiClient.invokeApi(
        ApiConfig.convertCoin,
        requestType: HttpRequestType.get,
      );
    } catch (e, s) {
      throw ErrorHandler(exception: e, stackTrace: s).rethrowError();
    }

    return response;
  }
}
