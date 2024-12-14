import 'dart:convert';

import 'package:ezeness/data/models/comment/comment_list.dart';
import 'package:ezeness/data/models/hashtag/hashtag_list.dart';
import 'package:ezeness/data/models/post/post.dart';
import 'package:ezeness/data/models/post/post_list.dart';
import 'package:ezeness/logic/cubit/explore_post/explore_post_cubit.dart';
import 'package:ezeness/res/app_res.dart';

import '../../config/api_config.dart';
import '../data_providers/api_client.dart';
import '../models/app_file.dart';
import '../models/comment/comment.dart';
import '../models/pagination_page.dart';
import '../models/post/add_post_body.dart';
import '../models/user/bookmark_user_list.dart';
import '../models/user/liftup_user_list.dart';
import '../models/user/like_user_list.dart';
import '../utils/error_handler.dart';

class PostRepository {
  final ApiClient apiClient;

  PostRepository(this.apiClient);

  Future<Post?> getPost(int id, {int? liftUpId}) async {
    Post? response;
    try {
      response = await apiClient.invokeApi<Post>(
          ApiConfig.post +
              "/$id"
                  "${liftUpId == null ? "" : "?liftup_id=$liftUpId"}",
          requestType: HttpRequestType.get,
          headers: apiClient.head(withIsKids: false));
    } catch (e, s) {
      throw ErrorHandler(exception: e, stackTrace: s).rethrowError();
    }

    return response;
  }

  Future<PostList?> getPostsByCategoryId(int id, bool isMine,
      {int? userId, int? postType, required int isForKids, int? isVip}) async {
    PostList? response;
    postType = postType == Constants.postUpKey ? null : postType;
    try {
      response = await apiClient.invokeApi<PostList>(
          ApiConfig.post +
              "?category_id=$id&is_mine=${isMine ? 1 : 0}${userId == null ? "" : "&user_id=$userId"}${postType == null ? "" : "&type=$postType"}"
                  "${isVip == null ? "" : "&is_vip=$isVip"}",
          requestType: HttpRequestType.get,
          headers:
              apiClient.head(isKids: isForKids, withIsKids: isForKids == 1));
    } catch (e, s) {
      throw ErrorHandler(exception: e, stackTrace: s).rethrowError();
    }

    return response;
  }

  Future<PostList?> getPostsByPlaylistId(int id) async {
    PostList? response;
    try {
      response = await apiClient.invokeApi<PostList>(
        ApiConfig.playListPost + "/$id",
        requestType: HttpRequestType.get,
      );
    } catch (e, s) {
      throw ErrorHandler(exception: e, stackTrace: s).rethrowError();
    }

    return response;
  }

  Future<PostList?> getUserPosts(int userId, {PaginationPage? page}) async {
    PostList? response;
    try {
      response = await apiClient.invokeApi<PostList>(
        ApiConfig.userPost +
            "?user_id=$userId${page == null ? "" : "&per_page=${page.pageSize}&page=${page.currentPage}"}",
        requestType: HttpRequestType.get,
        headers: apiClient.head(withIsKids: apiClient.isKids == 1),
      );
    } catch (e, s) {
      throw ErrorHandler(exception: e, stackTrace: s).rethrowError();
    }

    return response;
  }

  Future<String?> likeUnLikePost(int postId) async {
    String? response;
    try {
      response = await apiClient.invokeApi<String>(
        ApiConfig.postLikeUnlike + "/$postId/like",
        requestType: HttpRequestType.post,
        headers: apiClient.head(withIsKids: false),
      );
    } catch (e, s) {
      throw ErrorHandler(exception: e, stackTrace: s).rethrowError();
    }

    return response;
  }

  Future<String?> liftUpUnLiftUpPost(int postId) async {
    String? response;
    try {
      response = await apiClient.invokeApi<String>(
        ApiConfig.postLiftUpUnLiftUp,
        body: json.encode({"post_id": postId}),
        requestType: HttpRequestType.post,
        headers: apiClient.head(withIsKids: false),
      );
    } catch (e, s) {
      throw ErrorHandler(exception: e, stackTrace: s).rethrowError();
    }

    return response;
  }

  Future<LikeUserList?> getPostUsersLikeList(int postId) async {
    LikeUserList? response;
    try {
      response = await apiClient.invokeApi<LikeUserList>(
        ApiConfig.postLikeUnlike + "/$postId/like",
        requestType: HttpRequestType.get,
        headers: apiClient.head(withIsKids: false),
      );
    } catch (e, s) {
      throw ErrorHandler(exception: e, stackTrace: s).rethrowError();
    }

    return response;
  }

