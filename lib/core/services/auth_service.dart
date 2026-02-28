import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../constants/app_constants.dart';

enum SocialAuthStatus { success, cancelled, accountExistsWithDifferentCredential }

class SocialAuthResult {
  const SocialAuthResult({
    required this.status,
    this.credential,
    this.pendingCredential,
    this.email,
  });

  final SocialAuthStatus status;
  final UserCredential? credential;
  final AuthCredential? pendingCredential;
  final String? email;

  bool get isSuccess => status == SocialAuthStatus.success;
}

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Auth state stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign up with email and password
  Future<UserModel?> signUp({
    required String email,
    required String password,
    required String fullName,
    String? phoneNumber,
    String? nationality,
    List<String> interests = const [],
  }) async {
    try {
      // Create user in Firebase Auth
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) return null;

      // Create user document in Firestore
      final userModel = UserModel(
        id: credential.user!.uid,
        email: email,
        fullName: fullName,
        phoneNumber: phoneNumber,
        nationality: nationality,
        interests: interests,
        createdAt: DateTime.now(),
      );

      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(credential.user!.uid)
          .set({...userModel.toJson(), 'onboardingCompleted': false});

      // Send email verification
      await credential.user!.sendEmailVerification();

      return userModel;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    }
  }

  // Sign in with email and password
  Future<UserModel?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) return null;

      // Get user document
      final doc = await _firestore
          .collection(AppConstants.usersCollection)
          .doc(credential.user!.uid)
          .get();

      if (!doc.exists) return null;

      // Update last login
      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(credential.user!.uid)
          .update({'lastLoginAt': Timestamp.now()});

      return UserModel.fromJson(doc.data()!);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    }
  }

  // Get user profile
  Future<UserModel?> getUserProfile(String userId) async {
    final doc = await _firestore
        .collection(AppConstants.usersCollection)
        .doc(userId)
        .get();

    if (!doc.exists) return null;
    return UserModel.fromJson(doc.data()!);
  }



  Future<bool?> fetchOnboardingCompleted(String userId) async {
    final doc = await _firestore
        .collection(AppConstants.usersCollection)
        .doc(userId)
        .get();

    if (!doc.exists) {
      return null;
    }

    final data = doc.data();
    if (data == null) {
      return null;
    }

    return data['onboardingCompleted'] == true;
  }

  Future<void> updateOnboardingCompleted({
    required String userId,
    required bool completed,
  }) async {
    await _firestore
        .collection(AppConstants.usersCollection)
        .doc(userId)
        .set({'onboardingCompleted': completed}, SetOptions(merge: true));
  }
  // Update user profile
  Future<void> updateUserProfile(UserModel user) async {
    await _firestore
        .collection(AppConstants.usersCollection)
        .doc(user.id)
        .update(user.toJson());
  }


  Future<void> updateCountry({
    required String userId,
    required String country,
  }) async {
    await _firestore
        .collection(AppConstants.usersCollection)
        .doc(userId)
        .set({'nationality': country, 'updatedAt': Timestamp.now()}, SetOptions(merge: true));
  }

  Future<void> updatePassword({
    required String email,
    required String currentPassword,
    required String newPassword,
  }) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw 'You need to sign in again before changing your password.';
    }

    try {
      final credential = EmailAuthProvider.credential(
        email: email,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    }
  }

  Future<SocialAuthResult> signInWithGoogleCredentialExchange({
    required String idToken,
    String? accessToken,
  }) async {
    final googleCredential = GoogleAuthProvider.credential(
      idToken: idToken,
      accessToken: accessToken,
    );

    return _exchangeSocialCredential(googleCredential);
  }

  Future<SocialAuthResult> signInWithFacebookCredentialExchange({
    required String accessToken,
  }) async {
    final facebookCredential = FacebookAuthProvider.credential(accessToken);
    return _exchangeSocialCredential(facebookCredential);
  }

  Future<SocialAuthResult> linkSocialCredential({
    required AuthCredential credential,
  }) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw 'You must be signed in before linking a social account.';
    }

    try {
      final userCredential = await currentUser.linkWithCredential(credential);
      return SocialAuthResult(
        status: SocialAuthStatus.success,
        credential: userCredential,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'provider-already-linked') {
        throw 'This social account is already linked to your profile.';
      }
      throw _handleAuthError(e);
    }
  }

  Future<SocialAuthResult> _exchangeSocialCredential(
    AuthCredential credential,
  ) async {
    try {
      final userCredential = await _auth.signInWithCredential(credential);
      return SocialAuthResult(
        status: SocialAuthStatus.success,
        credential: userCredential,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        return SocialAuthResult(
          status: SocialAuthStatus.accountExistsWithDifferentCredential,
          pendingCredential: e.credential,
          email: e.email,
        );
      }
      if (e.code == 'web-context-cancelled' || e.code == 'popup-closed-by-user') {
        return const SocialAuthResult(status: SocialAuthStatus.cancelled);
      }
      throw _handleAuthError(e);
    }
  }

  // Handle auth errors
  String _handleAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'email-already-in-use':
        return 'An account already exists for that email.';
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'invalid-email':
        return 'The email address is invalid.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'too-many-requests':
        return 'Too many requests. Try again later.';
      case 'credential-already-in-use':
        return 'This credential is already associated with another account.';
      case 'provider-already-linked':
        return 'This provider is already linked to your account.';
      case 'account-exists-with-different-credential':
        return 'An account already exists with the same email but a different sign-in method.';
      default:
        return 'Authentication error: ${e.message}';
    }
  }
}
