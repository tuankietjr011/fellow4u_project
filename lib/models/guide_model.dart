class Guide {
  final int id;
  final String name;
  final String email;
  final String phone;

  // Constructor
  Guide({
    required this.id, 
    required this.name, 
    required this.email, 
    required this.phone
  });

  factory Guide.fromJson(Map<String, dynamic> json) {
    // Mẹo tối cao: Bốc cả hai trường FirstName và LastName từ Java về (bất kể chuẩn camelCase hay snake_case)
    String firstName = json['first_name'] ?? json['firstName'] ?? '';
    String lastName = json['last_name'] ?? json['lastName'] ?? '';
    
    // Gộp họ và tên lại thành một chuỗi duy nhất, nếu trống cả hai thì mới hiện 'No Name'
    String fullName = '$firstName $lastName'.trim();
    if (fullName.isEmpty) {
      fullName = 'No Name';
    }

    return Guide(
      id: json['id'] ?? 0,
      name: fullName,
      email: json['email'] ?? json['username'] ?? '', // Phòng hờ nếu lấy trường username làm email hiển thị
      phone: json['phone'] ?? '0905-UDA-INFO',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
    };
  }
}