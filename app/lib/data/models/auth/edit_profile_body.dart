import 'dart:convert';

class EditProfileBody {
  final String? phoneNumber;
  final String? email;
  final String? codeNumber;
  final String? name;
  final String? birthDate;
  final String? website;
  final String? bio;
  final String? username;
  final int? gender;
  final double? lat;
  final double? lng;
  final String? address;
  final String? contactNumber;
  final String? contactNumberCode;
  static const String imageKey = "image";
  static const String coverImageKey = "cover_image";
  final String? userNationality;

  ///this only for edit profile after social sign up
  final String? inviteCode;

  EditProfileBody({
    this.phoneNumber,
    this.codeNumber,
    this.email,
    this.website,
    this.bio,
    required this.name,
    required this.birthDate,
    required this.lat,
    required this.lng,
    required this.gender,
    required this.username,
    required this.address,
    this.contactNumber,
    this.contactNumberCode,
    this.inviteCode,
    this.userNationality,
  });

  EditProfileBody copyWith({
    String? phoneNumber,
    String? email,
    String? codeNumber,
    String? name,
    String? birthDate,
    String? website,
    String? bio,
    String? username,
    int? gender,
    double? lat,
    double? lng,
    String? address,
    String? contactNumber,
    String? contactNumberCode,
    String? userNationality,
  }) =>
      EditProfileBody(
        phoneNumber: phoneNumber ?? this.phoneNumber,
        email: email ?? this.email,
        codeNumber: codeNumber ?? this.codeNumber,
        name: name ?? this.name,
        birthDate: birthDate ?? this.birthDate,
        bio: bio ?? this.bio,
        website: website ?? this.website,
        username: username ?? this.username,
        gender: gender ?? this.gender,
        lat: lat ?? this.lat,
        lng: lng ?? this.lng,
        address: address ?? this.address,
        contactNumber: contactNumber ?? this.contactNumber,
        contactNumberCode: contactNumberCode ?? this.contactNumberCode,
        userNationality: userNationality ?? this.userNationality,
      );

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      // "phone_number": phoneNumber,
      // 'code_number': codeNumber,
      // "email": email,
      "date_of_birth": birthDate,
      "username": username,
      if(bio!=null)
      "bio": bio,
      if(website!=null)
      "website": website,
      if(gender!=null)
      "gender": gender,
      "lat": lat,
      "lng": lng,
      "address": address,
      if (contactNumber != null && contactNumber!.isNotEmpty) ...{
        "contact_code_number": contactNumberCode,
        "contact_phone_number": contactNumber,
      },
      if(userNationality!=null)
        "country": userNationality,
      if(inviteCode!=null)"code": inviteCode,
    };
  }

  String toJson() => json.encode(toMap());
}
