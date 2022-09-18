import 'dart:convert';

import 'package:flutter/foundation.dart';

class Post {
  String? postID;
  String? userName;
  String? userPhoto;
  String? userID;
  String? description;
  DateTime? dateTime;
  List<String>? postUrls;

  Post({
    this.postID,
    this.userName,
    this.userPhoto,
    this.userID,
    this.description,
    this.dateTime,
    this.postUrls,
  });

  Post copyWith({
    String? postID,
    String? userName,
    String? userPhoto,
    String? userID,
    String? description,
    DateTime? dateTime,
    List<String>? postUrls,
  }) {
    return Post(
      postID: postID ?? this.postID,
      userName: userName ?? this.userName,
      userPhoto: userPhoto ?? this.userPhoto,
      userID: userID ?? this.userID,
      description: description ?? this.description,
      dateTime: dateTime ?? this.dateTime,
      postUrls: postUrls ?? this.postUrls,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'postID': postID,
      'userName': userName,
      'userPhoto': userPhoto,
      'userID': userID,
      'description': description,
      'dateTime': dateTime?.millisecondsSinceEpoch,
      'postUrls': postUrls,
    };
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      postID: map['postID'],
      userName: map['userName'],
      userPhoto: map['userPhoto'],
      userID: map['userID'],
      description: map['description'],
      dateTime: map['dateTime'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['dateTime'])
          : null,
      postUrls: List<String>.from(map['postUrls']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Post.fromJson(String source) => Post.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Post(postID: $postID, userName: $userName, userPhoto: $userPhoto, userID: $userID, description: $description, dateTime: $dateTime, postUrls: $postUrls)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Post &&
        other.postID == postID &&
        other.userName == userName &&
        other.userPhoto == userPhoto &&
        other.userID == userID &&
        other.description == description &&
        other.dateTime == dateTime &&
        listEquals(other.postUrls, postUrls);
  }

  @override
  int get hashCode {
    return postID.hashCode ^
        userName.hashCode ^
        userPhoto.hashCode ^
        userID.hashCode ^
        description.hashCode ^
        dateTime.hashCode ^
        postUrls.hashCode;
  }
}
