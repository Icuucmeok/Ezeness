import '../../config/api_config.dart';
import '../data_providers/api_client.dart';
import '../models/pagination_page.dart';
import '../models/search_response.dart';
import '../utils/error_handler.dart';

class SearchRepository {
  final ApiClient apiClient;

  SearchRepository(this.apiClient);

  Future<SearchResponse?> search(text, {PaginationPage? page}) async {
    SearchResponse? response;
    try {
      response = await apiClient.invokeApi<SearchResponse>(
        ApiConfig.search +
            "?search=${Uri.encodeComponent(text)}" +
            "${page == null ? "" : "&per_page=${page.pageSize}&page=${page.currentPage}"}",
        requestType: HttpRequestType.get,
      );
    } catch (e, s) {
      throw ErrorHandler(exception: e, stackTrace: s).rethrowError();
    }

    return response;
  }
}
