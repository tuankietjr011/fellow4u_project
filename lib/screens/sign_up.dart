import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../core/widgets.dart';
import 'sign_in.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  int _roleValue = 0; // 0: Traveler, 1: Guide

  // Tiêu chí A4: Sử dụng TextEditingController để quản lý dữ liệu nhập
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController(); // ĐÃ THÊM MỚI
  final TextEditingController _countryController = TextEditingController(text: 'Vietnam'); // ĐÃ THÊM MỚI (Mặc định Vietnam)
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose(); // ĐÃ THÊM MỚI
    _countryController.dispose();   // ĐÃ THÊM MỚI
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  void _handleSignUp() {
    // Logic kiểm tra cơ bản đầu vào trống (Tiêu chí B2)
    if (_usernameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Username không được để trống!'), backgroundColor: Colors.orangeAccent),
      );
      return;
    }

    if (_emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email không được để trống!'), backgroundColor: Colors.orangeAccent),
      );
      return;
    }

    if (_passwordController.text != _confirmPassController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mật khẩu xác nhận không khớp!'), backgroundColor: Colors.redAccent),
      );
      return;
    }

    if (_passwordController.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mật khẩu phải từ 6 ký tự trở lên')),
      );
      return;
    }

    // Hiển thị thông báo thành công và chuyển hướng
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đăng ký thành công!'), backgroundColor: primaryColor),
    );
    
    // Chuyển sang màn hình Sign In
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SignInScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CurvedHeader(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Sign Up',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: textColor),
                  ),
                  const SizedBox(height: 15),

                  // Lựa chọn Role (Traveler/Guide)
                  Row(
                    children: [
                      _buildRoleRadio(0, 'Traveler'),
                      const SizedBox(width: 20),
                      _buildRoleRadio(1, 'Guide'),
                    ],
                  ),
                  const SizedBox(height: 10),

                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          labelText: 'First Name',
                          hintText: 'Emily', // Đồng bộ tên Emily
                          controller: _firstNameController,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: CustomTextField(
                          labelText: 'Last Name',
                          hintText: 'Nguyen',
                          controller: _lastNameController,
                        ),
                      ),
                    ],
                  ),
                  
                  // ĐÃ SỬA: Đưa controller vào ô nhập Country
                  CustomTextField(
                    labelText: 'Country', 
                    hintText: 'Vietnam',
                    controller: _countryController,
                  ),
                  
                  CustomTextField(
                    labelText: 'Email', 
                    hintText: 'emily@gmail.com', 
                    controller: _emailController
                  ),
                  
                  // ĐÃ THÊM MỚI: Ô nhập Username đồng bộ hệ thống
                  CustomTextField(
                    labelText: 'Username', 
                    hintText: 'emilys', 
                    controller: _usernameController,
                  ),
                  const SizedBox(height: 15),

                  CustomTextField(
                    labelText: 'Password',
                    hintText: '••••••',
                    isPassword: true,
                    controller: _passwordController,
                    helperText: 'Password has more than 6 letters',
                  ),
                  CustomTextField(
                    labelText: 'Confirm Password',
                    hintText: '••••••',
                    isPassword: true,
                    controller: _confirmPassController,
                  ),

                  const SizedBox(height: 10),
                  const Center(
                    child: Text.rich(
                      TextSpan(
                        text: 'By Signing Up, you agree to our ',
                        style: TextStyle(color: hintColor, fontSize: 11),
                        children: [
                          TextSpan(text: 'Terms & Conditions', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),

                  PrimaryButton(text: 'SIGN UP', onPressed: _handleSignUp),
                  const SizedBox(height: 30),

                  _buildSignInLink(),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- UI Helpers ---

  Widget _buildRoleRadio(int value, String title) {
    return Row(
      children: [
        Radio(
          value: value,
          groupValue: _roleValue,
          activeColor: primaryColor,
          onChanged: (val) => setState(() => _roleValue = val as int),
        ),
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: textColor)),
      ],
    );
  }

  Widget _buildSignInLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Already have an account? ", style: TextStyle(color: hintColor, fontSize: 13)),
        GestureDetector(
          onTap: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const SignInScreen()),
          ),
          child: const Text(
            'Sign In',
            style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ),
      ],
    );
  }
}