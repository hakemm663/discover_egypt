import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  final String id;
  final String userId;
  final String userName;
  final String? userAvatar;
  final String itemId;
  final String itemType; // hotel, tour, car, restaurant
  final double rating;
  final String comment;
  final List<String> images;
  final int helpfulCount;
  final DateTime createdAt;

  ReviewModel({
    required this.id,
    required this.userId,
    required this.userName,
    this.userAvatar,
    required this.itemId,
    required this.itemType,
    required this.rating,
    required this.comment,
    this.images = const [],
    this.helpfulCount = 0,
    required this.createdAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      userName: json['userName'] ?? '',
      userAvatar: json['userAvatar'],
      itemId: json['itemId'] ?? '',
      itemType: json['itemType'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      comment: json['comment'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      helpfulCount: json['helpfulCount'] ?? 0,
      createdAt: json['createdAt'] is Timestamp
          ? (json['createdAt'] as Timestamp).toDate()
          : DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'userAvatar': userAvatar,
      'itemId': itemId,
      'itemType': itemType,
      'rating': rating,
      'comment': comment,
      'images': images,
      'helpfulCount': helpfulCount,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}