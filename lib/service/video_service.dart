import 'package:dio/dio.dart';
import 'dart:convert';

class VideoService {
  // إنشاء نسخة من Dio لاستخدامها في كل الطلبات
  final Dio _dio = Dio();
  
  // الرابط الخاص بك
  final String _url = 'https://gist.githubusercontent.com/Abdelrahman-El-Kassas/2e71de5d6c7c1b061e5e064823d9bcbb/raw/chessvideos.json';

  Future<List<dynamic>> fetchVideos() async {
    try {
      final response = await _dio.get(_url);
      
     
      if (response.data is String) {
        return json.decode(response.data);
      } else {
        return response.data;
      }
    } catch (e) {
      throw Exception('Check your Internet Connection: $e');
    }
  }
}