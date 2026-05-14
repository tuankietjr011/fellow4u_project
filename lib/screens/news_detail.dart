import 'package:flutter/material.dart';
import '../core/constants.dart';

class NewsDetailScreen extends StatelessWidget {
  final String title;
  final String date;
  final String imgUrl;

  const NewsDetailScreen({
    super.key,
    required this.title,
    required this.date,
    required this.imgUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ảnh bìa + nút back
            _buildHeaderImage(context),
            // Nội dung bài viết
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Ngày đăng
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 14, color: hintColor),
                      const SizedBox(width: 6),
                      Text(
                        date,
                        style: const TextStyle(fontSize: 13, color: hintColor),
                      ),
                      const SizedBox(width: 16),
                      const Icon(Icons.person_outline, size: 14, color: hintColor),
                      const SizedBox(width: 6),
                      const Text(
                        'Travel Editor',
                        style: TextStyle(fontSize: 13, color: hintColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  // Tiêu đề
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Nội dung bài viết
                  const Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
                    'Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. '
                    'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris '
                    'nisi ut aliquip ex ea commodo consequat.',
                    style: TextStyle(
                      fontSize: 15,
                      color: textColor,
                      height: 1.7,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      imgUrl,
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 180,
                        color: Colors.grey[200],
                        child: const Icon(Icons.broken_image, color: Colors.grey, size: 40),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Duis aute irure dolor in reprehenderit in voluptate velit esse cillum '
                    'dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non '
                    'proident, sunt in culpa qui officia deserunt mollit anim id est laborum.\n\n'
                    'Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium '
                    'doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore '
                    'veritatis et quasi architecto beatae vitae dicta sunt explicabo.',
                    style: TextStyle(
                      fontSize: 15,
                      color: textColor,
                      height: 1.7,
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Tags
                  Wrap(
                    spacing: 8,
                    children: ['Travel', 'Vietnam', 'Explore', 'News'].map((tag) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '#$tag',
                          style: const TextStyle(
                            color: primaryColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    }).toList(),
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

  Widget _buildHeaderImage(BuildContext context) {
    return Stack(
      children: [
        Image.network(
          imgUrl,
          height: 250,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            height: 250,
            color: Colors.grey[200],
            child: const Icon(Icons.broken_image, color: Colors.grey, size: 50),
          ),
        ),
        // Gradient overlay
        Container(
          height: 250,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black.withValues(alpha: 0.4), Colors.transparent],
            ),
          ),
        ),
        // Nút back
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.share_outlined, color: Colors.white),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.bookmark_border, color: Colors.white),
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
