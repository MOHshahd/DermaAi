import 'dart:convert';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/news_model.dart';

// class NewsService {
//   final String _apiKey = dotenv.env['NEWS_API_KEY'] ?? "";
//   final String _baseUrl = "https://newsapi.org/v2/everything";

//   Future<List<SkinNews>> fetchSkinNews() async {
//     if (_apiKey.isEmpty) {
//       debugPrint("❌ Error: NEWS_API_KEY not found in .env file");
//       return [];
//     }

//     final response = await http.get(Uri.parse(
//         "$_baseUrl?q=skin+health+dermatology&sortBy=publishedAt&apiKey=$_apiKey"
//     ));

//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       List<dynamic> articles = data['articles'];

//       return articles
//           .where((article) => article['title'] != "[Removed]")
//           .map((article) => SkinNews.fromJson(article))
//           .toList();
//     } else {
//       debugPrint("API Error: ${response.statusCode} - ${response.body}");
//       throw Exception("Failed to load news");
//     }
//   }
// }


// class NewsService {
//   final String _tableName = "news";
//   final supabase = Supabase.instance.client;

//   Future<List<SkinNews>> fetchSkinNews() async {
//     final response = await supabase
//         .from(_tableName)
//         .select()
//         .order('created_at', ascending: false);

//     final data = response as List;

//     return data.map((article) {
//       return SkinNews(
//         title: article['title'] ?? '',
//         description: article['description'] ?? '',
//         url: article['url'] ?? '',
//         urlToImage: article['image_url'] ?? '',
//         sourceName: article['source_name'] ?? '',
//       );
//     }).toList();
//   }
// }

class NewsService {
  final supabase = Supabase.instance.client;

  Future<List<SkinNews>> fetchSkinNews() async {
    final response = await supabase
        .from('news')
        .select()
        .order('created_at', ascending: false);

    final data = response as List;

    return data.map((json) => SkinNews.fromJson(json)).toList();
  }
}