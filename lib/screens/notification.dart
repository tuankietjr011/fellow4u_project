import 'package:flutter/material.dart';
import '../core/constants.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  // Cập nhật dữ liệu với ảnh người thật (Tiêu chí B1: Đồng bộ dữ liệu)
  final List<Map<String, dynamic>> _notifications = [
    {
      'id': 1,
      // Ảnh người nam Châu Á (Đồng bộ với Tuan Tran ở Chat Screen)
      'avatar': 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&q=80&w=200',
      'name': 'Tuan Tran',
      'message': 'accepted your request for the trip in Danang, Vietnam on Jan 20, 2026',
      'date': 'Today',
      'type': 'accept',
      'hasButton': false,
    },
    {
      'id': 2,
      // Ảnh người nữ (Đồng bộ với avatar Emily ở Profile/Chat)
      'avatar': 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&q=80&w=200',
      'name': 'Emily',
      'message': 'sent you an offer for the trip in Ho Chi Minh, Vietnam on Feb 12, 2026',
      'date': 'Jan 16',
      'type': 'offer',
      'hasButton': false,
    },
    {
      'id': 3,
      'avatar': 'LOGO',
      'name': 'System',
      'message': 'Thanks! Your trip in Danang has been finished. Please leave a review for Tuan Tran.',
      'date': 'Jan 24',
      'type': 'review',
      'hasButton': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.zero,
              itemCount: _notifications.length,
              separatorBuilder: (context, index) => const Divider(height: 1, color: Color(0xFFF0F0F0)),
              itemBuilder: (context, index) => _buildNotificationItem(_notifications[index]),
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
              errorBuilder: (context, error, stackTrace) => Container(color: const Color(0xFF26C6A2)),
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

  Widget _buildNotificationItem(Map<String, dynamic> data) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              data['avatar'] == 'LOGO'
                  ? const CircleAvatar(
                      radius: 25, 
                      backgroundColor: Color(0xFF26C6A2), 
                      child: Icon(Icons.card_travel, color: Colors.white)
                    )
                  : CircleAvatar(
                      radius: 25, 
                      backgroundColor: Colors.grey[200],
                      backgroundImage: NetworkImage(data['avatar']),
                    ),
              Positioned(right: -2, bottom: -2, child: _buildBadgeIcon(data['type'])),
            ],
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(fontSize: 15, color: Color(0xFF212121), height: 1.4),
                    children: [
                      if (data['name'] != 'System')
                        TextSpan(text: '${data['name']} ', style: const TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: data['message']),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                Text(data['date'], style: const TextStyle(color: Color(0xFF9E9E9E), fontSize: 13)),
                if (data['hasButton'])
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF26C6A2),
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