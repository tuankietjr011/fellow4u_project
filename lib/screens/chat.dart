import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../services/api_service.dart';
import 'chat_detail.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ApiService _apiService = ApiService();
  List<dynamic> _chatComments = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadChatData();
  }

  // Gọi API 9 (fetchComments) để lấy dữ liệu tin nhắn động từ server
  Future<void> _loadChatData() async {
    try {
      final data = await _apiService.fetchComments();
      if (mounted) {
        setState(() {
          _chatComments = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Lỗi tải tin nhắn: $e"), backgroundColor: Colors.redAccent),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: primaryColor))
                : RefreshIndicator(
                    onRefresh: _loadChatData,
                    color: primaryColor,
                    child: Column(
                      children: [
                        _buildSearchBar(),
                        Expanded(child: _buildChatList()),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Stack(
      children: [
        Image.network(
          'https://picsum.photos/seed/chatbg/800/400',
          height: 140,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(height: 140, color: primaryColor),
        ),
        Container(
          height: 140,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black.withOpacity(0.5), Colors.transparent],
            ),
          ),
        ),
        SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Chat',
                  style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.search, color: Colors.white, size: 28),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Row(
          children: [
            Icon(Icons.search, color: hintColor, size: 20),
            SizedBox(width: 10),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search Chat',
                  hintStyle: TextStyle(color: hintColor, fontSize: 14),
                  border: InputBorder.none,
                  isDense: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatList() {
    if (_chatComments.isEmpty) {
      return const Center(child: Text('Không có hội thoại nào.', style: TextStyle(color: hintColor)));
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: _chatComments.length > 5 ? 5 : _chatComments.length, // Lấy giới hạn hội thoại để giao diện gọn gàng
      itemBuilder: (context, index) {
        final comment = _chatComments[index];

        // Định nghĩa danh sách tên và avatar người thật cố định để đồng bộ UX
        final List<Map<String, String>> chatUsers = [
          {'name': 'Tuan Tran', 'avatar': 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&q=80&w=200'},
          {'name': 'Emily', 'avatar': 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&q=80&w=200'},
          {'name': 'Khai Ho', 'avatar': 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&q=80&w=200'},
          {'name': 'Minh Nguyen', 'avatar': 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&q=80&w=200'},
          {'name': 'Lan Anh', 'avatar': 'https://images.unsplash.com/photo-1517841905240-472988babdf9?auto=format&fit=crop&q=80&w=200'},
        ];

        final currentUser = chatUsers[index % chatUsers.length];
        // Lấy nội dung trường 'body' từ bình luận của API làm tin nhắn cuối cùng (Last message)
        final String lastMessage = comment['body'] ?? ''; 

        return _buildChatItem(
          context,
          name: currentUser['name']!,
          message: lastMessage,
          time: index == 0 ? '10:30 AM' : index == 1 ? '09:15 AM' : 'Yesterday',
          avatar: currentUser['avatar']!,
          unreadCount: index == 1 ? 2 : 0, // Giữ hiệu ứng tin nhắn chưa đọc cho Emily
        );
      },
    );
  }

  Widget _buildChatItem(
    BuildContext context, {
    required String name,
    required String message,
    required String time,
    required String avatar,
    int unreadCount = 0,
  }) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatDetailScreen(name: name, avatar: avatar),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade100),
              ),
              child: CircleAvatar(
                radius: 26, 
                backgroundColor: Colors.white,
                backgroundImage: NetworkImage(avatar),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    message,
                    style: TextStyle(
                      color: unreadCount > 0 ? const Color(0xFF212121) : hintColor,
                      fontWeight: unreadCount > 0 ? FontWeight.bold : FontWeight.normal,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  time,
                  style: const TextStyle(color: hintColor, fontSize: 11),
                ),
                const SizedBox(height: 8),
                if (unreadCount > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF26C6A2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '$unreadCount',
                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}