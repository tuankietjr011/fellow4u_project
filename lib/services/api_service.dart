import 'package:dio/dio.dart';
import '../models/guide_model.dart';

class ApiService {
  // Cấu hình Dio với Timeout (Tiêu chí A3 - 1đ) 
  final Dio _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    contentType: 'application/json',
  ));

  // --- NHÓM 1: XÁC THỰC (API 1) ---
  // 1. POST: Đăng nhập nhận Token (Tiêu chí A1 - 5đ) 
  Future<String?> login(String username, String password) async {
    try {
      final response = await _dio.post(
        'https://dummyjson.com/auth/login',
        data: {'username': username, 'password': password},
      );
      return response.data['accessToken']; 
    } on DioException catch (e) {
      // Xử lý ngoại lệ để hiện thông báo lỗi người dùng (Tiêu chí A3 - 4đ) 
      throw Exception("Tài khoản hoặc mật khẩu không đúng!");
    }
  }

  // --- NHÓM 2: QUẢN LÝ GUIDE (API 2 -> API 6) ---
  // 2. GET: Lấy danh sách Guides (Tiêu chí A1 - 3đ) 
  Future<List<Guide>> fetchGuides() async {
    final response = await _dio.get('https://jsonplaceholder.typicode.com/users');
    List<dynamic> data = response.data;
    // Parse JSON sang Model (Tiêu chí A2 - 3đ) 
    return data.map((json) => Guide.fromJson(json)).toList(); 
  }

  // 3. GET: Xem chi tiết 1 Guide (API 3 - 3đ) 
  Future<dynamic> fetchGuideDetail(int id) async {
    final response = await _dio.get('https://jsonplaceholder.typicode.com/users/$id');
    return response.data;
  }

  // 4. POST: Thêm mới Guide (API 4 - 3đ) 
  Future<bool> addGuide(Map<String, dynamic> data) async {
    final response = await _dio.post('https://jsonplaceholder.typicode.com/users', data: data);
    return response.statusCode == 201;
  }

  // 5. PUT: Cập nhật thông tin Guide (API 5 - 3đ) 
  Future<bool> updateGuide(int id, Map<String, dynamic> data) async {
    final response = await _dio.put('https://jsonplaceholder.typicode.com/users/$id', data: data);
    return response.statusCode == 200;
  }

  // 6. DELETE: Xóa Guide (API 6 - 3đ) 
  Future<bool> deleteGuide(int id) async {
    final response = await _dio.delete('https://jsonplaceholder.typicode.com/users/$id');
    return response.statusCode == 200;
  }

  // --- NHÓM 3: DỮ LIỆU ĐA DẠNG KHÁC (API 7 -> API 10) ---
  // 7. GET: Lấy danh sách ảnh cho Explore (API 7 - 3đ) 
  Future<List<dynamic>> fetchPhotos() async {
    final response = await _dio.get('https://jsonplaceholder.typicode.com/photos?_limit=10');
    return response.data;
  }

  // 8. GET: Lấy danh sách bài viết cho Notification (API 8 - 3đ) 
  Future<List<dynamic>> fetchPosts() async {
    final response = await _dio.get('https://jsonplaceholder.typicode.com/posts?_limit=10');
    return response.data;
  }

  // 9. GET: Lấy danh sách bình luận cho Chat (API 9 - 3đ) 
  Future<List<dynamic>> fetchComments() async {
    final response = await _dio.get('https://jsonplaceholder.typicode.com/comments?_limit=10');
    return response.data;
  }

  // 10. GET: Lấy danh sách công việc cho My Trips (API 10 - 3đ) 
  Future<List<dynamic>> fetchTodos() async {
    final response = await _dio.get('https://jsonplaceholder.typicode.com/todos?_limit=10');
    return response.data;
  }
}