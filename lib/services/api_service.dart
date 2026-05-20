import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../models/guide_model.dart';

class ApiService {
  // Cấu hình Base URL chỉa thẳng vào con Java Spring Boot chạy ở cổng 8080 với Timeout chuẩn chỉ
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'http://localhost:8080/api', 
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    contentType: 'application/json',
  ));

  // --- NHÓM 1: XÁC THỰC (API 1) ---
  Future<String?> login(String username, String password) async {
    try {
      final response = await _dio.post(
        '/auth/login', 
        data: {'username': username, 'password': password},
      );
      return response.data['accessToken']; 
    } on DioException catch (e) {
      throw Exception("Tài khoản hoặc mật khẩu không đúng!");
    }
  }

  // --- NHÓM 2: QUẢN LÝ GUIDE (API 2 -> API 6) ---
  // GET: Lấy danh sách Guides từ Database thật 
  Future<List<Guide>> fetchGuides() async {
    try {
      final response = await _dio.get('/guides');
      List<dynamic> data = response.data;
      return data.map((json) => Guide.fromJson(json)).toList(); 
    } catch (e) {
      print("Lỗi map dữ liệu Guide: $e");
      return [];
    }
  }

  // GET: Xem chi tiết 1 Guide
  Future<dynamic> fetchGuideDetail(int id) async {
    final response = await _dio.get('/guides/$id');
    return response.data;
  }

  // POST: Thêm mới Guide
  Future<bool> addGuide(Map<String, dynamic> data) async {
    final response = await _dio.post('/guides', data: data);
    return response.statusCode == 201 || response.statusCode == 200;
  }

  // PUT: Cập nhật thông tin Guide
  Future<bool> updateGuide(int id, Map<String, dynamic> data) async {
    final response = await _dio.put('/guides/$id', data: data);
    return response.statusCode == 200;
  }

  // DELETE: Xóa Guide
  Future<bool> deleteGuide(int id) async {
    final response = await _dio.delete('/guides/$id');
    return response.statusCode == 200;
  }

  // --- NHÓM 3: DỮ LIỆU ĐA DẠNG KHÁC (API 7 -> API 10) ---
  // 7. GET: Lấy danh sách ảnh cho Explore
  Future<List<dynamic>> fetchPhotos() async {
    try {
      final response = await _dio.get('/experiences'); 
      return response.data;
    } catch (e) {
      print("Lỗi fetchPhotos: $e");
      return [];
    }
  }

  // 8. GET: Lấy danh sách bài viết cho Notification 
  Future<List<dynamic>> fetchPosts() async {
    final response = await _dio.get('/notifications'); 
    return response.data;
  }

  // 9. GET: Lấy danh sách bình luận cho Chat 
  Future<List<dynamic>> fetchComments() async {
    final response = await _dio.get('/chat-messages'); 
    return response.data;
  }

  // 10. GET: Lấy danh sách công việc cho My Trips (BẢN BẤT TỬ LOẠI BỎ LỖI CHẶN STATUS CODE TRÊN WEB)
  Future<List<dynamic>> fetchTodos() async {
    try {
      final response = await _dio.get('/trips');
      
      // Chấp hết mọi kiểu trả mã code của Chrome, cứ có data thô đổ về là cào cấu vẽ giao diện liền!
      if (response.data != null) {
        List<dynamic> rawList = response.data;
        
        return rawList.map((item) {
          return {
            'id': item['id'],
            'title': item['title'] ?? 'Hanh trinh moi',
            'location': item['location'] ?? 'Viet Nam',
            'imageUrl': item['imageUrl'] ?? item['image_url'] ?? 'https://picsum.photos/400/250',
            'price': item['price'] ?? '\$0.00',
            'status': item['status'] ?? 'current',
          };
        }).toList();
      }
      return [];
    } catch (e) {
      print("Lỗi kết nối API Trips nghẽn ngầm: $e");
      return [];
    }
  }
}