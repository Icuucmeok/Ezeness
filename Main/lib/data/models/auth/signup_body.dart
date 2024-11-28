import 'dart:convert';

class SignUpBody {
  final String? phoneNumber;
  final String? email;
  final String? codeNumber;
  final String? code;
  final String? name;
  final String? birthDate;
  final String? passwordConfirmation;
  final String? password;
  final String? username;
  final int? gender;
  final double? lat;
  final double? lng;
  final String? address;
  final String? userNationality;
  final String? fcmToken;

  SignUpBody({
    this.phoneNumber,
    this.codeNumber,
    this.email,
    this.password,
    this.passwordConfirmation,
    this.code,
    this.name,
    this.birthDate,
    this.lat,
    this.lng,
    this.gender,
    this.username,
    this.address,
    this.userNationality,
    this.fcmToken,
  });

  SignUpBody copyWith({
     String? phoneNumber,
     String? email,
     String? codeNumber,
     String? code,
     String? name,
     String? birthDate,
     String? passwordConfirmation,
     String? password,
     String? username,
     int? gender,
     double? lat,
     double? lng,
    String? address,
    String? userNationality,
    String? fcmToken,
  }) =>
      SignUpBody(
        phoneNumber: phoneNumber ?? this.phoneNumber,
        email: email ?? this.email,
        codeNumber: codeNumber ?? this.codeNumber,
        code: code ?? this.code,
        name: name ?? this.name,
        birthDate: birthDate ?? this.birthDate,
        passwordConfirmation: passwordConfirmation ?? this.passwordConfirmation,
        password: password ?? this.password,
        username: username ?? this.username,
        gender: gender ?? this.gender,
        lat: lat ?? this.lat,
        lng: lng ?? this.lng,
        address: address ?? this.address,
        userNationality: userNationality ?? this.userNationality,
        fcmToken: fcmToken ?? this.fcmToken,
      );

  Map<String, dynamic> toMap() {
    return {
      "code": code,
      "name": name,
      "phone_number": phoneNumber,
      'code_number': codeNumber,
      "email": email,
      "date_of_birth": birthDate,
      "username": username,
      "password": password,
      "password_confirmation": passwordConfirmation,
      if(gender!=null)"gender": gender,
      "lat": lat,
      "lng": lng,
      "address": address,
      if(userNationality!=null)"country": userNationality,
      'fcm_token': fcmToken,
    };
  }

  String toJson() => json.encode(toMap());
}
