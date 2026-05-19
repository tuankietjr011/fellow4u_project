import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../services/api_service.dart'; // Tích hợp ApiService
import 'guide_detail.dart';
import 'tour_detail.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ApiService _apiService = ApiService(); // Khởi tạo Service
  bool _hasSearched = false;
  bool _isSearching = false; // Trạng thái đang gọi API

  void _performSearch(String query) async {
    if (query.trim().isNotEmpty) {
      setState(() {
        _isSearching = true; 
        _hasSearched = true;
      });

      // Giả lập gọi API tìm kiếm (Bạn có thể dùng fetchGuides hoặc fetchPhotos)
      await Future.delayed(const Duration(seconds: 1)); 

      if (mounted) {
        setState(() {
          _isSearching = false;
        });
      }
    } else {
      _clearSearch();
    }
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _hasSearched = false;
      _isSearching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildSearchBar(),
            Expanded(
              child: _isSearching
                  ? const Center(child: CircularProgressIndicator(color: primaryColor))
                  : _hasSearched
                      ? _buildSearchResults()
                      : _buildPopularDestinations(),
            ),
          ],
        ),
      ),
    );
  }

  // --- Widget Search Bar (Giữ nguyên logic của bạn nhưng tối ưu nút Cancel) ---
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.close, color: textColor),
            onPressed: () => Navigator.pop(context),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Container(
              height: 45,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: TextField(
                controller: _searchController,
                onSubmitted: _performSearch,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Where you want to explore',
                  hintStyle: const TextStyle(color: hintColor, fontSize: 14),
                  border: InputBorder.none,
                  suffixIcon: _hasSearched
                      ? IconButton(
                          icon: const Icon(Icons.cancel, color: Colors.grey, size: 20),
                          onPressed: _clearSearch,
                        )
                      : null,
                ),
              ),
            ),
          ),
          if (_hasSearched) ...[
            const SizedBox(width: 10),
            IconButton(
              icon: const Icon(Icons.tune, color: textColor),
              onPressed: _showFilterBottomSheet,
            ),
          ],
        ],
      ),
    );
  }

  // --- Widget Kết quả tìm kiếm (Sửa lỗi ảnh gạch đỏ bằng Picsum & RoboHash) ---
  Widget _buildSearchResults() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildResultHeader('Guides in Danang'),
          const SizedBox(height: 15),
          _buildGuideGrid(),
          const SizedBox(height: 30),
          _buildResultHeader('Tours in Danang'),
          const SizedBox(height: 15),
          _buildTourList(),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildResultHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const Text('SEE MORE', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 12)),
      ],
    );
  }

  Widget _buildGuideGrid() {
    final List<String> names = ['Tuan Tran', 'Linh Hana', 'Kevin Smith', 'Mai Anh'];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, crossAxisSpacing: 15, mainAxisSpacing: 15, childAspectRatio: 0.75,
      ),
      itemCount: names.length,
      itemBuilder: (context, index) {
        final avatarUrl = 'https://robohash.org/${names[index]}?set=set5';
        return GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => GuideDetailScreen(name: names[index], location: 'Danang, Vietnam', avatar: avatarUrl))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(avatarUrl, width: double.infinity, fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey[200], child: const Icon(Icons.person))),
                ),
              ),
              const SizedBox(height: 8),
              Text(names[index], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const Row(children: [Icon(Icons.location_on, size: 12, color: primaryColor), Text('Danang, Vietnam', style: TextStyle(fontSize: 11, color: primaryColor))]),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTourList() {
    final tours = [
      {'title': 'Ba Na Hills Adventure', 'price': '\$400.00'},
      {'title': 'Hoi An Ancient Town', 'price': '\$250.00'},
    ];
    return Column(
      children: tours.map((tour) => Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: _buildTourCard(tour['title']!, tour['price']!, 'https://picsum.photos/seed/${tour['title']}/600/400'),
      )).toList(),
    );
  }

  // --- Các hàm phụ trợ khác giữ nguyên logic cũ của bạn nhưng thêm errorBuilder cho ảnh ---
  Widget _buildTourCard(String title, String price, String imgUrl) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => TourDetailScreen(title: title, price: price, imgUrl: imgUrl))),
      child: Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)]),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(imgUrl, height: 160, width: double.infinity, fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(height: 160, color: Colors.grey[200], child: const Icon(Icons.broken_image))),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(price, style: const TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPopularDestinations() {
    final List<String> popularPlaces = ['Danang, Vietnam', 'Ho Chi Minh, Vietnam', 'Venice, Italy'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Popular destinations', style: TextStyle(color: hintColor, fontSize: 13)),
          const SizedBox(height: 10),
          ...popularPlaces.map((place) => ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(place, style: const TextStyle(color: textColor, fontSize: 15, fontWeight: FontWeight.w500)),
            onTap: () {
              _searchController.text = place;
              _performSearch(place);
            },
          )).toList(),
        ],
      ),
    );
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return const FilterBottomSheet();
      },
    );
  }
} // Kết thúc class _SearchScreenState

// --- WIDGET TÁCH RỜI CHO FILTER BOTTOM SHEET ---
class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  int _tabIndex = 0;
  List<String> _selectedLanguages = ['Vietnamese'];
  final List<String> _languages = ['Vietnamese', 'English', 'Korean', 'Spanish', 'French'];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        top: 20, left: 20, right: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
              const Expanded(child: Center(child: Text('Filters', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)))),
              const SizedBox(width: 48),
            ],
          ),
          const SizedBox(height: 25),
          // Nút Toggle
          Container(
            height: 40,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.shade300)),
            child: Row(
              children: [
                Expanded(child: _buildToggleButton(0, 'Guides')),
                Expanded(child: _buildToggleButton(1, 'Tours')),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text("Guide's Language", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            children: _languages.map((lang) {
              final isSelected = _selectedLanguages.contains(lang);
              return GestureDetector(
                onTap: () => setState(() => isSelected ? _selectedLanguages.remove(lang) : _selectedLanguages.add(lang)),
                child: Chip(
                  label: Text(lang, style: TextStyle(color: isSelected ? Colors.white : Colors.black)),
                  backgroundColor: isSelected ? primaryColor : Colors.white,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
              child: const Text('APPLY FILTERS', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton(int index, String title) {
    bool isActive = _tabIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _tabIndex = index),
      child: Container(
        decoration: BoxDecoration(color: isActive ? primaryColor : Colors.white, borderRadius: BorderRadius.circular(8)),
        child: Center(child: Text(title, style: TextStyle(color: isActive ? Colors.white : textColor))),
      ),
    );
  }
}