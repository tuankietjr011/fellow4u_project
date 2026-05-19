import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../core/widgets.dart';
import 'change_password.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // Tiêu chí A4: Sử dụng Controller để quản lý dữ liệu nhập vào
  final TextEditingController _firstNameController = TextEditingController(text: 'Emily');
  final TextEditingController _lastNameController = TextEditingController(text: '');

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

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
          'Edit Profile',
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Tiêu chí B2: Trả dữ liệu tên mới về màn hình trước
              String fullName = "${_firstNameController.text} ${_lastNameController.text}".trim();
              Navigator.pop(context, fullName);
            },
            child: const Text(
              'SAVE',
              style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Avatar - Đổi sang RoboHash để fix lỗi gạch chéo đỏ (Tiêu chí B1)
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 47,
                    backgroundImage: NetworkImage('https://robohash.org/emily?set=set5'),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(color: primaryColor, shape: BoxShape.circle),
                  child: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
                )
              ],
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    labelText: 'First Name',
                    hintText: 'Emily',
                    controller: _firstNameController,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: CustomTextField(
                    labelText: 'Last Name',
                    hintText: 'Last name',
                    controller: _lastNameController,
                  ),
                ),
              ],
            ),
            const CustomTextField(
              labelText: 'Password',
              hintText: '••••••',
              isPassword: true,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ChangePasswordScreen()),
                ),
                child: const Text('Change Password', style: TextStyle(color: primaryColor)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}