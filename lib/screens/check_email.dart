import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../core/widgets.dart';

class CheckEmailScreen extends StatelessWidget {
  const CheckEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CurvedHeader(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Check Email',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: textColor),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Please check your email for the instructions on\nhow to reset your password.',
                  style: TextStyle(color: hintColor, fontSize: 14, height: 1.5),
                ),
                const SizedBox(height: 60),

                // Icon mô phỏng thư với hiệu ứng đổ bóng nhẹ (Tiêu chí B1)
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(40),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0FDF4), // Màu xanh nhạt cực nhẹ
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: primaryColor.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.mark_email_unread_outlined,
                      size: 100,
                      color: primaryColor,
                    ),
                  ),
                ),
                const SizedBox(height: 80),

                // Nút mở ứng dụng Email (Giả lập tương tác thực tế - Tiêu chí B2)
                PrimaryButton(
                  text: 'OPEN EMAIL APP', 
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Chức năng đang được tích hợp...'))
                    );
                  }
                ),
                
                const SizedBox(height: 25),

                // Quay lại Sign In
                Center(
                  child: GestureDetector(
                    onTap: () {
                      // Quay về màn hình Login và xóa hết các màn hình trước đó trong luồng reset pass
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    child: const Text.rich(
                      TextSpan(
                        text: 'Back to ',
                        style: TextStyle(color: hintColor, fontSize: 14),
                        children: [
                          TextSpan(
                            text: 'Sign In',
                            style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}