  Future<LiftUpUserList?> getPostUsersLiftUpList(int postId) async {
    LiftUpUserList? response;
    try {
      response = await apiClient.invokeApi<LiftUpUserList>(
        ApiConfig.postLiftUpUsers + "?post_id=$postId",
        requestType: HttpRequestType.get,
        headers: apiClient.head(withIsKids: false),
      );
    } catch (e, s) {
      throw ErrorHandler(exception: e, stackTrace: s).rethrowError();
    }

    return response;
  }

  Future<String?> deletePost(int postId) async {
    String? response;
    try {
      response = await apiClient.invokeApi<String>(
        ApiConfig.deletePost + "/$postId",
        requestType: HttpRequestType.delete,
        headers: apiClient.head(withIsKids: false),
      );
    } catch (e, s) {
      throw ErrorHandler(exception: e, stackTrace: s).rethrowError();
    }

    return response;
  }

  Future<String?> reportPost(int postId, int reasonId) async {
    String? response;
    try {
      response = await apiClient.invokeApi<String>(
        ApiConfig.reportPost,
        requestType: HttpRequestType.post,
        body: json.encode({
          "post_id": postId,
          "reason_id": reasonId,
        }),
        headers: apiClient.head(withIsKids: false),
      );
    } catch (e, s) {
      throw ErrorHandler(exception: e, stackTrace: s).rethrowError();
    }

    return response;
  }

  Future<String?> bookmarkUnBookmarkPost(int postId) async {
    String? response;
    try {
      response = await apiClient.invokeApi<String>(
        ApiConfig.postFavouriteUnFavourite + "/$postId/favourite",
        requestType: HttpRequestType.post,
        headers: apiClient.head(withIsKids: false),
      );
    } catch (e, s) {
      throw ErrorHandler(exception: e, stackTrace: s).rethrowError();
    }

    return response;
  }

  Future<BookmarkUserList?> getPostUsersBookmarkList(int postId) async {
    BookmarkUserList? response;
    try {
      response = await apiClient.invokeApi<BookmarkUserList>(
        ApiConfig.postFavouriteUnFavourite + "/$postId/favourite",
        requestType: HttpRequestType.get,
        headers: apiClient.head(withIsKids: false),
      );
    } catch (e, s) {
      throw ErrorHandler(exception: e, stackTrace: s).rethrowError();
    }

    return response;
  }

  Future<PostList?> getExploreSectionPostList(String sectionKey, String tabType,
      {PaginationPage? page}) async {
    PostList? response;

    String getSectionEndPoint() {
      switch (sectionKey) {
        case Constants.forYouSectionKey:
          return ApiConfig.postForYou +
              "?section=$tabType&random_code=${ExplorePostCubit.forYouSectionRandomCode}";

        case Constants.trendingSectionKey:
          return ApiConfig.postTrending +
              "?section=$tabType&random_code=${ExplorePostCubit.trendingSectionRandomCode}";

        case Constants.liftUpSectionKey:
          return ApiConfig.postLiftUp + "?section=$tabType";

        case Constants.bestSellersSectionKey:
          return ApiConfig.postBestSeller + "?section=$tabType";

        case Constants.shopSectionKey:
          return ApiConfig.post +
              "?post_types[]=1&post_types[]=2&post_types[]=3";

        case Constants.socialSectionKey:
          return ApiConfig.post + "?type=0";

        case Constants.vipSectionKey:
          if (tabType == Constants.shopTabKey)
            return ApiConfig.post +
                "?is_vip=1&post_types[]=1&post_types[]=2&post_types[]=3";

          if (tabType == Constants.socialTabKey)
            return ApiConfig.post + "?is_vip=1&type=0";

          return ApiConfig.post + "?is_vip=1";

        case Constants.islamSectionKey:
          if (tabType == Constants.shopTabKey)
            return ApiConfig.post +
                "?is_islam=1&post_types[]=1&post_types[]=2&post_types[]=3";

          if (tabType == Constants.socialTabKey)
            return ApiConfig.post + "?is_islam=1&type=0";

          return ApiConfig.post + "?is_islam=1";

        case Constants.savedSectionKey:
          if (tabType == Constants.shopTabKey)
            return ApiConfig.post +
                "?is_favourite=1&post_types[]=1&post_types[]=2&post_types[]=3";

          if (tabType == Constants.socialTabKey)
            return ApiConfig.post + "?is_favourite=1&type=0";

          return ApiConfig.post + "?is_favourite=1";

        default:
          return ApiConfig.post;
      }
    }

    try {
      response = await apiClient.invokeApi<PostList>(
        getSectionEndPoint() +
            "${page == null ? "" : "&per_page=${page.pageSize}&page=${page.currentPage}"}",
        requestType: HttpRequestType.get,
        headers: apiClient.head(
            withIsKids:
                apiClient.isKids == 1 || tabType == Constants.kidsTabKey,
            isKids: tabType == Constants.kidsTabKey ? 1 : apiClient.isKids),
      );
    } catch (e, s) {
      throw ErrorHandler(exception: e, stackTrace: s).rethrowError();
    }

    return response;
  }

