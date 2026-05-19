import 'package:flutter/material.dart';
import '../core/constants.dart';
import 'create_new_trip.dart';
import 'trip_detail.dart';

class MyTripsScreen extends StatefulWidget {
  const MyTripsScreen({super.key});

  @override
  State<MyTripsScreen> createState() => _MyTripsScreenState();
}

class _MyTripsScreenState extends State<MyTripsScreen> {
  int _selectedTab = 1; // 0: Current, 1: Next, 2: Past, 3: Wish List
  final List<String> _tabs = ['Current Trips', 'Next Trips', 'Past Trips', 'Wish List'];

  // Dữ liệu mẫu tổng hợp (Tiêu chí A2: Dữ liệu động)
  final List<Map<String, dynamic>> _allTrips = [
    {
      'title': 'Exploring Da Nang Riverside',
      'date': '15 May, 2026',
      'location': 'Da Nang, Vietnam',
      'imgUrl': 'https://picsum.photos/seed/current/600/400',
      'status': 0, // Current
    },
    {
      'title': 'Dragon Bridge Evening View',
      'date': '16 Nov, 2026',
      'location': 'Da Nang, Vietnam',
      'imgUrl': 'https://picsum.photos/seed/dragon/600/400',
      'status': 1, // Next
    },
    {
      'title': 'Hoi An Lantern Festival',
      'date': '20 Nov, 2026',
      'location': 'Quang Nam, Vietnam',
      'imgUrl': 'https://picsum.photos/seed/hoian/600/400',
      'status': 1, // Next
    },
    {
      'title': 'Old Trip to Ba Na Hills',
      'date': '10 Jan, 2025',
      'location': 'Da Nang, Vietnam',
      'imgUrl': 'https://picsum.photos/seed/past/600/400',
      'status': 2, // Past
    },
    {
      'title': 'My Son Sanctuary Visit',
      'date': 'TBD',
      'location': 'Quang Nam, Vietnam',
      'imgUrl': 'https://picsum.photos/seed/wish/600/400',
      'status': 3, // Wish List
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Column(
        children: [
          _buildHeader(),
          _buildTabBar(),
          Expanded(child: _buildListContent()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateNewTripScreen())),
        backgroundColor: const Color(0xFF26C6A2),
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
    );
  }

  Widget _buildHeader() {
    return Stack(
      children: [
        Image.network(
          'https://picsum.photos/seed/danang_header/800/400',
          height: 180, width: double.infinity, fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(height: 180, color: primaryColor),
        ),
        Container(height: 180, color: Colors.black.withOpacity(0.2)),
        const Positioned(
          top: 50, left: 20,
          child: Text('My Trips', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
        ),
        const Positioned(top: 55, right: 20, child: Icon(Icons.search, color: Colors.white, size: 28)),
      ],
    );
  }

  Widget _buildTabBar() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          children: List.generate(_tabs.length, (index) {
            bool isActive = _selectedTab == index;
            return GestureDetector(
              onTap: () => setState(() => _selectedTab = index),
              child: AnimatedContainer( // Thêm hiệu ứng chuyển tab mượt mà
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 8),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: isActive ? const Color(0xFF26C6A2) : Colors.transparent,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Text(
                  _tabs[index], 
                  style: TextStyle(color: isActive ? Colors.white : Colors.grey, fontWeight: FontWeight.bold)
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildListContent() {
    // Logic lọc dữ liệu dựa trên tab đang chọn
    final filteredTrips = _allTrips.where((trip) => trip['status'] == _selectedTab).toList();

    if (filteredTrips.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons. luggage_outlined, size: 80, color: Colors.grey[300]),
            const SizedBox(height: 10),
            Text('No trips in ${_tabs[_selectedTab]}', style: const TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      itemCount: filteredTrips.length,
      itemBuilder: (context, index) {
        final trip = filteredTrips[index];
        return _buildTripCard(
          title: trip['title'],
          date: trip['date'],
          location: trip['location'],
          imgUrl: trip['imgUrl'],
        );
      },
    );
  }

  Widget _buildTripCard({required String title, required String date, required String location, required String imgUrl}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Image.network(
              imgUrl, height: 160, width: double.infinity, fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(height: 160, color: Colors.grey[200]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Row(children: [const Icon(Icons.calendar_today, size: 14), const SizedBox(width: 8), Text(date)]),
                const SizedBox(height: 4),
                Row(children: [const Icon(Icons.location_on, size: 14), const SizedBox(width: 8), Text(location)]),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: _buildButton(
                        'Detail', 
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const TripDetailScreen()));
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildButton(
                        'Chat', 
                        icon: Icons.chat_bubble_outline,
                        onTap: () {
                          print("Chatting about $title");
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(String text, {IconData? icon, VoidCallback? onTap}) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Color(0x3326C6A2)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) Icon(icon, size: 16, color: const Color(0xFF26C6A2)),
          if (icon != null) const SizedBox(width: 5),
          Text(text, style: const TextStyle(color: Color(0xFF26C6A2), fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}