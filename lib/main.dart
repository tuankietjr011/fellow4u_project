import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // 1. Thêm import này
import 'providers/guide_provider.dart';  // 2. Thêm import provider bạn vừa tạo
import 'screens/sign_in.dart';

void main() {
  runApp(
    // 3. Bọc App bằng MultiProvider để quản lý các API sau này
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GuideProvider()),
      ],
      child: const Fellow4UApp(),
    ),
  );
}

class Fellow4UApp extends StatelessWidget {
  const Fellow4UApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fellow4U UI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Helvetica',
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const SignInScreen(),
    );
  }
}