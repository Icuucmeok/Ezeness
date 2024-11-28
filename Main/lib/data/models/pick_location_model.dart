import 'dart:convert';



class PickLocationModel {
   double lat;
   double lng;
   String location;



  PickLocationModel({
    required this.lat,
    required this.lng,
    required this.location,

  });

  factory PickLocationModel.fromJson(Map<String, dynamic> json) =>PickLocationModel(
    location: json['location'] as String,
    lat: double.parse(json['lat'].toString()),
    lng: double.parse(json['lng'].toString()),
  );

  Map<String, dynamic> toMap() {
    return {
      "location": location,
      "lat": lat,
      "lng": lng,
    };
  }

  String toJson() => json.encode(toMap());

  // static parsed(rawJson) {
  //   return PickLocationModel.fromJson(jsonDecode(rawJson));
  // }
}
