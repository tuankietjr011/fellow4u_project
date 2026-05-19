import 'package:flutter/material.dart';
import '../core/constants.dart';
import 'add_friend.dart';

class ChatDetailScreen extends StatefulWidget {
  final String name;
  final String avatar;

  const ChatDetailScreen({super.key, required this.name, required this.avatar});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  // Controller để lấy nội dung từ ô nhập
  final TextEditingController _messageController = TextEditingController();
  // Controller để tự động cuộn xuống khi có tin mới
  final ScrollController _scrollController = ScrollController();

  // Danh sách tin nhắn động (Tiêu chí A2)
  final List<Map<String, dynamic>> _messages = [
    {"text": "Hi Emily, I am Emily. How can I help you?", "isMe": false, "time": "10:30 AM"},
    {"text": "Are you ready for the trip to Da Nang tomorrow?", "isMe": false, "time": ""},
    {"text": "Hi Emily, yes I am very excited!", "isMe": true, "time": "10:31 AM"},
    {"text": "I have already prepared my luggage.", "isMe": true, "time": ""},
  ];

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      setState(() {
        _messages.add({
          "text": _messageController.text.trim(),
          "isMe": true,
          "time": "Just now",
        });
      });
      _messageController.clear();
      
      // Tự động cuộn xuống cuối sau khi gửi
      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage(widget.avatar),
            ),
            const SizedBox(width: 10),
            Text(
              widget.name,
              style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: primaryColor, size: 26),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AddFriendScreen())),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Column(
        children: [
          // Phần hiển thị tin nhắn dùng ListView.builder (Tiêu chí C2)
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(20),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                if (msg['isMe']) {
                  return _buildOutgoingMessage(msg['text'], msg['time']);
                } else {
                  return _buildIncomingMessage(msg['text'], msg['time'], hideAvatar: index > 0 && !_messages[index-1]['isMe']);
                }
              },
            ),
          ),
          _buildInputBar(),
        ],
      ),
    );
  }

  Widget _buildIncomingMessage(String text, String time, {bool hideAvatar = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!hideAvatar)
            CircleAvatar(radius: 15, backgroundImage: NetworkImage(widget.avatar))
          else
            const SizedBox(width: 30),
          const SizedBox(width: 10),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!hideAvatar && time.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Text('${widget.name} • $time', style: const TextStyle(fontSize: 11, color: hintColor)),
                  ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                  decoration: const BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                  ),
                  child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.4)),
                ),
              ],
            ),
          ),
          const SizedBox(width: 50),
        ],
      ),
    );
  }

  Widget _buildOutgoingMessage(String text, String time) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (time.isNotEmpty && time != "Just now")
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Text(time, style: const TextStyle(fontSize: 11, color: hintColor)),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const SizedBox(width: 50),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF0F0F0),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(5),
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                  ),
                  child: Text(text, style: const TextStyle(color: Colors.black, fontSize: 14, height: 1.4)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(icon: const Icon(Icons.add, color: hintColor), onPressed: () {}),
            IconButton(icon: const Icon(Icons.camera_alt_outlined, color: hintColor), onPressed: () {}),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: TextField(
                  controller: _messageController,
                  onSubmitted: (_) => _sendMessage(),
                  decoration: const InputDecoration(
                    hintText: 'Type message...',
                    hintStyle: TextStyle(color: hintColor, fontSize: 14),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: _sendMessage,
              child: const CircleAvatar(
                backgroundColor: primaryColor,
                radius: 20,
                child: Icon(Icons.send, color: Colors.white, size: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}