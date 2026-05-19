import 'package:flutter/material.dart';
import '../core/constants.dart';

class CreateNewTripScreen extends StatefulWidget {
  const CreateNewTripScreen({super.key});

  @override
  State<CreateNewTripScreen> createState() => _CreateNewTripScreenState();
}

class _CreateNewTripScreenState extends State<CreateNewTripScreen> {
  int _travelerCount = 1;

  // Tiêu chí A4: Quản lý trạng thái danh sách địa điểm (Attractions)
  final List<Map<String, dynamic>> _attractions = [
    {
      'name': 'Dragon Bridge',
      'img': 'https://picsum.photos/seed/dragon/400/300',
      'selected': true,
    },
    {
      'name': 'Marble Mountains',
      'img': 'https://picsum.photos/seed/marble/400/300',
      'selected': false,
    },
    {
      'name': 'My Khe Beach',
      'img': 'https://picsum.photos/seed/beach/400/300',
      'selected': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: textColor, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Create New Trip',
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabeledTextField(label: 'Where you want to explore', hint: 'Danang, Vietnam', icon: Icons.location_on_outlined),
            const SizedBox(height: 20),
            _buildLabeledTextField(label: 'Date', hint: '05/15/2026', icon: Icons.calendar_today_outlined),
            const SizedBox(height: 20),
            
            const Text('Time', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: textColor)),
            Row(
              children: [
                Expanded(child: _buildTextFieldOnly(hint: 'From', icon: Icons.access_time)),
                const SizedBox(width: 20),
                Expanded(child: _buildTextFieldOnly(hint: 'To', icon: Icons.access_time)),
              ],
            ),
            const SizedBox(height: 25),

            const Text('Number of travelers', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: textColor)),
            const SizedBox(height: 10),
            Row(
              children: [
                _buildCounterButton(Icons.remove, () { // Đổi sang icon remove cho chuẩn UI
                  if (_travelerCount > 1) setState(() => _travelerCount--);
                }),
                Container(
                  width: 60,
                  alignment: Alignment.center,
                  child: Text('$_travelerCount', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                _buildCounterButton(Icons.add, () => setState(() => _travelerCount++)),
              ],
            ),
            const SizedBox(height: 25),

            const Text('Fee', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: textColor)),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(child: _buildTextFieldOnly(hint: '20.00', icon: Icons.monetization_on_outlined)),
                const SizedBox(width: 15),
                const Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: Text('(\$/hour)', style: TextStyle(color: textColor, fontSize: 14)),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            _buildLabeledTextField(label: "Guide's Language", hint: 'English, Vietnamese', icon: Icons.public),
            const SizedBox(height: 25),

            const Text('Attractions', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: textColor)),
            const SizedBox(height: 15),
            _buildAttractionsGrid(),
            const SizedBox(height: 30),
          ],
        ),
      ),
      bottomNavigationBar: _buildDoneButton(),
    );
  }

  // --- UI Helpers (Tối ưu hóa Scannability - Tiêu chí C1) ---

  Widget _buildLabeledTextField({required String label, required String hint, required IconData icon}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: textColor)),
        _buildTextFieldOnly(hint: hint, icon: icon),
      ],
    );
  }

  Widget _buildTextFieldOnly({required String hint, required IconData icon}) {
    return TextField(
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: hintColor),
        prefixIcon: Icon(icon, color: primaryColor, size: 20), // Đổi màu icon cho nổi bật
        enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey, width: 0.5)),
        focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: primaryColor, width: 2)),
        contentPadding: const EdgeInsets.symmetric(vertical: 10),
      ),
    );
  }

  Widget _buildCounterButton(IconData icon, VoidCallback onTap) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(icon, color: primaryColor),
      style: IconButton.styleFrom(
        backgroundColor: Colors.grey.shade100,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildAttractionsGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, crossAxisSpacing: 15, mainAxisSpacing: 15, childAspectRatio: 1.6,
      ),
      itemCount: _attractions.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) return _buildAddNewCard();
        final attr = _attractions[index - 1];
        return _buildAttractionCard(attr);
      },
    );
  }

  Widget _buildAddNewCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Icon(Icons.add_circle_outline, color: primaryColor), Text('Add New', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold))],
      ),
    );
  }

  Widget _buildAttractionCard(Map<String, dynamic> attr) {
    return GestureDetector(
      onTap: () => setState(() => attr['selected'] = !attr['selected']),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(attr['img'], fit: BoxFit.cover, 
              errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey[200])),
            Container(color: Colors.black.withOpacity(0.3)),
            Positioned(bottom: 8, left: 8, child: Text(attr['name'], style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold))),
            Positioned(top: 5, right: 5, child: Icon(attr['selected'] ? Icons.check_circle : Icons.circle_outlined, color: Colors.white, size: 18)),
          ],
        ),
      ),
    );
  }

  Widget _buildDoneButton() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ElevatedButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Trip created successfully!'), backgroundColor: primaryColor));
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: const Text('DONE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}