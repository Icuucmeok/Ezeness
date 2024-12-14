import 'dart:convert';



class DayTime {
  final int id;
  final String? dayName;
  final String? dayCode;
   String? fromTime;
   String? toTime;



  DayTime({
    required this.id,
     this.dayName,
     this.dayCode,
     this.fromTime,
     this.toTime,

  });

  factory DayTime.fromJson(Map<String, dynamic> json) {
    return DayTime(
      id: json['day_of_week'] as int,
      fromTime: json['start'] as String?,
      toTime: json['end'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'day_of_week': id,
      'start': fromTime,
      'end': toTime,
    };
  }

  String toJson() => json.encode(toMap());

  static parsed(rawJson) {
    return DayTime.fromJson(jsonDecode(rawJson));
  }
  static parsedToList(rawJson){
    final parsed = rawJson.cast<Map<String, dynamic>>();
    return parsed.map<DayTime>((json) => DayTime.fromJson(json)).toList();
  }
}
