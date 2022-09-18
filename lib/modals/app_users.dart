import 'dart:convert';

class AppUser {
  String? userID;
  String? name;
  String? imageUrl;
  String? email;
  String? phoneNumber;
  String? bio;
  int? userAge;

  AppUser({
    this.userID,
    this.name,
    this.imageUrl,
    this.email,
    this.phoneNumber,
    this.bio,
    this.userAge,
  });

  AppUser copyWith({
    String? userID,
    String? name,
    String? imageUrl,
    String? email,
    String? phoneNumber,
    String? bio,
    int? userAge,
  }) {
    return AppUser(
      userID: userID ?? this.userID,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      bio: bio ?? this.bio,
      userAge: userAge ?? this.userAge,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'name': name,
      'imageUrl': imageUrl,
      'email': email,
      'phoneNumber': phoneNumber,
      'bio': bio,
      'userAge': userAge,
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      userID: map['userID'],
      name: map['name'],
      imageUrl: map['imageUrl'],
      email: map['email'],
      phoneNumber: map['phoneNumber'],
      bio: map['bio'],
      userAge: map['userAge']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory AppUser.fromJson(String source) =>
      AppUser.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AppUser(userID: $userID, name: $name, imageUrl: $imageUrl, email: $email, phoneNumber: $phoneNumber, bio: $bio, userAge: $userAge)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AppUser &&
        other.userID == userID &&
        other.name == name &&
        other.imageUrl == imageUrl &&
        other.email == email &&
        other.phoneNumber == phoneNumber &&
        other.bio == bio &&
        other.userAge == userAge;
  }

  @override
  int get hashCode {
    return userID.hashCode ^
        name.hashCode ^
        imageUrl.hashCode ^
        email.hashCode ^
        phoneNumber.hashCode ^
        bio.hashCode ^
        userAge.hashCode;
  }
}
