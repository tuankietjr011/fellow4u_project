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
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),

                  // Radio Buttons
                  Row(
                    children: [
                      Radio(
                        value: 0,
                        groupValue: _roleValue,
                        activeColor: primaryColor,
                        onChanged: (val) =>
                            setState(() => _roleValue = val as int),
                      ),
                      const Text(
                        'Traveler',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 20),
                      Radio(
                        value: 1,
                        groupValue: _roleValue,
                        activeColor: primaryColor,
                        onChanged: (val) =>
                            setState(() => _roleValue = val as int),
                      ),
                      const Text(
                        'Guide',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  Row(
                    children: const [
                      Expanded(
                        child: CustomTextField(
                          labelText: 'First Name',
                          hintText: 'Yoo',
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: CustomTextField(
                          labelText: 'Last Name',
                          hintText: 'Jin',
                        ),
                      ),
                    ],
                  ),
                  const CustomTextField(
                    labelText: 'Country',
                    hintText: 'Country',
                  ),
                  const CustomTextField(
                    labelText: 'Email',
                    hintText: 'Type email',
                  ),
                  const CustomTextField(
                    labelText: 'Password',
                    hintText: 'Type password',
                    isPassword: true,
                    helperText: 'Password has more than 6 letters',
                  ),
                  const CustomTextField(
                    labelText: 'Confirm Password',
                    hintText: '••••••',
                    isPassword: true,
                  ),

                  Center(
                    child: Text.rich(
                      TextSpan(
                        text: 'By Signing Up, you agree to our ',
                        style: const TextStyle(color: hintColor, fontSize: 11),
                        children: const [
                          TextSpan(
                            text: 'Terms & Conditions',
                            style: TextStyle(color: primaryColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  PrimaryButton(text: 'SIGN UP', onPressed: () {}),
                  const SizedBox(height: 30),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already have an account? ",
                        style: TextStyle(color: hintColor, fontSize: 13),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignInScreen(),
                          ),
                        ),
                        child: const Text(
                          'Sign In',
                          style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
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
}
