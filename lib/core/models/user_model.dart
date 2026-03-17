import 'package:cloud_firestore/cloud_firestore.dart';

enum AppUserRole { tourist, vendor, admin, staff }

extension AppUserRoleX on AppUserRole {
  static AppUserRole fromName(String? value) {
    return AppUserRole.values.firstWhere(
      (role) => role.name == value,
      orElse: () => AppUserRole.tourist,
    );
  }

  String get label {
    switch (this) {
      case AppUserRole.tourist:
        return 'Tourist';
      case AppUserRole.vendor:
        return 'Vendor';
      case AppUserRole.admin:
        return 'Admin';
      case AppUserRole.staff:
        return 'Staff';
    }
  }
}

class UserModel {
  const UserModel({
    required this.id,
    required this.email,
    required this.fullName,
    this.phoneNumber,
    this.avatarUrl,
    this.nationality,
    this.preferredLanguage = 'en',
    this.interests = const <String>[],
    this.walletBalance = 0.0,
    this.credits = 0.0,
    this.isPremium = false,
    this.isVerified = false,
    this.primaryRole = AppUserRole.tourist,
    this.roles = const <AppUserRole>[AppUserRole.tourist],
    required this.createdAt,
    this.lastLoginAt,
  });

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
  final AppUserRole primaryRole;
  final List<AppUserRole> roles;
  final DateTime createdAt;
  final DateTime? lastLoginAt;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      fullName: json['fullName'] ?? '',
      phoneNumber: json['phoneNumber'],
      avatarUrl: json['avatarUrl'],
      nationality: json['nationality'],
      preferredLanguage: json['preferredLanguage'] ?? 'en',
      interests: List<String>.from(json['interests'] ?? const <String>[]),
      walletBalance: (json['walletBalance'] ?? 0).toDouble(),
      credits: (json['credits'] ?? 0).toDouble(),
      isPremium: json['isPremium'] ?? false,
      isVerified: json['isVerified'] ?? false,
      primaryRole: AppUserRoleX.fromName(json['primaryRole'] as String?),
      roles: ((json['roles'] as List<dynamic>?) ?? const <dynamic>['tourist'])
          .map((role) => AppUserRoleX.fromName(role as String?))
          .toList(growable: false),
      createdAt: json['createdAt'] is Timestamp
          ? (json['createdAt'] as Timestamp).toDate()
          : DateTime.parse(
              json['createdAt'] ?? DateTime.now().toIso8601String(),
            ),
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
      'primaryRole': primaryRole.name,
      'roles': roles.map((role) => role.name).toList(growable: false),
      'createdAt': Timestamp.fromDate(createdAt),
      'lastLoginAt':
          lastLoginAt != null ? Timestamp.fromDate(lastLoginAt!) : null,
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
    AppUserRole? primaryRole,
    List<AppUserRole>? roles,
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
      primaryRole: primaryRole ?? this.primaryRole,
      roles: roles ?? this.roles,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
    );
  }

  bool hasRole(AppUserRole role) {
    return primaryRole == role || roles.contains(role);
  }
}
