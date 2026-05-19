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
              image: NetworkImage('https://images.unsplash.com/photo-1506012787146-f92b2d7d6d96?auto=format&fit=crop&q=80&w=800'),
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
              itemCount: photos.length > 5 ? 5 : photos.length,
              itemBuilder: (context, index) {
                final item = photos[index];
                return Container(
                  width: 160,
                  margin: const EdgeInsets.only(right: 15),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                        child: Image.network(
                          'https://images.unsplash.com/photo-1530789253388-582c481c54b0?auto=format&fit=crop&q=80&w=400', 
                          height: 120, width: double.infinity, fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(height: 120, color: Colors.grey[200]),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(item['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13), maxLines: 2, overflow: TextOverflow.ellipsis),
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

// 3. Best Guides - ĐÃ CẬP NHẬT ẢNH NGƯỜI THẬT
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
            height: 220,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: guides.length,
              itemBuilder: (context, index) {
                final guide = guides[index];
                
                // Danh sách ảnh người thật từ Unsplash
                final List<String> realPeople = [
                  'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&q=80&w=200',
                  'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&q=80&w=200',
                  'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&q=80&w=200',
                  'https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&q=80&w=200',
                ];
                final avatarUrl = realPeople[index % realPeople.length];

                return GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => GuideDetailScreen(name: guide.name, location: guide.email, avatar: avatarUrl))),
                  child: Container(
                    width: 140,
                    margin: const EdgeInsets.only(right: 15),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(avatarUrl, height: 140, width: 140, fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => const Icon(Icons.person, size: 120)),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          guide.name, 
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
            itemCount: 5,
            itemBuilder: (context, index) {
              return Container(
                width: 260,
                margin: const EdgeInsets.only(right: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(
                    image: NetworkImage('https://images.unsplash.com/photo-1544551763-46a013bb70d5?auto=format&fit=crop&q=80&w=500'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.black.withOpacity(0.8)]),
                  ),
                  padding: const EdgeInsets.all(15),
                  alignment: Alignment.bottomLeft,
                  child: const Text('Scuba Diving in Da Nang', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
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
          itemCount: 3,
          itemBuilder: (context, index) {
            final List<String> tourImages = [
              'https://images.unsplash.com/photo-1559592413-7cec4d0cae2b?auto=format&fit=crop&q=80&w=600',
              'https://images.unsplash.com/photo-1528127269322-539801943592?auto=format&fit=crop&q=80&w=600',
              'https://images.unsplash.com/photo-1552465011-b4e21bf6e79a?auto=format&fit=crop&q=80&w=600',
            ];

            return GestureDetector(
              onTap: () => Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (context) => TourDetailScreen( 
                    title: 'Da Nang City Adventure', 
                    price: '\$400.00', 
                    imgUrl: tourImages[index % tourImages.length]
                  )
                )
              ),
              child: Container(
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)]),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                      child: Image.network(tourImages[index % tourImages.length], height: 180, width: double.infinity, fit: BoxFit.cover),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Gold Bridge Adventure', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)), Text('Vietnam', style: TextStyle(color: primaryColor, fontSize: 12))]),
                          Text('\$400.00', style: const TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 18)),
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