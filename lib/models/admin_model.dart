// Admin model
class Admin {
  String id;
  String name;
  String email;

  Admin({
    required this.id,
    required this.name,
    required this.email,
  });

  // fromMap
  factory Admin.fromMap(Map<String, dynamic> map) {
    return Admin(
      id: map['id'],
      name: map['name'],
      email: map['email'],
    );
  }

  // toMap
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }
}
