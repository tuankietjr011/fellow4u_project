import 'package:flutter/material.dart';
import '../core/constants.dart';
import 'guide_detail.dart';
import 'news_detail.dart';
import 'tour_detail.dart';
import 'search_screen.dart'; // Thêm import trang Search vào đây

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            _HeaderSection(),
            SizedBox(height: 10),

            _TopJourneysSection(),
            _BestGuidesSection(),
            _TopExperiencesSection(),
            _FeaturedToursSection(),
            _TravelNewsSection(),

            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

// 1. Header & Thanh tìm kiếm
class _HeaderSection extends StatelessWidget {
  const _HeaderSection();

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 220,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                'https://images.unsplash.com/photo-1559592413-7cec4d0cae2b?auto=format&fit=crop&q=80&w=800',
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            color: Colors.black.withOpacity(0.2),
            padding: const EdgeInsets.only(top: 60, left: 20, right: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Explore',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: const [
                    Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.white, size: 16),
                        SizedBox(width: 4),
                        Text(
                          'Da Nang',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.cloud, color: Colors.white, size: 24),
                        SizedBox(width: 5),
                        Text(
                          '26°C',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: -25,
          left: 20,
          right: 20,
          child: Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.search, color: hintColor),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    readOnly: true, // Ngăn bàn phím bật lên ở trang này
                    onTap: () {
                      // Chuyển sang màn hình SearchScreen
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  const SearchScreen(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                                // Thêm hiệu ứng mờ dần (Fade) cho mượt
                                return FadeTransition(
                                  opacity: animation,
                                  child: child,
                                );
                              },
                        ),
                      );
                    },
                    decoration: const InputDecoration(
                      hintText: 'Hi, where do you want to explore?',
                      hintStyle: TextStyle(color: hintColor, fontSize: 14),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// 2. Top Journeys
class _TopJourneysSection extends StatefulWidget {
  const _TopJourneysSection();

  @override
  State<_TopJourneysSection> createState() => _TopJourneysSectionState();
}

class _TopJourneysSectionState extends State<_TopJourneysSection> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40, left: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Top Journeys',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: 285,
            child: Scrollbar(
              controller: _scrollController,
              thumbVisibility: true,
              interactive: true,
              child: ListView(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                children: [
                  _buildJourneyCard(
                    'Da Nang - Ba Na - Hoi An',
                    '\$400.00',
                    'https://images.unsplash.com/photo-1559592413-7cec4d0cae2b?auto=format&fit=crop&q=80&w=400',
                  ),
                  _buildJourneyCard(
                    'Thailand',
                    '\$600.00',
                    'https://images.unsplash.com/photo-1552465011-b4e21bf6e79a?auto=format&fit=crop&q=80&w=400',
                  ),
                  _buildJourneyCard(
                    'Hoi An Ancient Town',
                    '\$250.00',
                    'https://images.unsplash.com/photo-1557750255-c76072a7aad1?auto=format&fit=crop&q=80&w=400',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJourneyCard(String title, String price, String imgUrl) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.network(
              imgUrl,
              height: 130,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 5),
                Row(
                  children: const [
                    Icon(Icons.calendar_today, size: 12, color: hintColor),
                    SizedBox(width: 4),
                    Text(
                      'Jan 30, 2026',
                      style: TextStyle(fontSize: 11, color: hintColor),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Row(
                  children: const [
                    Icon(Icons.access_time, size: 12, color: hintColor),
                    SizedBox(width: 4),
                    Text(
                      '3 days',
                      style: TextStyle(fontSize: 11, color: hintColor),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  price,
                  style: const TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
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

// 3. Best Guides
class _BestGuidesSection extends StatelessWidget {
  const _BestGuidesSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Best Guides',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Text(
                  'SEE MORE',
                  style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: 200,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildGuideCard(
                  context,
                  'Tuan Tran',
                  'Danang, Vietnam',
                  'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&q=80&w=200',
                ),
                _buildGuideCard(
                  context,
                  'Emmy',
                  'Hanoi, Vietnam',
                  'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&q=80&w=200',
                ),
                _buildGuideCard(
                  context,
                  'Linh Hana',
                  'Danang, Vietnam',
                  'https://images.unsplash.com/photo-1517841905240-472988babdf9?auto=format&fit=crop&q=80&w=200',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuideCard(
    BuildContext context,
    String name,
    String location,
    String imgUrl,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GuideDetailScreen(
              name: name,
              location: location,
              avatar: imgUrl,
            ),
          ),
        );
      },
      child: Container(
        width: 140,
        margin: const EdgeInsets.only(right: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                imgUrl,
                height: 140,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            Row(
              children: [
                const Icon(Icons.location_on, size: 12, color: primaryColor),
                Text(
                  location,
                  style: const TextStyle(fontSize: 11, color: primaryColor),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// 4. Top Experiences
class _TopExperiencesSection extends StatelessWidget {
  const _TopExperiencesSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Top Experiences',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          LayoutBuilder(
            builder: (context, constraints) {
              // Tính chiều rộng mỗi card: chia đều 3 card,
              // trừ đi 2 khoảng cách (gap=10) giữa 3 card, trừ padding phải 10
              final double gap = 10;
              final double cardWidth = (constraints.maxWidth - 2 * gap - 10) / 3;
              final double imgHeight = cardWidth * 1.1;
              final double totalHeight = imgHeight + 60;
              return SizedBox(
                height: totalHeight,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildExpCard(
                      '2 Hour Bicycle Tour...',
                      'Tuan Tran',
                      'https://images.unsplash.com/photo-1517649763962-0c623066013b?auto=format&fit=crop&q=80&w=300',
                      'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&q=80&w=100',
                      cardWidth, imgHeight,
                    ),
                    _buildExpCard(
                      '1 day at Bana Hill',
                      'Linh Hana',
                      'https://images.unsplash.com/photo-1528360983277-13d401cdc186?auto=format&fit=crop&q=80&w=300',
                      'https://images.unsplash.com/photo-1517841905240-472988babdf9?auto=format&fit=crop&q=80&w=100',
                      cardWidth, imgHeight,
                    ),
                    _buildExpCard(
                      'Hoi An Lantern Night',
                      'Emmy',
                      'https://images.unsplash.com/photo-1559592413-7cec4d0cae2b?auto=format&fit=crop&q=80&w=300',
                      'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&q=80&w=100',
                      cardWidth, imgHeight,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildExpCard(
    String title,
    String guideName,
    String bgImg,
    String avatarImg,
    double cardWidth,
    double imgHeight,
  ) {
    return Container(
      width: cardWidth,
      margin: const EdgeInsets.only(right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.bottomCenter,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  bgImg,
                  height: imgHeight,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: imgHeight,
                    width: double.infinity,
                    color: Colors.grey[200],
                    child: const Icon(Icons.broken_image, color: Colors.grey, size: 32),
                  ),
                ),                  
              ),
              Positioned(
                bottom: -16,
                child: Column(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(avatarImg),
                      radius: 16,
                      backgroundColor: Colors.white,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        guideName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
            maxLines: 2,
          ),
        ],
      ),
    );
  }
}

// 5. Featured Tours (Đã cập nhật dữ liệu động cho hàm _buildFeatureCard)
class _FeaturedToursSection extends StatelessWidget {
  const _FeaturedToursSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Featured Tours',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                'SEE MORE',
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          _buildFeatureCard(
            context,
            'Da Nang - Ba Na - Hoi An',
            '\$400.00',
            'https://images.unsplash.com/photo-1559592413-7cec4d0cae2b?auto=format&fit=crop&q=80&w=600',
          ),
          const SizedBox(height: 15),
          _buildFeatureCard(
            context,
            'Melbourne - Sydney',
            '\$600.00',
            'https://images.unsplash.com/photo-1514395462725-fb4566210144?auto=format&fit=crop&q=80&w=600',
          ),
        ],
      ),
    );
  }

  // Đã truyền các biến title, price, imgUrl sang trang Tour Detail
  Widget _buildFeatureCard(
    BuildContext context,
    String title,
    String price,
    String imgUrl,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                TourDetailScreen(title: title, price: price, imgUrl: imgUrl),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // ── Phần ảnh với overlay ──
            Stack(
              children: [
                // Ảnh bìa
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(14),
                  ),
                  child: Image.network(
                    imgUrl,
                    height: 170,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 170,
                      color: Colors.grey[200],
                      child: const Icon(Icons.broken_image, color: Colors.grey, size: 40),
                    ),
                  ),
                ),
                // Gradient overlay phía dưới ảnh
                Positioned(
                  bottom: 0, left: 0, right: 0,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                    child: Container(
                      height: 90,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(0.7),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                // Badge 10% off (góc trên trái)
                Positioned(
                  top: 10, left: 10,
                  child: Container(
                    width: 46,
                    height: 46,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE53935),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text(
                        '10%\noff',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          
                          height: 1.2,
                        ),
                      ),
                    ),
                  ),
                ),
                // Nút tim (góc trên phải)
                Positioned(
                  top: 10, right: 10,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.85),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.favorite_border,
                      color: Colors.grey,
                      size: 18,
                    ),
                  ),
                ),
                // Title + likes (góc dưới trái trên ảnh)
                Positioned(
                  bottom: 10, left: 12, right: 60,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        '1,247 likes',
                        style: TextStyle(color: Colors.white70, fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // ── Phần thông tin bên dưới ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  // Cột trái: ngày + thời gian
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.calendar_today, size: 12, color: hintColor),
                            SizedBox(width: 5),
                            Text('Jan 30, 2020',
                                style: TextStyle(fontSize: 12, color: hintColor)),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: const [
                            Icon(Icons.access_time, size: 12, color: hintColor),
                            SizedBox(width: 5),
                            Text('3 days',
                                style: TextStyle(fontSize: 12, color: hintColor)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Cột giữa: options
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Text('Shopping options',
                                style: TextStyle(fontSize: 11, color: hintColor)),
                            SizedBox(width: 4),
                            Icon(Icons.check, size: 12, color: Colors.green),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: const [
                            Text('Tipping options',
                                style: TextStyle(fontSize: 11, color: hintColor)),
                            SizedBox(width: 4),
                            Icon(Icons.close, size: 12, color: Colors.red),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Cột phải: giá
                  Text(
                    price,
                    style: const TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 6. Travel News
class _TravelNewsSection extends StatelessWidget {
  const _TravelNewsSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Travel News',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                'SEE MORE',
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          _buildNewsCard(
            context,
            'New Destination in Danang City',
            'Feb 5, 2026',
            'https://images.unsplash.com/photo-1559592413-7cec4d0cae2b?auto=format&fit=crop&q=80&w=600',
          ),
          const SizedBox(height: 15),
          _buildNewsCard(
            context,
            '\$1 Flight Ticket',
            'Feb 5, 2026',
            'https://images.unsplash.com/photo-1464037866556-6812c9d1c72e?auto=format&fit=crop&q=80&w=600',
          ),
        ],
      ),
    );
  }

  Widget _buildNewsCard(BuildContext context, String title, String date, String imgUrl) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewsDetailScreen(
              title: title,
              date: date,
              imgUrl: imgUrl,
            ),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          Text(date, style: const TextStyle(fontSize: 12, color: hintColor)),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              imgUrl,
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 120,
                width: double.infinity,
                color: Colors.grey[200],
                child: const Icon(Icons.broken_image, color: Colors.grey, size: 40),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
