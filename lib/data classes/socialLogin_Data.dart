//
//
// import 'package:flutter/src/foundation/change_notifier.dart';
// import 'package:jashn_user/models/socialLogin_model.dart';
// import 'package:jashn_user/services/socialResponse.dart';
// import 'package:provider/provider.dart';
// import 'package:http/http.dart' as http;
//
// class SocialLoginData extends ChangeNotifierProvider{
//   SocialLoginData({required Create<ChangeNotifier?> create}) : super(create: create);
//
//   Future<void> postSocialData(SocialLogin body) async{
//     notifyListeners();
//     http.Response? response=(await Social(body));
//
//     if(response!.statusCode ==200)
//       {
//
//       }
//     notifyListeners();
//   }
//
// }