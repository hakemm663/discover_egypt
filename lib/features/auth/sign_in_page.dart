import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../core/config/app_config.dart';
import '../../core/constants/image_urls.dart';
import '../../core/services/auth_service.dart';
import '../../core/utils/helpers.dart';
import '../../core/utils/validators.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/rounded_card.dart';

class SignInPage extends ConsumerStatefulWidget {
  const SignInPage({super.key});

  @override
  ConsumerState<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends ConsumerState<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isGoogleLoading = false;
  bool _isFacebookLoading = false;
  bool _isLinking = false;
  bool _obscurePassword = true;

  bool get _isAnyLoading =>
      _isLoading || _isGoogleLoading || _isFacebookLoading || _isLinking;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate() || _isAnyLoading) return;

    setState(() => _isLoading = true);

    try {
      final authService = ref.read(authServiceProvider);
      final user = await authService.signIn(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (user != null && mounted) {
        context.go('/home');
      }
    } catch (e) {
      if (mounted) {
        Helpers.showSnackBar(context, e.toString(), isError: true);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _signInWithGoogle() async {
    if (_isAnyLoading) return;

    setState(() => _isGoogleLoading = true);
    try {
      final authService = ref.read(authServiceProvider);
      final idToken = await _resolveGoogleIdToken();
      final accessToken = await _resolveGoogleAccessToken();

      final result = await authService.signInWithGoogleCredentialExchange(
        idToken: idToken,
        accessToken: accessToken,
      );

      await _handleSocialAuthResult(result, providerName: 'Google');
    } catch (e) {
      if (mounted) {
        Helpers.showSnackBar(context, e.toString(), isError: true);
      }
    } finally {
      if (mounted) {
        setState(() => _isGoogleLoading = false);
      }
    }
  }

  Future<void> _signInWithFacebook() async {
    if (_isAnyLoading) return;

    setState(() => _isFacebookLoading = true);
    try {
      final authService = ref.read(authServiceProvider);
      final accessToken = await _resolveFacebookAccessToken();

      final result = await authService.signInWithFacebookCredentialExchange(
        accessToken: accessToken,
      );

      await _handleSocialAuthResult(result, providerName: 'Facebook');
    } catch (e) {
      if (mounted) {
        Helpers.showSnackBar(context, e.toString(), isError: true);
      }
    } finally {
      if (mounted) {
        setState(() => _isFacebookLoading = false);
      }
    }
  }

  Future<void> _handleSocialAuthResult(
    SocialAuthResult result, {
    required String providerName,
  }) async {
    if (!mounted) return;

    switch (result.status) {
      case SocialAuthStatus.success:
        context.go('/home');
        break;
      case SocialAuthStatus.cancelled:
        Helpers.showSnackBar(context, '$providerName sign-in was cancelled.');
        break;
      case SocialAuthStatus.accountExistsWithDifferentCredential:
        setState(() => _isLinking = true);
        final linked = await _showLinkingDialog(result.email);
        setState(() => _isLinking = false);

        if (linked && mounted) {
          final pendingCredential = result.pendingCredential;
          if (pendingCredential == null) {
            Helpers.showSnackBar(
              context,
              'Could not complete account linking. Missing credential.',
              isError: true,
            );
            return;
          }

          final authService = ref.read(authServiceProvider);
          final linkResult = await authService.linkSocialCredential(
            credential: pendingCredential,
          );

          if (linkResult.isSuccess && mounted) {
            Helpers.showSnackBar(
              context,
              'Social account linked. You can now sign in with either provider.',
            );
            context.go('/home');
          }
        }
        break;
    }
  }

  Future<bool> _showLinkingDialog(String? email) async {
    return (await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Link account required'),
            content: Text(
              email == null
                  ? 'An account already exists with another sign-in method. Sign in with that provider first, then link this social account from a logged-in session.'
                  : 'An account for $email already exists with another sign-in method. Sign in with that provider first, then link this social account from a logged-in session.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Close'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('I already signed in'),
              ),
            ],
          ),
        )) ??
        false;
  }

  Future<String> _resolveGoogleIdToken() async {
    if (AppConfig.googleIdTokenForTesting.isNotEmpty) {
      return AppConfig.googleIdTokenForTesting;
    }

    throw UnsupportedError(
      'Google sign-in token acquisition is not configured in this build. Follow README social auth setup and inject tokens from native sign-in before enabling this button.',
    );
  }

  Future<String?> _resolveGoogleAccessToken() async {
    return AppConfig.googleAccessTokenForTesting.isEmpty
        ? null
        : AppConfig.googleAccessTokenForTesting;
  }

  Future<String> _resolveFacebookAccessToken() async {
    if (AppConfig.facebookAccessTokenForTesting.isNotEmpty) {
      return AppConfig.facebookAccessTokenForTesting;
    }

    throw UnsupportedError(
      'Facebook sign-in token acquisition is not configured in this build. Follow README social auth setup and inject tokens from native sign-in before enabling this button.',
    );
  }

  @override
  Widget build(BuildContext context) {
    final showGoogleButton = AppConfig.enableGoogleAuth;
    final showFacebookButton = AppConfig.enableFacebookAuth;
    final showSocialSection = showGoogleButton || showFacebookButton;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          CachedNetworkImage(
            imageUrl: Img.pyramidsMain,
            fit: BoxFit.cover,
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.3),
                  Colors.black.withValues(alpha: 0.7),
                ],
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  Text(
                    'Welcome Back!',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                        ),
                  ).animate().fadeIn(duration: 500.ms).slideX(begin: -0.2),
                  const SizedBox(height: 8),
                  Text(
                    'Sign in to continue your journey',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.white.withValues(alpha: 0.85),
                        ),
                  ).animate().fadeIn(delay: 200.ms, duration: 500.ms),
                  const SizedBox(height: 40),
                  RoundedCard(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Email',
                            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            validator: Validators.email,
                            decoration: const InputDecoration(
                              hintText: 'Enter your email',
                              prefixIcon: Icon(Icons.email_outlined),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Password',
                            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            textInputAction: TextInputAction.done,
                            validator: (value) =>
                                Validators.required(value, fieldName: 'Password'),
                            onFieldSubmitted: (_) => _signIn(),
                            decoration: InputDecoration(
                              hintText: 'Enter your password',
                              prefixIcon: const Icon(Icons.lock_outlined),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                ),
                                onPressed: () {
                                  setState(() => _obscurePassword = !_obscurePassword);
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: _isAnyLoading
                                  ? null
                                  : () => context.push('/forgot-password'),
                              child: const Text('Forgot Password?'),
                            ),
                          ),
                          const SizedBox(height: 20),
                          PrimaryButton(
                            label: 'Sign In',
                            isLoading: _isLoading,
                            onPressed: _signIn,
                          ),
                          if (showSocialSection) ...[
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(child: Divider(color: Colors.grey[300])),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: Text(
                                    'or continue with',
                                    style: TextStyle(color: Colors.grey[500]),
                                  ),
                                ),
                                Expanded(child: Divider(color: Colors.grey[300])),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                if (showGoogleButton)
                                  Expanded(
                                    child: _SocialButton(
                                      icon: 'G',
                                      label: 'Google',
                                      isLoading: _isGoogleLoading,
                                      onPressed: _isAnyLoading ? null : _signInWithGoogle,
                                    ),
                                  ),
                                if (showGoogleButton && showFacebookButton)
                                  const SizedBox(width: 12),
                                if (showFacebookButton)
                                  Expanded(
                                    child: _SocialButton(
                                      icon: 'f',
                                      label: 'Facebook',
                                      isLoading: _isFacebookLoading,
                                      onPressed: _isAnyLoading ? null : _signInWithFacebook,
                                    ),
                                  ),
                              ],
                            ),
                            if (_isLinking) ...[
                              const SizedBox(height: 12),
                              Row(
                                children: const [
                                  SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  ),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Waiting for existing account sign-in to complete linking...',
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ],
                      ),
                    ),
                  ).animate().fadeIn(delay: 400.ms, duration: 500.ms).slideY(begin: 0.2),
                  const SizedBox(height: 24),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.85),
                          ),
                        ),
                        TextButton(
                          onPressed: _isAnyLoading ? null : () => context.go('/sign-up'),
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(
                              color: Color(0xFFC89B3C),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 600.ms, duration: 500.ms),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final String icon;
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  const _SocialButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: isLoading ? null : onPressed,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14),
        side: BorderSide(color: Colors.grey[300]!),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isLoading)
            const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          else
            Text(
              icon,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: icon == 'G' ? Colors.red : Colors.blue,
              ),
            ),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
