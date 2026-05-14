import 'package:flutter/material.dart';
import '../models/guide_model.dart';
import '../services/api_service.dart';

class GuideProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Guide> _guides = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<Guide> get guides => _guides;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> fetchAllGuides() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners(); // Báo UI hiện vòng xoay Loading

    try {
      _guides = await _apiService.fetchGuides();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners(); // Báo UI tắt Loading và hiển thị dữ liệu
    }
  }
}