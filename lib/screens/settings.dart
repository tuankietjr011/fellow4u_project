import 'package:flutter/material.dart';
import '../core/constants.dart';
import 'edit_profile.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notifEnabled = true;
  
  // Dữ liệu đồng bộ với Profile (Emily)
  String _name = 'Emily'; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Settings',
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          // Banner User - Hiển thị Emily để đồng bộ (Tiêu chí B1)
          Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 23,
                    backgroundImage: NetworkImage(
                      'https://robohash.org/emily?set=set5',
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const Text(
                        'Traveler',
                        style: TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    // Chuyển sang trang Edit và chờ kết quả trả về
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EditProfileScreen(),
                      ),
                    );
                    // Nếu có cập nhật tên ở trang Edit, cập nhật lại ở đây
                    if (result != null && result is String) {
                      setState(() => _name = result);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.2),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: const Text(
                    'EDIT PROFILE',
                    style: TextStyle(color: Colors.white, fontSize: 11),
                  ),
                ),
              ],
            ),
          ),
          _buildMenuItem(
            Icons.notifications_none,
            'Notifications',
            trailing: Switch(
              value: _notifEnabled,
              activeColor: Colors.white,
              activeTrackColor: primaryColor,
              onChanged: (v) => setState(() => _notifEnabled = v),
            ),
          ),
          _buildMenuItem(Icons.language, 'Languages'),
          _buildMenuItem(Icons.payment, 'Payment'),
          _buildMenuItem(Icons.privacy_tip_outlined, 'Privacy & Policies'),
          _buildMenuItem(Icons.feedback_outlined, 'Feedback'),
          _buildMenuItem(Icons.data_usage, 'Usage'),
          const Spacer(),
          // Nút Sign Out - Tiêu chí B2 (Logic cơ bản)
          TextButton(
            onPressed: () {
              // Quay về màn hình đầu tiên (Login) và xóa sạch stack
              Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
            },
            child: const Text('Sign out', style: TextStyle(color: hintColor, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, {Widget? trailing}) {
    return ListTile(
      leading: Icon(icon, color: hintColor),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing:
          trailing ??
          const Icon(Icons.arrow_forward_ios, size: 14, color: hintColor),
    );
  }
}