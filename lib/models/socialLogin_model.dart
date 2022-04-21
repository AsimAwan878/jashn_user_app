// // To parse this JSON data, do
// //
// //     final socialLogin = socialLoginFromJson(jsonString);
//
// import 'dart:convert';
//
// SocialLogin socialLoginFromJson(String str) => SocialLogin.fromJson(json.decode(str));
//
// String socialLoginToJson(SocialLogin data) => json.encode(data.toJson());
//
// class SocialLogin {
//   SocialLogin({
//     required this.username,
//     required this.email,
//     required this.phone,
//     required this.code,
//     required this.image,
//     required this.googleId,
//     required this.facebookId,
//     required this.appleId,
//     required this.lat,
//     required this.long,
//     required this.city,
//   });
//
//   String username;
//   String email;
//   String phone;
//   String code;
//   String image;
//   String googleId;
//   String facebookId;
//   String appleId;
//   String lat;
//   String long;
//   String city;
//
//   factory SocialLogin.fromJson(Map<String, dynamic> json) => SocialLogin(
//     username: json["username"],
//     email: json["email"],
//     phone: json["phone"],
//     code: json["code"],
//     image: json["image"],
//     googleId: json["google_id"],
//     facebookId: json["facebook_id"],
//     appleId: json["apple_id"],
//     lat: json["lat"],
//     long: json["long"],
//     city: json["city"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "username": username,
//     "email": email,
//     "phone": phone,
//     "code": code,
//     "image": image,
//     "google_id": googleId,
//     "facebook_id": facebookId,
//     "apple_id": appleId,
//     "lat": lat,
//     "long": long,
//     "city": city,
//   };
// }
