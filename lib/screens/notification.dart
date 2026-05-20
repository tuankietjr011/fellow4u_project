import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../services/api_service.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final ApiService _apiService = ApiService();
  List<dynamic> _notifications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotificationData();
  }

  // Gọi API 8 (fetchPosts) để lấy dữ liệu thông báo động
  Future<void> _loadNotificationData() async {
    try {
      final data = await _apiService.fetchPosts();
      if (mounted) {
        setState(() {
          _notifications = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Lỗi tải thông báo: $e"), backgroundColor: Colors.redAccent),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator(color: primaryColor)),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _loadNotificationData,
              color: primaryColor,
              child: _notifications.isEmpty
                  ? const Center(child: Text('Không có thông báo nào.', style: TextStyle(color: hintColor)))
                  : ListView.separated(
                      padding: EdgeInsets.zero,
                      itemCount: _notifications.length,
                      separatorBuilder: (context, index) => const Divider(height: 1, color: Color(0xFFF0F0F0)),
                      itemBuilder: (context, index) => _buildNotificationItem(_notifications[index], index),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return SizedBox(
      height: 180,
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.network(
              'https://picsum.photos/seed/notif/800/400', 
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(color: primaryColor),
            ),
          ),
          Positioned.fill(child: Container(color: Colors.black.withOpacity(0.2))),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('Notifications', style: TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.bold)),
                  CircleAvatar(
                    backgroundColor: Colors.white.withOpacity(0.2),
                    child: const Icon(Icons.search, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(Map<String, dynamic> data, int index) {
    // Luân phiên thay đổi loại thông báo để giao diện nhìn đa dạng icon màu sắc
    String type = 'accept';
    if (index % 3 == 1) type = 'offer';
    if (index % 3 == 2) type = 'review';

    // Đồng bộ lại danh sách avatar người thật đã sửa ở các màn trước
    final List<String> realPeople = [
      'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&q=80&w=200', // Tuan Tran
      'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&q=80&w=200', // Emily
      'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&q=80&w=200', // Khai Ho
    ];
    String currentAvatar = realPeople[index % realPeople.length];

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              CircleAvatar(
                radius: 25, 
                backgroundColor: Colors.grey[200],
                backgroundImage: NetworkImage(currentAvatar),
              ),
              Positioned(right: -2, bottom: -2, child: _buildBadgeIcon(type)),
            ],
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(fontSize: 15, color: Colors.black, height: 1.4, fontFamily: 'Roboto'),
                    children: [
                      TextSpan(
                        text: 'User_${data['userId']} ', 
                        style: const TextStyle(fontWeight: FontWeight.bold)
                      ),
                      TextSpan(text: data['title']), // Nội dung tiêu đề động từ API
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                const Text('Just now', style: TextStyle(color: hintColor, fontSize: 13)),
                if (type == 'review')
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        elevation: 0,
                      ),
                      child: const Text('Leave Review', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadgeIcon(String type) {
    IconData icon;
    Color color;
    switch (type) {
      case 'accept': icon = Icons.check; color = Colors.green; break;
      case 'offer': icon = Icons.local_offer; color = Colors.orange; break;
      case 'review': icon = Icons.star; color = Colors.blue; break;
      default: icon = Icons.notifications; color = Colors.grey;
    }
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: color, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
      child: Icon(icon, size: 10, color: Colors.white),
    );
  }
}