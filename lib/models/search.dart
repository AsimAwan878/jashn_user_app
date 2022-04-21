import 'dart:convert';

import '../styles/api_handler.dart';
import 'package:http/http.dart' as http;

class User {
  final String name;
  final String id;
  final String category;
  final String image;

  const User({
    required this.name,
    required this.id,
    required this.category,
    required this.image,
  });

  static User fromJson(Map<String, dynamic> json) => User(
      name: json['celebrity_name'],
      id: json['celebrity_id'],
      image: json['image'],
      category: json['category']);
}

class UserApi {
  static Future<List<User>> getUserSuggestions(String query) async {
    Handler handler = Handler('unauthorized/home/celebrity?type=all');
    String myUrl = handler.getUrl();

    final url = Uri.parse(myUrl);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map myMap = jsonDecode(response.body);
      final List users = myMap["data"];
      return users.map((json) => User.fromJson(json)).where((user) {
        final nameLower = user.name.toLowerCase();
        final queryLower = query.toLowerCase();

        return nameLower.contains(queryLower);
      }).toList();
    } else {
      throw Exception();
    }
  }
}
