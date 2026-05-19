import 'package:flutter/material.dart';
import '../core/constants.dart';

class TourDetailScreen extends StatefulWidget {
  final String title;
  final String price;
  final String imgUrl;

  const TourDetailScreen({
    super.key,
    required this.title,
    required this.price,
    required this.imgUrl,
  });

  @override
  State<TourDetailScreen> createState() => _TourDetailScreenState();
}

class _TourDetailScreenState extends State<TourDetailScreen> {
  int _selectedDay = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderImage(context),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitleAndPrice(),
                  const SizedBox(height: 25),
                  _buildSummaryCard(),
                  const SizedBox(height: 30),
                  _buildScheduleSection(),
                  const SizedBox(height: 30),
                  _buildPriceSection(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
      // Nút bấm đặt tour được đặt ở dưới cùng màn hình
      bottomNavigationBar: _buildBookButton(),
    );
  }

  Widget _buildHeaderImage(BuildContext context) {
    return Stack(
      children: [
        Image.network(
          widget.imgUrl,
          height: 250,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            height: 250,
            color: Colors.grey[200],
            child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
          ),
        ),
        Container(
          height: 80,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black.withOpacity(0.5), Colors.transparent],
            ),
          ),
        ),
        SafeArea(
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ],
    );
  }

  Widget _buildTitleAndPrice() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Row(
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 16),
                  SizedBox(width: 5),
                  Text('4.8 (145 Reviews)', style: TextStyle(color: hintColor, fontSize: 13)),
                ],
              ),
            ],
          ),
        ),
        Text(widget.price, style: const TextStyle(color: primaryColor, fontSize: 24, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        children: [
          _buildSummaryRow('Itinerary', widget.title),
          const Divider(height: 25),
          _buildSummaryRow('Duration', '3 Days 2 Nights'),
          const Divider(height: 25),
          _buildSummaryRow('Departure', 'Da Nang City'),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: hintColor)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildScheduleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Schedule', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 15),
        Row(
          children: [
            _buildDayBtn(1),
            const SizedBox(width: 10),
            _buildDayBtn(2),
          ],
        ),
        const SizedBox(height: 20),
        _buildTimelineItem('08:00 AM', 'Pick up at hotel and start the journey.'),
        _buildTimelineItem('12:00 PM', 'Lunch at a local restaurant with traditional food.'),
        _buildTimelineItem('03:00 PM', 'Visit the main attractions of the tour.', isLast: true),
      ],
    );
  }

  Widget _buildDayBtn(int day) {
    bool isSelected = _selectedDay == day;
    return GestureDetector(
      onTap: () => setState(() => _selectedDay = day),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: isSelected ? primaryColor : Colors.grey.shade300),
        ),
        child: Text('Day $day', style: TextStyle(color: isSelected ? Colors.white : Colors.black, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildTimelineItem(String time, String content, {bool isLast = false}) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Column(
            children: [
              const Icon(Icons.circle, size: 12, color: primaryColor),
              if (!isLast) Expanded(child: Container(width: 2, color: primaryColor.withOpacity(0.3))),
            ],
          ),
          const SizedBox(width: 15),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(time, style: const TextStyle(fontWeight: FontWeight.bold, color: primaryColor)),
                const SizedBox(height: 5),
                SizedBox(width: 250, child: Text(content, style: const TextStyle(color: hintColor, fontSize: 13))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Price', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Adult (>10 years old)'),
          trailing: Text(widget.price, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ),
        const ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text('Children (5-10 years old)'),
          trailing: Text('\$150.00', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ),
      ],
    );
  }

  // 6. Book Button - ĐÃ SỬA LỖI NHẬN LỆNH NHẤN
  Widget _buildBookButton() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: ElevatedButton(
          onPressed: () {
            // Hiển thị thông báo đặt tour thành công
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Success! Your booking has been sent.'),
                backgroundColor: primaryColor,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            minimumSize: const Size(double.infinity, 55),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 0,
          ),
          child: const Text(
            'BOOK THIS TOUR', 
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}