import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../core/widgets.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  // Tiêu chí A4: Quản lý dữ liệu nhập vào bằng Controller
  final TextEditingController _currentPassController = TextEditingController();
  final TextEditingController _newPassController = TextEditingController();
  final TextEditingController _retypePassController = TextEditingController();

  @override
  void dispose() {
    _currentPassController.dispose();
    _newPassController.dispose();
    _retypePassController.dispose();
    super.dispose();
  }

  void _handleSave() {
    // Logic kiểm tra cơ bản (Tiêu chí B2 - Trải nghiệm người dùng)
    if (_newPassController.text != _retypePassController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mật khẩu nhập lại không khớp!'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    if (_newPassController.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mật khẩu phải có ít nhất 6 ký tự')),
      );
      return;
    }

    // Nếu mọi thứ OK
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đã đổi mật khẩu thành công!'),
        backgroundColor: primaryColor,
      ),
    );
    Navigator.pop(context);
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
          'Change Password',
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
            onPressed: _handleSave,
            child: const Text(
              'SAVE',
              style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView( // Chống lỗi tràn màn hình khi hiện bàn phím
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CustomTextField(
              labelText: 'Current Password',
              hintText: '••••••',
              isPassword: true,
              controller: _currentPassController,
            ),
            CustomTextField(
              labelText: 'New Password',
              hintText: '••••••',
              isPassword: true,
              controller: _newPassController,
            ),
            CustomTextField(
              labelText: 'Retype New Password',
              hintText: '••••••',
              isPassword: true,
              controller: _retypePassController,
            ),
          ],
        ),
      ),
    );
  }
}