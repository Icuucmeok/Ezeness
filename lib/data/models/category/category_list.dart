
import 'dart:convert';

import 'category.dart';



class CategoryList {
  final List<Category>? categoryList;


  CategoryList({
    this.categoryList,
  });

  static parsed(rawJson){
    final parsed = jsonDecode(rawJson)["data"].cast<Map<String, dynamic>>();
    final list= parsed.map<Category>((json) => Category.fromJson(json)).toList();
    return CategoryList(categoryList: list);
  }
  static parsedToList(rawJson){
    final parsed = rawJson.cast<Map<String, dynamic>>();
    final list= parsed.map<Category>((json) => Category.fromJson(json)).toList();
    return list;
  }

}
