import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../services/api_service.dart';

class MyTripsScreen extends StatefulWidget {
  const MyTripsScreen({super.key});

  @override
  State<MyTripsScreen> createState() => _MyTripsScreenState();
}

class _MyTripsScreenState extends State<MyTripsScreen> {
  final ApiService _apiService = ApiService();
  List<dynamic> _allTrips = [];
  bool _isLoading = true;
  String _currentTab = 'current'; 

  @override
  void initState() {
    super.initState();
    _fetchTripsData();
  }

  Future<void> _fetchTripsData() async {
    try {
      final data = await _apiService.fetchTodos(); 
      if (mounted) {
        setState(() {
          _allTrips = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Bộ lọc thông minh chấp hết mọi kiểu viết hoa viết thường từ Database
    final filteredTrips = _allTrips.where((trip) {
      String dbStatus = (trip['status'] ?? '').toString().toLowerCase().trim();
      String currentTabVal = _currentTab.toLowerCase().trim();
      return dbStatus.contains(currentTabVal) || currentTabVal.contains(dbStatus);
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: primaryColor))
          : RefreshIndicator(
              onRefresh: _fetchTripsData,
              color: primaryColor,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 15),
                    _buildTabFilters(),
                    const SizedBox(height: 15),
                    filteredTrips.isEmpty 
                        ? _buildEmptyState() 
                        : _buildTripList(filteredTrips),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: NetworkImage('https://picsum.photos/800/400?random=88'),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        color: Colors.black.withOpacity(0.4),
        padding: const EdgeInsets.only(top: 60, left: 20, right: 20),
        alignment: Alignment.topLeft,
        child: const Text('My Trips', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildTabFilters() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          _tabButton('Current Trips', 'current'),
          _tabButton('Next Trips', 'next'),
          _tabButton('Past Trips', 'past'),
          _tabButton('Wish List', 'wishlist'),
        ],
      ),
    );
  }

  Widget _tabButton(String text, String tabValue) {
    final isSelected = _currentTab.toLowerCase().trim() == tabValue.toLowerCase().trim();
    return GestureDetector(
      onTap: () => setState(() => _currentTab = tabValue),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? primaryColor : Colors.grey.shade300),
        ),
        child: Text(text, style: TextStyle(color: isSelected ? Colors.white : Colors.grey.shade600, fontWeight: FontWeight.bold, fontSize: 13)),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.only(top: 60),
      child: Column(
        children: [
          Icon(Icons.card_travel, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 10),
          Text('No trips in this category', style: TextStyle(color: Colors.grey.shade400, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildTripList(List<dynamic> trips) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: trips.length,
      itemBuilder: (context, index) {
        final trip = trips[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10)]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                child: Image.network(trip['imageUrl'] ?? 'https://picsum.photos/400/250', height: 160, width: double.infinity, fit: BoxFit.cover),
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
                          Text(trip['title'] ?? 'Trip', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16), maxLines: 1, overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 4),
                          Text(trip['location'] ?? 'Vietnam', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                    ),
                    Text(trip['price'] ?? '', style: const TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 18)),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}