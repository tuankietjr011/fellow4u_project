import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../services/api_service.dart';
import 'guide_detail.dart';
import 'tour_detail.dart';
import 'search_screen.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final ApiService _apiService = ApiService();
  List<dynamic> _guides = [];
  List<dynamic> _photos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAllData();
  }

  Future<void> _loadAllData() async {
    try {
      final results = await Future.wait([
        _apiService.fetchGuides(),
        _apiService.fetchPhotos(),
      ]);

      if (mounted) {
        setState(() {
          _guides = results[0];
          _photos = results[1]; 
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Lỗi kết nối: $e"), backgroundColor: Colors.redAccent),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: primaryColor)),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: RefreshIndicator(
        onRefresh: _loadAllData,
        color: primaryColor,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _HeaderSection(),
              const SizedBox(height: 10),
              _TopJourneysSection(photos: _photos),
              _BestGuidesSection(guides: _guides), 
              _TopExperiencesSection(photos: _photos), 
              _FeaturedToursSection(photos: _photos), 
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

// 1. Header & Search Bar
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
              image: NetworkImage('https://picsum.photos/800/400?random=99'), // Đổi sang link bất tử
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            color: Colors.black.withOpacity(0.3),
            padding: const EdgeInsets.only(top: 60, left: 20, right: 20),
            child: const Text('Explore', style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold)),
          ),
        ),
        Positioned(
          bottom: -25, left: 20, right: 20,
          child: GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchScreen())),
            child: Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)]),
              child: const Row(children: [Icon(Icons.search, color: hintColor), SizedBox(width: 10), Text('Where do you want to explore?', style: TextStyle(color: hintColor))]),
            ),
          ),
        ),
      ],
    );
  }
}

// 2. Top Journeys
class _TopJourneysSection extends StatelessWidget {
  final List<dynamic> photos;
  const _TopJourneysSection({required this.photos});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40, left: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Top Journeys', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          SizedBox(
            height: 220,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: photos.length,
              itemBuilder: (context, index) {
                final item = photos[index];
                // Sử dụng hàm sinh link Picsum động theo ID, triệt tiêu 100% lỗi 404
                final int id = item['id'] ?? index;
                final String imgUrl = 'https://picsum.photos/id/${(id + 10) % 50}/400/300';

                return Container(
                  width: 160,
                  margin: const EdgeInsets.only(right: 15),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 5)]),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                        child: Image.network(
                          imgUrl, 
                          height: 120, width: double.infinity, fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            height: 120, color: Colors.grey[300],
                            child: const Icon(Icons.image, color: Colors.grey),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(item['title'] ?? 'No Title', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13), maxLines: 2, overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// 3. Best Guides
class _BestGuidesSection extends StatelessWidget {
  final List<dynamic> guides;
  const _BestGuidesSection({required this.guides});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Best Guides', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          SizedBox(
            height: 190,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: guides.length,
              itemBuilder: (context, index) {
                final guide = guides[index]; 
                String fullName = guide.name; 
                if (fullName.isEmpty || fullName == 'No Name') {
                  fullName = 'Local Guide';
                }

                // Cấu hình link ảnh avatar bất tử, không lo sập link
                final String avatarUrl = 'https://picsum.photos/id/${(index + 60) % 100}/200/200';

                return GestureDetector(
                  onTap: () => Navigator.push(
                    context, 
                    MaterialPageRoute(
                      builder: (context) => GuideDetailScreen(name: fullName, location: guide.email, avatar: avatarUrl)
                    )
                  ),
                  child: Container(
                    width: 140,
                    margin: const EdgeInsets.only(right: 15),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(avatarUrl, height: 120, width: 120, fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => const Icon(Icons.person, size: 100)),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          fullName, 
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14), 
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// 4. Top Experiences
class _TopExperiencesSection extends StatelessWidget {
  final List<dynamic> photos;
  const _TopExperiencesSection({required this.photos});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 20, left: 20, bottom: 15),
          child: Text('Top Experiences', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        SizedBox(
          height: 160,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: 20),
            itemCount: photos.length, 
            itemBuilder: (context, index) {
              final item = photos[index];
              final int id = item['id'] ?? index;
              // Ép sinh link ảnh phong cảnh ngẫu nhiên chất lượng cao từ Picsum, chống lỗi 404 tuyệt đối
              final String imgUrl = 'https://picsum.photos/id/${(id + 15) % 50}/500/300';
              final String title = item['title'] ?? 'Local Experience';

              return Container(
                width: 260,
                margin: const EdgeInsets.only(right: 15),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Image.network(
                          imgUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey[300]),
                        ),
                      ),
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.black.withOpacity(0.8)]),
                          ),
                          padding: const EdgeInsets.all(15),
                          alignment: Alignment.bottomLeft,
                          child: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// 5. Featured Tours
class _FeaturedToursSection extends StatelessWidget {
  final List<dynamic> photos;
  const _FeaturedToursSection({required this.photos});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 30, left: 20, bottom: 15),
          child: Text('Featured Tours', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: photos.length, 
          itemBuilder: (context, index) {
            final photoItem = photos[index];
            final int id = photoItem['id'] ?? index;
            // Thay thế bằng link ảnh phong cảnh du lịch sống mãi mãi
            final String currentImg = 'https://picsum.photos/id/${(id + 30) % 50}/600/400';
            final String dynamicPrice = '\$${photoItem['price'] ?? '35.00'}';
            final String location = photoItem['location'] ?? 'Vietnam';

            return GestureDetector(
              onTap: () => Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (context) => TourDetailScreen( 
                    title: photoItem['title'] ?? 'Tour', 
                    price: dynamicPrice, 
                    imgUrl: currentImg
                  )
                )
              ),
              child: Container(
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10)]),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                      child: Image.network(
                        currentImg, 
                        height: 180, width: double.infinity, fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 180, color: Colors.grey[300],
                          child: const Icon(Icons.broken_image, size: 40, color: Colors.grey),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start, 
                              children: [
                                Text(
                                  photoItem['title'] ?? 'Tour Title', 
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ), 
                                Text(location, style: const TextStyle(color: primaryColor, fontSize: 12))
                              ]
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(dynamicPrice, style: const TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 18)),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}