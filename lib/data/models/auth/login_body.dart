import 'dart:convert';



class LoginBody {
  final String? phoneNumber;
  final String? codeNumber;
  final String? email;
  final String? password;
  final String? fcmToken;



  LoginBody({this.phoneNumber,this.codeNumber,this.email,required this.password,this.fcmToken});
  factory LoginBody.fromJson(Map<String, dynamic> json) =>
      LoginBody(
        phoneNumber: json["phone_number"] as String?,
        email: json["email"] as String?,
        password: json["password"] as String?,
        codeNumber: json["code_number"] as String?,
        fcmToken: json["fcm_token"] as String?,
      );

  Map<String, dynamic> toMap() {
    return {
      if(phoneNumber!=null)...{
        'phone_number': phoneNumber,
        'code_number': codeNumber,
      },
      if(email!=null)...{
        "email":email,
      },
      'password': password,
      'fcm_token': fcmToken,
    };
  }

   

  String toJson() => json.encode(toMap());

  
}