  Future<PostList?> getExploreTabPostList(String tabType,
      {PaginationPage? page}) async {
    PostList? response;

    String getTabEndPoint() {
      switch (tabType) {
        case Constants.shopTabKey:
          return ApiConfig.post +
              "?post_types[]=1&post_types[]=2&post_types[]=3";

        case Constants.socialTabKey:
          return ApiConfig.post + "?type=0";

        default:
          return ApiConfig.post;
      }
    }

    try {
      response = await apiClient.invokeApi<PostList>(
        getTabEndPoint() +
            "${page == null ? "" : "&per_page=${page.pageSize}&page=${page.currentPage}"}",
        requestType: HttpRequestType.get,
        headers: apiClient.head(
            withIsKids:
                apiClient.isKids == 1 || tabType == Constants.kidsTabKey,
            isKids: tabType == Constants.kidsTabKey ? 1 : apiClient.isKids),
      );
    } catch (e, s) {
      throw ErrorHandler(exception: e, stackTrace: s).rethrowError();
    }

    return response;
  }

  Future<PostList?> getPosts(
      {int? postType,
      int? isKids,
      String? search,
      int? postId,
      int? hashtagId,
      PaginationPage? page,
      bool withIsKids = true,
      int withLiftUp = 1,
      int? randomCode}) async {
    PostList? response;
    try {
      response = await apiClient.invokeApi<PostList>(
        ApiConfig.post +
            "?with_liftup=$withLiftUp${postType == null ? "" : "&type=$postType"}${search == null ? "" : "&search=${Uri.encodeComponent(search)}"}"
                "${postId == null ? "" : "&post_id=$postId"}${hashtagId == null ? "" : "&hashtag_id=$hashtagId"}${randomCode == null ? "" : "&random_code=$randomCode"}"
                "${page == null ? "" : "&per_page=${page.pageSize}&page=${page.currentPage}"}",
        requestType: HttpRequestType.get,
        headers: apiClient.head(isKids: isKids, withIsKids: withIsKids),
      );
    } catch (e, s) {
      throw ErrorHandler(exception: e, stackTrace: s).rethrowError();
    }

    return response;
  }

  Future<PostList?> getDiscoverPosts(String? tabType,
      {PaginationPage? page, int? discoverCode}) async {
    PostList? response;
    try {
      response = await apiClient.invokeApi<PostList>(
        ApiConfig.discover +
            "?section=$tabType${discoverCode == null ? "" : "&discover_code=$discoverCode"}"
                "${page == null ? "" : "&per_page=${page.pageSize}&page=${page.currentPage}"}",
        requestType: HttpRequestType.get,
        headers: apiClient.head(
            withIsKids:
                apiClient.isKids == 1 || tabType == Constants.kidsTabKey,
            isKids: tabType == Constants.kidsTabKey ? 1 : apiClient.isKids),
      );
    } catch (e, s) {
      throw ErrorHandler(exception: e, stackTrace: s).rethrowError();
    }

    return response;
  }

  Future<PostList?> getMyPosts(
      {PaginationPage? page, String? search, int withLiftUp = 1}) async {
    PostList? response;
    try {
      response = await apiClient.invokeApi<PostList>(
        ApiConfig.myPost +
            "?with_liftup=$withLiftUp${page == null ? "" : "&per_page=${page.pageSize}&page=${page.currentPage}"}${search == null ? "" : "&search=$search"}",
        requestType: HttpRequestType.get,
        headers: apiClient.head(withIsKids: apiClient.isKids == 1),
      );
    } catch (e, s) {
      throw ErrorHandler(exception: e, stackTrace: s).rethrowError();
    }

    return response;
  }

  Future<HashtagList?> getHashtag(String search) async {
    HashtagList? response;
    try {
      response = await apiClient.invokeApi<HashtagList>(
        ApiConfig.hashtag + "?search=$search",
        requestType: HttpRequestType.get,
        headers: apiClient.head(withIsKids: false),
      );
    } catch (e, s) {
      throw ErrorHandler(exception: e, stackTrace: s).rethrowError();
    }

    return response;
  }

