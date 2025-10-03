class Contact {
  int? id;
  String name;
  String phone;
  String email;
  String? avatar;

  Contact({
    this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.avatar,
  });

  //Chuyển đổi đối tượng contact thành Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'avatar': avatar,
    };
  }

  //Tạo đối tượng Contact từ Map
  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
      avatar: map['avatar'],
    );
  }

  // Phương thức copy tạo bảng sao
  Contact copyWith({
    int? id,
    String? name,
    String? phone,
    String? email,
    String? avatar,
  }) {
    return Contact(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatar: avatar ?? this.avatar,
    );
  }
}
