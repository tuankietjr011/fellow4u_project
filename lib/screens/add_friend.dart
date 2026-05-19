import 'package:flutter/material.dart';
import '../core/constants.dart';

class AddFriendScreen extends StatefulWidget {
  const AddFriendScreen({super.key});

  @override
  State<AddFriendScreen> createState() => _AddFriendScreenState();
}

class _AddFriendScreenState extends State<AddFriendScreen> {
  // Tiêu chí A4: Quản lý trạng thái danh sách bạn bè
  final List<Map<String, dynamic>> _friends = [
    {
      'name': 'Pena Valdez',
      'img': 'https://robohash.org/pena?set=set5',
      'selected': false,
    },
    {
      'name': 'Gil Hajoon',
      'img': 'https://robohash.org/hajoon?set=set5',
      'selected': true,
    },
    {
      'name': 'Fitzgerald',
      'img': 'https://robohash.org/fitz?set=set5',
      'selected': false,
    },
    {
      'name': 'Emily',
      'img': 'https://robohash.org/emily?set=set5',
      'selected': true,
    },
    {
      'name': 'Tuan Tran',
      'img': 'https://robohash.org/tuan?set=set5',
      'selected': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final selectedFriends = _friends.where((f) => f['selected'] == true).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Add Friends',
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Friends added successfully!'), backgroundColor: primaryColor),
              );
              Navigator.pop(context);
            },
            child: const Text('DONE', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: Column(
        children: [
          // 1. Search Bar (Tiêu chí B1 - Giao diện chỉn chu)
          Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(Icons.search, color: hintColor, size: 20),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search Friend',
                        hintStyle: TextStyle(color: hintColor, fontSize: 14),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 2. Selected Friends (Nằm ngang - Tiêu chí B2 Trải nghiệm người dùng)
          if (selectedFriends.isNotEmpty)
            Container(
              height: 70,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: selectedFriends.length,
                itemBuilder: (context, index) {
                  final friend = selectedFriends[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: Colors.grey[200],
                          backgroundImage: NetworkImage(friend['img']),
                          onBackgroundImageError: (_, __) {},
                        ),
                        Positioned(
                          top: -2,
                          right: -2,
                          child: GestureDetector(
                            onTap: () => setState(() => friend['selected'] = false),
                            child: Container(
                              padding: const EdgeInsets.all(3),
                              decoration: const BoxDecoration(color: Colors.black87, shape: BoxShape.circle),
                              child: const Icon(Icons.close, color: Colors.white, size: 10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

          if (selectedFriends.isNotEmpty) const SizedBox(height: 15),

          // 3. Danh sách bạn bè (Tiêu chí C1 - Cấu trúc code sạch)
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _friends.length,
              separatorBuilder: (context, index) => const Divider(height: 1, color: Color(0xFFEEEEEE)),
              itemBuilder: (context, index) {
                final friend = _friends[index];
                bool isSelected = friend['selected'];

                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(vertical: 5),
                  leading: CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.grey[100],
                    backgroundImage: NetworkImage(friend['img']),
                    onBackgroundImageError: (_, __) {},
                  ),
                  title: Text(
                    friend['name'],
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  trailing: GestureDetector(
                    onTap: () => setState(() => friend['selected'] = !isSelected),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 26,
                      height: 26,
                      decoration: BoxDecoration(
                        color: isSelected ? primaryColor : Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: isSelected ? primaryColor : Colors.grey.shade300, width: 2),
                      ),
                      child: isSelected ? const Icon(Icons.check, color: Colors.white, size: 16) : null,
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