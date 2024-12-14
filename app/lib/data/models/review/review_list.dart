
import 'dart:convert';

import 'review.dart';



class ReviewList {
  final List<ReviewModel>? reviewList;


  ReviewList({
    this.reviewList,
  });

  static parsed(rawJson){
    final parsed = jsonDecode(rawJson)["data"]["reviews"].cast<Map<String, dynamic>>();
    final list= parsed.map<ReviewModel>((json) => ReviewModel.fromJson(json)).toList();
    return ReviewList(reviewList: list);
  }


}
