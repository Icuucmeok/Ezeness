import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ezeness/data/models/post/post_list.dart';
import 'package:ezeness/data/repositories/explore_repository.dart';
import 'package:ezeness/data/repositories/post_repository.dart';
import 'package:ezeness/data/repositories/profile_repository.dart';
import 'package:ezeness/logic/cubit/discover_post/discover_post_cubit.dart';
import 'package:ezeness/res/app_res.dart';

import '../../../data/data_providers/api_client.dart';
import '../../../data/models/pagination_page.dart';
import '../../../data/models/post_list_view_load_more_body.dart';
import '../../../data/models/user/user_list.dart';
import '../../../data/repositories/Notification_repository.dart';
import '../../../data/repositories/search_repository.dart';

part 'load_more_state.dart';

class LoadMoreCubit extends Cubit<LoadMoreState> {
  final ApiClient apiClient;
  late PostRepository _postRepository;
  late SearchRepository _searchRepository;
  late NotificationRepository _notificationRepository;
  late ExploreRepository _exploreRepository;
  late ProfileRepository _profileRepository;
  static const String loadMoreHashTagsPostFunction = "loadMoreHashTagsPost";
  static const String loadMoreUserPostFunction = "loadMoreUserPost";
  static const String loadMoreMyPostFunction = "loadMoreMyPost";
  static const String loadMoreExploreSectionFunction =
      "loadMoreExploreSectionPost";

  LoadMoreCubit(this.apiClient) : super(LoadMoreInitial()) {
    _postRepository = PostRepository(apiClient);
    _searchRepository = SearchRepository(apiClient);
    _notificationRepository = NotificationRepository(apiClient);
    _exploreRepository = ExploreRepository(apiClient);
    _profileRepository = ProfileRepository(apiClient);
  }

  void loadMoreHashTagsPost(PaginationPage page,
      {int? hashtagId, bool isFromListViewScreen = false}) async {
    emit(LoadMoreLoading());
    try {
      final data =
          await _postRepository.getPosts(page: page, hashtagId: hashtagId);
      if (isFromListViewScreen) {
        emit(LoadMorePostListViewScreenLoaded(data!));
      } else {
        emit(LoadMorePostByHashTagsLoaded(data));
      }
    } catch (e) {
      emit(LoadMoreFailure(e));
    }
  }

  void loadMoreExploreSectionPost(PaginationPage page,
      {required String sectionKey,
      required String tabType,
      bool isFromListViewScreen = false}) async {
    emit(LoadMoreLoading());
    try {
      final data = await _postRepository
          .getExploreSectionPostList(sectionKey, tabType, page: page);
      if (isFromListViewScreen) {
        emit(LoadMorePostListViewScreenLoaded(data!));
      } else {
        emit(LoadMoreSectionPostExploreLoaded(data));
      }
    } catch (e) {
      emit(LoadMoreFailure(e));
    }
  }

  void loadMoreExploreUsers(PaginationPage page) async {
    emit(LoadMoreLoading());
    try {
      final data = await _exploreRepository.getExploreUsers(page: page);
      emit(LoadMoreUsersExploreLoaded(data));
    } catch (e) {
      emit(LoadMoreFailure(e));
    }
  }

  void getExploreTabPostList(PaginationPage page,
      {required String tabType}) async {
    emit(LoadMoreLoading());
    try {
      final data =
          await _postRepository.getExploreTabPostList(tabType, page: page);
      if (tabType == Constants.shopTabKey) {
        emit(LoadMoreShopPostExploreLoaded(data));
      }
      if (tabType == Constants.socialTabKey) {
        emit(LoadMoreSocialPostExploreLoaded(data));
      }
    } catch (e) {
      emit(LoadMoreFailure(e));
    }
  }

  void loadMoreDiscoverPost(PaginationPage page,
      {required String tabType}) async {
    emit(LoadMoreLoading());
    try {
      final data = await _postRepository.getDiscoverPosts(tabType,
          page: page, discoverCode: DiscoverPostCubit.getDiscoverCode(tabType));
      if (tabType == Constants.homeTabKey) {
        emit(LoadMoreHomeDiscoverLoaded(data));
      }
      if (tabType == Constants.shopTabKey) {
        emit(LoadMoreShopDiscoverLoaded(data));
      }
      if (tabType == Constants.socialTabKey) {
        emit(LoadMoreSocialDiscoverLoaded(data));
      }
      if (tabType == Constants.kidsTabKey) {
        emit(LoadMoreKidsDiscoverLoaded(data));
      }
    } catch (e) {
      emit(LoadMoreFailure(e));
    }
  }

