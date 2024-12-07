import 'package:ezeness/data/models/explore_response.dart';
import 'package:ezeness/logic/cubit/explore_users/explore_users_cubit.dart';

import '../../config/api_config.dart';
import '../../res/app_res.dart';
import '../data_providers/api_client.dart';
import '../models/pagination_page.dart';
import '../models/user/user_list.dart';
import '../utils/error_handler.dart';

class ExploreRepository {
  final ApiClient apiClient;

  ExploreRepository(this.apiClient);

  Future<ExploreResponse?> getExploreResponse(String tabType) async {
    ExploreResponse? response;
    try {
      response = await apiClient.invokeApi<ExploreResponse>(
        ApiConfig.explore + "?section=$tabType",
        requestType: HttpRequestType.get,
        headers:  apiClient.head(withIsKids: apiClient.isKids==1 || tabType==Constants.kidsTabKey,isKids: tabType==Constants.kidsTabKey?1:apiClient.isKids),
      );
    } catch (e, s) {
      throw ErrorHandler(exception: e, stackTrace: s).rethrowError();
    }

    return response;
  }


  Future<UserList?> getExploreUsers({PaginationPage? page}) async {
    UserList? response;
    try {
      response = await apiClient.invokeApi<UserList>(
        ApiConfig.exploreUsers + "?random_code=${ExploreUsersCubit.usersRandomCode}"
            "${page == null ? "" : "&per_page=${page.pageSize}&page=${page.currentPage}"}",
        requestType: HttpRequestType.get,
      );
    } catch (e, s) {
      throw ErrorHandler(exception: e, stackTrace: s).rethrowError();
    }

    return response;
  }
}
