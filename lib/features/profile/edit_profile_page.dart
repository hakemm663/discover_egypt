import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../core/constants/image_urls.dart';
import '../../core/models/user_model.dart';
import '../../core/utils/helpers.dart';
import '../../core/utils/validators.dart';
import '../../core/widgets/custom_app_bar.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/rounded_card.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({super.key});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isLoading = false;
  String? _userId;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile(UserModel existingUser) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final updatedUser = existingUser.copyWith(
        fullName: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phoneNumber: _phoneController.text.trim().isEmpty
            ? null
            : _phoneController.text.trim(),
      );

      await ref.read(authServiceProvider).updateUserProfile(updatedUser);

      if (mounted) {
        Helpers.showSnackBar(context, 'Profile updated successfully');
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        Helpers.showSnackBar(context, 'Failed to update profile: $e', isError: true);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _syncControllers(UserModel user) {
    if (_userId == user.id) return;

    _userId = user.id;
    _nameController.text = user.fullName;
    _emailController.text = user.email;
    _phoneController.text = user.phoneNumber ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Edit Profile',
        showBackButton: true,
      ),
      body: userAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _ProfileStatusView(
          title: 'Unable to load profile',
          message: 'Please try again.',
          actionLabel: 'Retry',
          onAction: () => ref.invalidate(currentUserProvider),
        ),
        data: (user) {
          if (user == null) {
            return _ProfileStatusView(
              title: 'Profile unavailable',
              message: 'Your profile document was not found or has expired.',
              actionLabel: 'Back',
              onAction: () => context.pop(),
            );
          }

          _syncControllers(user);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: CachedNetworkImageProvider(
                          user.avatarUrl ?? Img.avatarWoman,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Color(0xFFC89B3C),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.camera_alt_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  RoundedCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Full Name', style: Theme.of(context).textTheme.labelLarge),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _nameController,
                          validator: Validators.name,
                          decoration: const InputDecoration(
                            hintText: 'Enter your full name',
                            prefixIcon: Icon(Icons.person_outline_rounded),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  RoundedCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Email', style: Theme.of(context).textTheme.labelLarge),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _emailController,
                          validator: Validators.email,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            hintText: 'Enter your email',
                            prefixIcon: Icon(Icons.email_outlined),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  RoundedCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Phone Number', style: Theme.of(context).textTheme.labelLarge),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _phoneController,
                          validator: Validators.phone,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            hintText: 'Enter your phone number',
                            prefixIcon: Icon(Icons.phone_outlined),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  PrimaryButton(
                    label: 'Save Changes',
                    icon: Icons.check_rounded,
                    isLoading: _isLoading,
                    onPressed: () => _saveProfile(user),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ProfileStatusView extends StatelessWidget {
  const _ProfileStatusView({
    required this.title,
    required this.message,
    required this.actionLabel,
    required this.onAction,
  });

  final String title;
  final String message;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton(onPressed: onAction, child: Text(actionLabel)),
          ],
        ),
      ),
    );
  }
}
