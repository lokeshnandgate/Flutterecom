// ✅ user_model.dart

class User {
  final String id;
  final String username;
  final String email;
  final String? contactNumber;
  final String? description;
  final String? address;
  final String? locationUrl;
  final String? profilePic;

  User({
    required this.id,
    required this.username,
    required this.email,
    this.contactNumber,
    this.description,
    this.address,
    this.locationUrl,
    this.profilePic,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      username: json['username'],
      email: json['email'],
      contactNumber: json['contactNumber'],
      description: json['description'],
      address: json['address'],
      locationUrl: json['locationUrl'],
      profilePic: json['profilePic'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'username': username,
      'email': email,
      'contactNumber': contactNumber,
      'description': description,
      'address': address,
      'locationUrl': locationUrl,
      'profilePic': profilePic,
    };
  }
}
