import 'package:dio/dio.dart';
import '../models/guide_model.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );

  // ====================== LOGIN (ÉP CỨNG - KHÔNG DÙNG KEY) ======================
  Future<String?> login(String email, String password) async {
    try {
      final response = await _dio.post(
        'https://reqres.in/api/login',   // Ép cứng URL chuẩn
        data: {
          "email": email,
          "password": password,
        },
        options: Options(
          contentType: Headers.jsonContentType,
        ),
      );

      print('✅ Login Status Code: ${response.statusCode}');
      print('✅ Login Response: ${response.data}');

      if (response.statusCode == 200) {
        return response.data['token']?.toString();
      } else {
        throw Exception('Đăng nhập thất bại (${response.statusCode})');
      }
    } on DioException catch (e) {
      print('❌ Dio Error: ${e.response?.data}');
      print('❌ Status Code: ${e.response?.statusCode}');

      if (e.response?.data != null) {
        final errorMsg = e.response?.data['error'] ?? 'Lỗi đăng nhập';
        throw Exception(errorMsg);
      }
      throw Exception('Không thể kết nối đến server');
    } catch (e) {
      print('❌ Error: $e');
      throw Exception('Lỗi không xác định: $e');
    }
  }

  // ====================== CÁC HÀM KHÁC ======================
  Future<List<Guide>> fetchGuides() async {
    try {
      final response = await _dio.get('https://jsonplaceholder.typicode.com/users');
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((json) => Guide.fromJson(json)).toList();
      }
      throw Exception('Không thể tải danh sách');
    } catch (e) {
      throw Exception('Lỗi tải danh sách guide');
    }
  }

  Future<bool> createGuide(Guide guide) async {
    try {
      final response = await _dio.post(
        'https://jsonplaceholder.typicode.com/users', 
        data: guide.toJson()
      );
      return response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteGuide(int id) async {
    try {
      final response = await _dio.delete('https://jsonplaceholder.typicode.com/users/$id');
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}