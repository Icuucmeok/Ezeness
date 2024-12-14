import '../../config/api_config.dart';
import '../data_providers/api_client.dart';
import '../models/category/category.dart';
import '../models/category/category_list.dart';
import '../utils/error_handler.dart';



class CategoryRepository {
  final ApiClient apiClient;

  CategoryRepository(this.apiClient);


  Future<CategoryList?> getCategories({required bool withKidsContent,int? parentCategoryId, int? isForKids,int? postType,int? userId,int? isVip}) async {

    CategoryList? response;
    try {
      response = await apiClient.invokeApi<CategoryList>(
        ApiConfig.categories+"?is_all=1&parent_category_id=${parentCategoryId??""}"
            "${postType==null?"":"&type=$postType"}${userId==null?"":"&user_id=$userId"}${isVip==null?"":"&is_vip=$isVip"}",
        requestType: HttpRequestType.get,
        headers: apiClient.head(isKids:isForKids,withIsKids:!withKidsContent || isForKids==1),
      );

    } catch (e, s) {
      throw ErrorHandler(exception: e, stackTrace: s).rethrowError();
    }

    return response;
  }

  Future<Category?> getCategory(int id) async {

    Category? response;
    try {
      response = await apiClient.invokeApi<Category>(
        ApiConfig.category+"/$id",
        requestType: HttpRequestType.get,
      );

    } catch (e, s) {
      throw ErrorHandler(exception: e, stackTrace: s).rethrowError();
    }

    return response;
  }


}
