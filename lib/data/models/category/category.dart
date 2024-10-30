import 'dart:convert';



class Category {
  final int? id;
  final int? parentCategoryId;
  final String? name;
  final String? image;
  final String? processingTime;
  final String? deliveryTime;
  final bool? isKids;
  final bool? hasPost;
  final bool? isLast;
  final List<CategoryOption>? options;
  final String? type;
  Category({
    this.id,
    this.parentCategoryId,
    this.name,
    this.image,
    this.processingTime,
    this.deliveryTime,
    this.isKids,
    this.options,
    this.hasPost,
    this.type,
    this.isLast,
  });

  factory Category.fromJson(Map<String, dynamic> json) =>
      Category(
        id: json['id'] as int?,
        parentCategoryId: json['parent_category_id'] as int?,
        name: json['name'] as String?,
        image: json['image'] as String?,
        processingTime: json['processing_time'].toString(),
        deliveryTime: json['delivery_time'].toString(),
        isKids: json['is_kids'] ==1,
        options:json['options']==null?null:CategoryOption.parsed(json['options']),
        hasPost: json['has_post'] as bool?,
        isLast: json['is_last'] as bool?,
      );

  Map<String, dynamic> toMap() {
    return {
    };
  }

  String toJson() => json.encode(toMap());

  static parsed(rawJson) {
    return Category.fromJson(jsonDecode(rawJson)["data"]);
  }
}



class CategoryOption {
  final int? id;
  final bool? isRequired;
  final String? name;
  String? value;
  bool isError;
  final int? type;
  final List<String>? options;


  CategoryOption({
    this.id,
    this.isRequired,
    this.isError=false,
    this.name,
    this.value,
    this.options,
    this.type,
  });

  factory CategoryOption.fromJson(Map<String, dynamic> json) =>
      CategoryOption(
        id: json['id'] as int?,
        isRequired: json['is_required'] == 1,
        name: json['name'] as String?,
        value: json['value'] as String?,
        type: json['type'] as int?,
        options: json['options']==null?[]:List<String>.from(json['options']).toList(),
      );

  static List<CategoryOption> parsed(rawJson){
    final parsed = rawJson.cast<Map<String, dynamic>>();
    final list= parsed.map<CategoryOption>((json) => CategoryOption.fromJson(json)).toList();
    return list;
  }
}
