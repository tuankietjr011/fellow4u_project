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
    return Guide(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'No Name',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
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