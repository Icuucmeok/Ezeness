
import 'dart:convert';

import 'playlist.dart';



class PlaylistList {
  final List<Playlist>? playlistList;


  PlaylistList({
    this.playlistList,
  });

  static parsed(rawJson){
    final parsed = jsonDecode(rawJson)["data"].cast<Map<String, dynamic>>();
    final list= parsed.map<Playlist>((json) => Playlist.fromJson(json)).toList();
    return PlaylistList(playlistList: list);
  }
  static parsedToList(rawJson){
    final parsed = rawJson.cast<Map<String, dynamic>>();
    final list= parsed.map<Playlist>((json) => Playlist.fromJson(json)).toList();
    return list;
  }

}
