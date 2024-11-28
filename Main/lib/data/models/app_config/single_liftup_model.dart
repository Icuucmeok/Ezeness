// ignore_for_file: public_member_api_docs, sort_constructors_first
class SingleLiftupModel {
  final int id;
  final String? name;
  final String? value;
  final String? content;
  const SingleLiftupModel({
    required this.id,
    this.name,
    this.value,
    this.content,
  });

  factory SingleLiftupModel.fromJson(Map<String, dynamic> json) {
    return SingleLiftupModel(
      id: json['id'],
      content: json['content'],
      name: json['name'],
      value: json['value'],
    );
  }
}
