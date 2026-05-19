import 'package:flutter/material.dart';
import '../core/constants.dart';
import 'settings.dart'; 

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Cập nhật tên Emily và ảnh người thật đồng bộ với các màn hình trước
  String _name = 'Emily';
  String _email = 'emily@gmail.com';
  // Link ảnh người nữ thực tế từ Unsplash
  String _avatar = 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&q=80&w=200';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 50),
            _buildMyPhotos(),
            const SizedBox(height: 30),
            _buildMyJourneys(),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Image.network(
          'https://picsum.photos/seed/profilebg/800/400',
          height: 180,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(height: 180, color: Colors.grey[300]),
        ),
        Positioned(
          top: 40,
          right: 15,
          child: IconButton(
            icon: const Icon(Icons.settings, color: Colors.white, size: 28),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
              if (result != null && mounted) {
                setState(() {
                  // Cập nhật logic ở đây nếu cần
                });
              }
            },
          ),
        ),
        Positioned(
          bottom: -40,
          left: 20,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Avatar với viền trắng hiện đại
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 4),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)
                  ],
                ),
                child: CircleAvatar(
                  radius: 45,
                  backgroundColor: Colors.white,
                  backgroundImage: NetworkImage(_avatar),
                ),
              ),
              const SizedBox(width: 15),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _name,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      _email,
                      style: const TextStyle(color: hintColor, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMyPhotos() {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('My Photos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Icon(Icons.arrow_forward_ios, size: 16, color: hintColor),
            ],
          ),
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: 100,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            separatorBuilder: (context, index) => const SizedBox(width: 10),
            itemBuilder: (context, index) => ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                'https://picsum.photos/seed/travel$index/200/200',
                width: 100,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(width: 100, color: Colors.grey[200], child: const Icon(Icons.broken_image)),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMyJourneys() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('My Journeys', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Icon(Icons.arrow_forward_ios, size: 16, color: hintColor),
            ],
          ),
        ),
        const SizedBox(height: 15),
        _buildJourneyCard('Memory in Da Nang', 'Da Nang, Vietnam', 'May 15, 2026'),
        const SizedBox(height: 20),
        _buildJourneyCard('Spring in Sapa', 'Sapa, Vietnam', 'Jan 20, 2026'),
      ],
    );
  }

  Widget _buildJourneyCard(String title, String location, String date) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          SizedBox(
            height: 160,
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: _buildNetworkImage('https://images.unsplash.com/photo-1559592413-7cec4d0cae2b?auto=format&fit=crop&q=80&w=400', topLeft: 10, bottomLeft: 10),
                ),
                const SizedBox(width: 2),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(child: _buildNetworkImage('https://images.unsplash.com/photo-1528127269322-539801943592?auto=format&fit=crop&q=80&w=200', topRight: 10)),
                      const SizedBox(height: 2),
                      Expanded(child: _buildNetworkImage('https://images.unsplash.com/photo-1552465011-b4e21bf6e79a?auto=format&fit=crop&q=80&w=200', bottomRight: 10)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 14, color: Color(0xFF26C6A2)),
                      Text(location, style: const TextStyle(color: Color(0xFF26C6A2), fontSize: 12)),
                    ],
                  ),
                  Text(date, style: const TextStyle(color: hintColor, fontSize: 12)),
                ],
              ),
              const Row(
                children: [
                  Icon(Icons.favorite, color: Colors.red, size: 18),
                  SizedBox(width: 4),
                  Text('234 Likes', style: TextStyle(color: hintColor, fontSize: 12)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNetworkImage(String url, {double topLeft = 0, double bottomLeft = 0, double topRight = 0, double bottomRight = 0}) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(topLeft),
        bottomLeft: Radius.circular(bottomLeft),
        topRight: Radius.circular(topRight),
        bottomRight: Radius.circular(bottomRight),
      ),
      child: Image.network(
        url,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey[200], child: const Icon(Icons.image_not_supported)),
      ),
    );
  }
}