  void loadMoreUserPost(PaginationPage page,
      {required int userId, bool isFromListViewScreen = false}) async {
    emit(LoadMoreLoading());
    try {
      final data = await _postRepository.getUserPosts(userId, page: page);
      if (isFromListViewScreen) {
        emit(LoadMorePostListViewScreenLoaded(data!));
      } else {
        emit(LoadMoreUserPostLoaded(data!));
      }
    } catch (e) {
      emit(LoadMoreFailure(e));
    }
  }

  void loadMoreMyPost(PaginationPage page,
      {bool isFromListViewScreen = false, String? search}) async {
    emit(LoadMoreLoading());
    try {
      final data = await _postRepository.getMyPosts(page: page, search: search);
      if (isFromListViewScreen) {
        emit(LoadMorePostListViewScreenLoaded(data!));
      } else {
        emit(LoadMoreMyPostLoaded(data!));
      }
    } catch (e) {
      emit(LoadMoreFailure(e));
    }
  }

  void loadMorePostViewScreen(PaginationPage page,
      {required int postType, required int isKids, int? randomCode}) async {
    emit(LoadMoreLoading());
    try {
      final data = await _postRepository.getPosts(
          postType: postType,
          isKids: isKids,
          page: page,
          randomCode: randomCode);
      emit(LoadMorePostViewScreenLoaded(data!));
    } catch (e) {
      emit(LoadMoreFailure(e));
    }
  }

  void loadMorePostListViewScreen(
      PaginationPage page, PostListViewLoadMoreBody body) {
    if (body.loadMoreFunctionName == loadMoreHashTagsPostFunction) {
      loadMoreHashTagsPost(page,
          hashtagId: body.hashtagId, isFromListViewScreen: true);
    }
    if (body.loadMoreFunctionName == loadMoreUserPostFunction) {
      loadMoreUserPost(page, userId: body.userId!, isFromListViewScreen: true);
    }
    if (body.loadMoreFunctionName == loadMoreMyPostFunction) {
      loadMoreMyPost(page, isFromListViewScreen: true);
    }
    if (body.loadMoreFunctionName == loadMoreExploreSectionFunction) {
      loadMoreExploreSectionPost(page,
          tabType: body.tabType!,
          isFromListViewScreen: true,
          sectionKey: body.sectionKey!);
    }
  }

  void loadMoreSearchResponse(PaginationPage page, {String? search}) async {
    emit(LoadMoreLoading());
    try {
      final data = await _searchRepository.search(search, page: page);
      emit(LoadMoreSearchResponseLoaded(data));
    } catch (e) {
      emit(LoadMoreFailure(e));
    }
  }

  void loadMoreNotificationListByType(PaginationPage page, {int? type}) async {
    emit(LoadMoreLoading());
    try {
      final data = await _notificationRepository.getNotificationsByType(
          page: page, type: type);
      emit(LoadMoreNotificationListLoaded(data));
    } catch (e) {
      emit(LoadMoreFailure(e));
    }
  }

  void loadMoreSearchTagUpPost(PaginationPage page,
      {int isKids = 0,
      String? search,
      bool withIsKids = true,
      int withLiftUp = 1}) async {
    emit(LoadMoreLoading());
    try {
      final data = await _postRepository.getPosts(
          page: page,
          isKids: isKids,
          search: search,
          withIsKids: withIsKids,
          withLiftUp: withLiftUp);
      emit(LoadMoreSearchTagUpPostLoaded(data!));
    } catch (e) {
      emit(LoadMoreFailure(e));
    }
  }

  void loadMoreSearchTagUpProfile(PaginationPage page,
      {String search = ''}) async {
    emit(LoadMoreLoading());
    try {
      final data =
          await _profileRepository.getUsers(page: page, search: search);
      emit(LoadMoreSearchTagUpProfileLoaded(data!));
    } catch (e) {
      emit(LoadMoreFailure(e));
    }
  }
}