  Future<String?> addPost(AddPostBody body,
      {void Function(double)? onProgress}) async {
    String? response;
    try {
      response = await apiClient.invokeApi<String>(
        onProgress: onProgress,
        ApiConfig.addPost,
        headers: apiClient.head(
            contentType: "multipart/form-data", withIsKids: false),
        body: body.toMap(),
        requestType: HttpRequestType.post,
        postRequestType: PostRequestType.uploadFile,
      );
      response = json.decode(response!)["data"]["id"].toString();
    } catch (e, s) {
      throw ErrorHandler(exception: e, stackTrace: s).rethrowError();
    }

    return response;
  }

  Future<String?> validatePost(AddPostBody body,
      {void Function(double)? onProgress}) async {
    String? response;
    try {
      response = await apiClient.invokeApi<String>(
        ApiConfig.validatePost,
        onProgress: onProgress,
        headers: apiClient.head(
            contentType: "multipart/form-data", withIsKids: false),
        body: body.toMap(),
        requestType: HttpRequestType.post,
        postRequestType: PostRequestType.uploadFile,
      );
    } catch (e, s) {
      throw ErrorHandler(exception: e, stackTrace: s).rethrowError();
    }

    return response;
  }

  Future<Post?> updatePost(AddPostBody body, int postId,
      {void Function(double)? onProgress}) async {
    Post? response;
    try {
      response = await apiClient.invokeApi<Post>(
        onProgress: onProgress,
        ApiConfig.updatePost + "/$postId",
        headers: apiClient.head(
            contentType: "multipart/form-data", withIsKids: false),
        body: body.toMap(),
        requestType: HttpRequestType.post,
        postRequestType: PostRequestType.uploadFile,
      );
    } catch (e, s) {
      throw ErrorHandler(exception: e, stackTrace: s).rethrowError();
    }

    return response;
  }

  Future<String?> uploadPostMedia(int postId, List<AppFile> files) async {
    String? response;
    try {
      for (var f in files) {
        response = await apiClient.invokeApi<String>(
          ApiConfig.uploadPostMedia + "/$postId/media",
          headers: apiClient.head(
              contentType: "multipart/form-data", withIsKids: false),
          body: {},
          requestType: HttpRequestType.post,
          files: [f],
          postRequestType: PostRequestType.uploadFile,
        );
      }
      ;
    } catch (e, s) {
      throw ErrorHandler(exception: e, stackTrace: s).rethrowError();
    }

    return response;
  }

  Future<CommentModel?> addComment(int postId, String comment,
      {int? commentId}) async {
    CommentModel? response;
    try {
      response = await apiClient.invokeApi<CommentModel>(
        ApiConfig.addComment,
        body: jsonEncode({
          "post_id": postId,
          "comment": comment,
          if (commentId != null) "comment_id": commentId,
        }),
        requestType: HttpRequestType.post,
        headers: apiClient.head(withIsKids: false),
      );
    } catch (e, s) {
      throw ErrorHandler(exception: e, stackTrace: s).rethrowError();
    }

    return response;
  }

  Future<String?> deleteComment(int id) async {
    String? response;
    try {
      response = await apiClient.invokeApi<String>(
        ApiConfig.deleteComment + "/$id",
        requestType: HttpRequestType.delete,
        headers: apiClient.head(withIsKids: false),
      );
    } catch (e, s) {
      throw ErrorHandler(exception: e, stackTrace: s).rethrowError();
    }
    response = id.toString();
    return response;
  }

  Future<String?> likeUnLikeComment(int id) async {
    String? response;
    try {
      response = await apiClient.invokeApi<String>(
        ApiConfig.likeUnLikeComment,
        requestType: HttpRequestType.post,
        body: json.encode({
          "comment_id": id,
        }),
        headers: apiClient.head(withIsKids: false),
      );
    } catch (e, s) {
      throw ErrorHandler(exception: e, stackTrace: s).rethrowError();
    }
    response = id.toString();
    return response;
  }

  Future<CommentList?> getComments(int postId) async {
    CommentList? response;
    try {
      response = await apiClient.invokeApi<CommentList>(
        ApiConfig.getComments + "?post_id=$postId&is_all=1",
        requestType: HttpRequestType.get,
        headers: apiClient.head(withIsKids: false),
      );
    } catch (e, s) {
      throw ErrorHandler(exception: e, stackTrace: s).rethrowError();
    }

    return response;
  }

  Future<String?> increaseViews(int id, {bool isFromDiscover = false}) async {
    String? response;
    try {
      response = await apiClient.invokeApi<String>(
        ApiConfig.increaseViews +
            "/$id"
                "${isFromDiscover ? "?section=DISCOVER" : ""}",
        requestType: HttpRequestType.get,
        headers: apiClient.head(withIsKids: false),
      );
    } catch (e, s) {
      throw ErrorHandler(exception: e, stackTrace: s).rethrowError();
    }
    return response;
  }
}
