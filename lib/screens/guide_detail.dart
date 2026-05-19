import 'package:flutter/material.dart';
import '../core/constants.dart';

class GuideDetailScreen extends StatelessWidget {
  final String name;
  final String location;
  final String avatar;

  const GuideDetailScreen({
    super.key,
    required this.name,
    required this.location,
    required this.avatar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCoverAndAvatar(context),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProfileInfo(),
                  const SizedBox(height: 20),
                  _buildIntroAndVideo(),
                  const SizedBox(height: 25),
                  const Text('Pricing', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), // Thêm tiêu đề cho bảng giá
                  const SizedBox(height: 10),
                  _buildPricingTable(),
                  const SizedBox(height: 30),
                  _buildExperiencesSection(),
                  const SizedBox(height: 30),
                  _buildReviewsSection(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 1. Ảnh bìa & Avatar (Fix lỗi hiển thị ảnh)
  Widget _buildCoverAndAvatar(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Image.network(
          'https://picsum.photos/seed/guidebg/800/400', // Dùng Picsum cho ổn định
          height: 180, width: double.infinity, fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(height: 180, color: Colors.grey[300]),
        ),
        Positioned(
          top: 40, left: 10,
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        Positioned(
          bottom: -40, left: 20,
          child: Container(
            padding: const EdgeInsets.all(3),
            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            child: CircleAvatar(
              radius: 40,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                radius: 38,
                backgroundImage: NetworkImage(avatar),
                onBackgroundImageError: (exception, stackTrace) {}, // Xử lý lỗi load ảnh nền
              ),
            ),
          ),
        ),
      ],
    );
  }

  // 2. Profile Info
  Widget _buildProfileInfo() {
    return Padding(
      padding: const EdgeInsets.only(top: 50),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                Row(
                  children: [
                    _buildStars(5),
                    const SizedBox(width: 5),
                    const Text('127 Reviews', style: TextStyle(color: hintColor, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 5),
                const Text('Vietnamese • English • Korean', style: TextStyle(color: hintColor, fontSize: 12)),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(Icons.location_on, color: primaryColor, size: 14),
                    Text(location, style: const TextStyle(color: primaryColor, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              elevation: 0,
            ),
            child: const Text('CHOOSE THIS GUIDE', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  // (Các hàm _buildIntroAndVideo, _buildPricingTable giữ nguyên logic của bạn nhưng thêm errorBuilder cho ảnh)
  Widget _buildIntroAndVideo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Emily is a professional guide with 5 years of experience in Da Nang. She knows every corner of the city and is passionate about sharing the local culture with travelers.',
          style: TextStyle(color: textColor, fontSize: 13, height: 1.5),
        ),
        const SizedBox(height: 15),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.network(
                'https://picsum.photos/seed/video/600/300',
                height: 160, width: double.infinity, fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(height: 160, color: Colors.black12),
              ),
              const Icon(Icons.play_circle_fill, color: primaryColor, size: 50),
            ],
          ),
        ),
      ],
    );
  }

  // --- REVIEWS SECTION Tối ưu hiển thị ---
  Widget _buildReviewsSection() {
    return Column(
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Reviews', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('SEE MORE', style: TextStyle(color: primaryColor, fontSize: 12, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 15),
        _buildReviewItem('Pena Valdez', 'Jan 22, 2026', 'Great experience with Emily!', 'https://robohash.org/pena?set=set5'),
        const Divider(height: 30),
        _buildReviewItem('Daehyun', 'Jan 22, 2026', 'She is so friendly and helpful.', 'https://robohash.org/dae?set=set5'),
      ],
    );
  }

  Widget _buildReviewItem(String name, String date, String content, String avatar) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(radius: 20, backgroundImage: NetworkImage(avatar)),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [_buildStars(5), Text(date, style: const TextStyle(color: hintColor, fontSize: 11))],
              ),
              const SizedBox(height: 8),
              Text(content, style: const TextStyle(color: textColor, fontSize: 13, height: 1.4)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStars(int count) => Row(children: List.generate(count, (index) => const Icon(Icons.star, color: Colors.amber, size: 14)));

  Widget _buildPricingTable() {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(5)),
      child: Column(
        children: [
          _buildPriceRow('1 - 3 Travelers', '\$10/hour'),
          const Divider(height: 1),
          _buildPriceRow('4 - 6 Travelers', '\$14/hour'),
          const Divider(height: 1),
          _buildPriceRow('7 - 9 Travelers', '\$17/hour'),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String count, String price) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(count, style: const TextStyle(fontWeight: FontWeight.w500)), Text(price, style: const TextStyle(fontWeight: FontWeight.bold))],
      ),
    );
  }

  // Tái sử dụng hàm vẽ Experience Card (đã thêm xử lý ảnh lỗi)
  Widget _buildExperiencesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('My Experiences', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 15),
        _buildExperienceCard('Bicycle Tour in Hoi An', 'Hoian, Vietnam', 'Jan 25, 2026', '1214 Likes'),
      ],
    );
  }

  Widget _buildExperienceCard(String title, String loc, String date, String likes) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network('https://picsum.photos/seed/$title/600/300', height: 160, width: double.infinity, fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(height: 160, color: Colors.grey[200])),
        ),
        const SizedBox(height: 10),
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        Row(children: [const Icon(Icons.location_on, color: primaryColor, size: 14), Text(loc, style: const TextStyle(color: primaryColor, fontSize: 12))]),
      ],
    );
  }
}