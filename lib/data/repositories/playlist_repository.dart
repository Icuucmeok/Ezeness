import 'dart:convert';
import 'package:ezeness/data/models/playlist/playlist.dart';

import '../../config/api_config.dart';
import '../data_providers/api_client.dart';
import '../utils/error_handler.dart';

class PlayListRepository {
  final ApiClient apiClient;

  PlayListRepository(this.apiClient);

  Future<Playlist?> createPlayList(String name) async {
    Playlist? response;
    try {
      response = await apiClient.invokeApi<Playlist>(
        ApiConfig.playList,
        headers:
            apiClient.head(contentType: "application/json", withIsKids: false),
        body: json.encode({
          "name": name,
        }),
        requestType: HttpRequestType.post,
      );
    } catch (e, s) {
      throw ErrorHandler(exception: e, stackTrace: s).rethrowError();
    }

    return response;
  }


  Future<String?> addRemovePostPlayList(int postId, int playlistId) async {
    String? response;
    try {
      response = await apiClient.invokeApi<String>(
        ApiConfig.playList+"/$playlistId/sync",
        headers:
        apiClient.head(contentType: "application/json", withIsKids: false),
        body: json.encode({
          "post_id": postId,
        }),
        requestType: HttpRequestType.post,
      );
    } catch (e, s) {
      throw ErrorHandler(exception: e, stackTrace: s).rethrowError();
    }

    return response;
  }

}
