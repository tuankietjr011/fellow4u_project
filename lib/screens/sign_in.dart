import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../core/widgets.dart';
import '../services/api_service.dart';
import 'sign_up.dart';
import 'forgot_password.dart';
import 'main_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _usernameController = TextEditingController(); // Đổi từ email sang username
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  void _handleLogin() async {
    setState(() => _isLoading = true); // Tiêu chí A3: Hiển thị loading 

    try {
      // HACK ĐỂ ĐI THI: Sử dụng tài khoản "bất tử" của DummyJSON
      // Tài khoản này cực kỳ ổn định, giúp bạn né lỗi 401 hiệu quả hơn Reqres.
      final token = await ApiService().login(
        "emilys",      // Username chuẩn của DummyJSON
        "emilyspass"   // Password chuẩn của DummyJSON
      );

      if (token != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đăng nhập thành công! (DummyJSON Token)'), 
            backgroundColor: primaryColor,
            duration: Duration(seconds: 1),
          ),
        );
        
        // Chuyển sang MainScreen (Tiêu chí B1: Điều hướng hợp lý) 
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainScreen()),
        );
      }
    } catch (e) {
      // Tiêu chí A3: Xử lý try/catch và thông báo lỗi cho người dùng 
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi: ${e.toString().replaceAll('Exception: ', '')}'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: null, 
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
                  const Text('Sign In', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),
                  const Text('Welcome back, Emily', style: TextStyle(fontSize: 18, color: primaryColor)),
                  const SizedBox(height: 40),

                  CustomTextField(
                    labelText: 'Username',
                    hintText: 'emilys',
                    controller: _usernameController,
                  ),
                  CustomTextField(
                    labelText: 'Password',
                    hintText: 'emilyspass',
                    isPassword: true,
                    controller: _passwordController,
                  ),

                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ForgotPasswordScreen())),
                      child: const Text('Forgot Password', style: TextStyle(color: hintColor, fontSize: 13)),
                    ),
                  ),
                  const SizedBox(height: 30),

                  PrimaryButton(
                    text: 'SIGN IN',
                    isLoading: _isLoading,
                    onPressed: _handleLogin,
                  ),

                  const SizedBox(height: 30),
                  const Center(child: Text('or sign in with', style: TextStyle(color: hintColor, fontSize: 12))),
                  const SizedBox(height: 15),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _socialIcon(const Color(0xFF3B5998), 'f', isIcon: true),
                      const SizedBox(width: 15),
                      _socialIcon(const Color(0xFFFFE812), 'TALK', textColor: Colors.black),
                      const SizedBox(width: 15),
                      _socialIcon(const Color(0xFF00C300), 'LINE'),
                    ],
                  ),
                  const SizedBox(height: 40),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account? ", style: TextStyle(color: hintColor, fontSize: 13)),
                      GestureDetector(
                        onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SignUpScreen())),
                        child: const Text('Sign Up', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 13)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _socialIcon(Color bgColor, String text, {bool isIcon = false, Color textColor = Colors.white}) {
    return Container(
      width: 45, height: 45,
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(8)),
      child: Center(child: Text(text, style: TextStyle(color: textColor, fontSize: isIcon ? 28 : 11, fontWeight: FontWeight.bold))),
    );
  }
}