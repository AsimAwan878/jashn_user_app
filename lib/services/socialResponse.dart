//
//
// import 'dart:convert';
//
// import 'package:http/http.dart' as http;
// import 'package:jashn_user/models/socialLogin_model.dart';
//
// import '../styles/api_handler.dart';
//
// Future<http.Response?> Social(SocialLogin data) async{
//
//    Handler handler = Handler('auth/sociallogin');
//    String url = handler.getUrl();
//   http.Response? response;
//   try{
//     response=await http.post(Uri.parse(url),
//     body: jsonEncode(data.toJson()));
//
//   }
//   catch(e){
//     print(e.toString());
//   }
//   return response;
//
// }