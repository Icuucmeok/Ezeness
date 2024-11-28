import 'dart:convert';



class PostListViewLoadMoreBody {
  final int? hashtagId;
  final String loadMoreFunctionName;
  final int? userId;
  final String? sectionKey;
  final String? tabType;
  PostListViewLoadMoreBody({required this.loadMoreFunctionName,this.hashtagId,this.userId,this.tabType,this.sectionKey});


  Map<String, dynamic> toMap() {
    return {
    };
  }

  String toJson() => json.encode(toMap());

  
}
