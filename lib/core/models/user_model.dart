import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String email;
  final String fullName;
  final String? phoneNumber;
  final String? avatarUrl;
  final String? nationality;
  final String preferredLanguage;
  final List<String> interests;
  final double walletBalance;
  final double credits;
  final bool isPremium;
  final bool isVerified;
  final DateTime createdAt;
  final DateTime? lastLoginAt;

  UserModel({
    required this.id,
    required this.email,
    required this.fullName,
    this.phoneNumber,
    this.avatarUrl,
    this.nationality,
    this.preferredLanguage = 'en',
    this.interests = const [],
    this.walletBalance = 0.0,
    this.credits = 0.0,
    this.isPremium = false,
    this.isVerified = false,
    required this.createdAt,
    this.lastLoginAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      fullName: json['fullName'] ?? '',
      phoneNumber: json['phoneNumber'],
      avatarUrl: json['avatarUrl'],
      nationality: json['nationality'],
      preferredLanguage: json['preferredLanguage'] ?? 'en',
      interests: List<String>.from(json['interests'] ?? []),
      walletBalance: (json['walletBalance'] ?? 0).toDouble(),
      credits: (json['credits'] ?? 0).toDouble(),
      isPremium: json['isPremium'] ?? false,
      isVerified: json['isVerified'] ?? false,
      createdAt: json['createdAt'] is Timestamp
          ? (json['createdAt'] as Timestamp).toDate()
          : DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      lastLoginAt: json['lastLoginAt'] != null
          ? (json['lastLoginAt'] is Timestamp
              ? (json['lastLoginAt'] as Timestamp).toDate()
              : DateTime.parse(json['lastLoginAt']))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'avatarUrl': avatarUrl,
      'nationality': nationality,
      'preferredLanguage': preferredLanguage,
      'interests': interests,
      'walletBalance': walletBalance,
      'credits': credits,
      'isPremium': isPremium,
      'isVerified': isVerified,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastLoginAt': lastLoginAt != null ? Timestamp.fromDate(lastLoginAt!) : null,
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? fullName,
    String? phoneNumber,
    String? avatarUrl,
    String? nationality,
    String? preferredLanguage,
    List<String>? interests,
    double? walletBalance,
    double? credits,
    bool? isPremium,
    bool? isVerified,
    DateTime? createdAt,
    DateTime? lastLoginAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      nationality: nationality ?? this.nationality,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      interests: interests ?? this.interests,
      walletBalance: walletBalance ?? this.walletBalance,
      credits: credits ?? this.credits,
      isPremium: isPremium ?? this.isPremium,
      isVerified: isVerified ?? this.isVerified,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
    );
  }
}