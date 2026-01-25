import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../app/providers.dart';
import '../../core/widgets/app_bar_widget.dart';
import '../../core/widgets/rounded_card.dart';
import '../../core/widgets/primary_button.dart';

class LanguagePage extends ConsumerStatefulWidget {
  const LanguagePage({super.key});

  @override
  ConsumerState<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends ConsumerState<LanguagePage> {
  String _selectedLanguage = 'en';
  String _searchQuery = '';

  final List<Map<String, String>> _languages = [
    {'code': 'en', 'name': 'English', 'flag': '🇺🇸', 'native': 'English'},
    {'code': 'ar', 'name': 'Arabic', 'flag': '🇪🇬', 'native': 'العربية'},
    {'code': 'fr', 'name': 'French', 'flag': '🇫🇷', 'native': 'Français'},
    {'code': 'de', 'name': 'German', 'flag': '🇩🇪', 'native': 'Deutsch'},
    {'code': 'it', 'name': 'Italian', 'flag': '🇮🇹', 'native': 'Italiano'},
    {'code': 'es', 'name': 'Spanish', 'flag': '🇪🇸', 'native': 'Español'},
    {'code': 'ru', 'name': 'Russian', 'flag': '🇷🇺', 'native': 'Русский'},
    {'code': 'zh', 'name': 'Chinese', 'flag': '🇨🇳', 'native': '中文'},
    {'code': 'ja', 'name': 'Japanese', 'flag': '🇯🇵', 'native': '日本語'},
    {'code': 'ko', 'name': 'Korean', 'flag': '🇰🇷', 'native': '한국어'},
    {'code': 'pt', 'name': 'Portuguese', 'flag': '🇵🇹', 'native': 'Português'},
    {'code': 'nl', 'name': 'Dutch', 'flag': '🇳🇱', 'native': 'Nederlands'},
    {'code': 'tr', 'name': 'Turkish', 'flag': '🇹🇷', 'native': 'Türkçe'},
    {'code': 'pl', 'name': 'Polish', 'flag': '🇵🇱', 'native': 'Polski'},
    {'code': 'hi', 'name': 'Hindi', 'flag': '🇮🇳', 'native': 'हिन्दी'},
  ];

  List<Map<String, String>> get _filteredLanguages {
    if (_searchQuery.isEmpty) {
      return _languages;
    }
    return _languages.where((lang) {
      final name = lang['name']!.toLowerCase();
      final native = lang['native']!.toLowerCase();
      final query = _searchQuery.toLowerCase();
      return name.contains(query) || native.contains(query);
    }).toList();
  }

  void _onLanguageSelected(String code) {
    setState(() {
      _selectedLanguage = code;
    });
  }

  void _onContinue() {
    // Save selected language
    ref.read(languageProvider.notifier).setLanguage(_selectedLanguage);
    // Navigate to nationality page
    context.go('/nationality');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Discover Egypt',
        showBackButton: true,
        showMenuButton: false,
        showProfileButton: false,
        onBackPressed: () => context.go('/cover'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title Section
              Text(
                'Select Your Language',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.1),

              const SizedBox(height: 8),

              Text(
                'Choose your preferred language for the app',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
              ).animate().fadeIn(delay: 100.ms, duration: 400.ms),

              const SizedBox(height: 20),

              // Search Field
              TextField(
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search language...',
                  prefixIcon: const Icon(Icons.search_rounded),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: Colors.grey.shade200),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                      color: Color(0xFFC89B3C),
                      width: 2,
                    ),
                  ),
                ),
              ).animate().fadeIn(delay: 200.ms, duration: 400.ms),

              const SizedBox(height: 16),

              // Selected Language Indicator
              if (_selectedLanguage.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFC89B3C).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFC89B3C).withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.check_circle_rounded,
                        color: Color(0xFFC89B3C),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Selected: ${_languages.firstWhere((l) => l['code'] == _selectedLanguage)['name']}',
                        style: const TextStyle(
                          color: Color(0xFFC89B3C),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 300.ms),

              const SizedBox(height: 16),

              // Languages Grid
              Expanded(
                child: RoundedCard(
                  padding: const EdgeInsets.all(16),
                  child: _filteredLanguages.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off_rounded,
                                size: 48,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'No languages found',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Try a different search term',
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        )
                      : GridView.builder(
                          itemCount: _filteredLanguages.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: 1.0,
                          ),
                          itemBuilder: (context, index) {
                            final language = _filteredLanguages[index];
                            final isSelected =
                                _selectedLanguage == language['code'];

                            return _LanguageTile(
                              flag: language['flag']!,
                              name: language['name']!,
                              native: language['native']!,
                              isSelected: isSelected,
                              onTap: () =>
                                  _onLanguageSelected(language['code']!),
                            ).animate(delay: Duration(milliseconds: 50 * index))
                                .fadeIn(duration: 300.ms)
                                .scale(
                                  begin: const Offset(0.8, 0.8),
                                  duration: 300.ms,
                                  curve: Curves.easeOutBack,
                                );
                          },
                        ),
                ),
              ).animate().fadeIn(delay: 300.ms, duration: 400.ms),

              const SizedBox(height: 20),

              // Continue Button
              PrimaryButton(
                label: 'Continue',
                icon: Icons.arrow_forward_rounded,
                onPressed: _onContinue,
              ).animate().fadeIn(delay: 400.ms, duration: 400.ms).slideY(begin: 0.2),

              const SizedBox(height: 12),

              // Skip Button
              Center(
                child: TextButton(
                  onPressed: () {
                    // Use default language (English) and continue
                    ref.read(languageProvider.notifier).setLanguage('en');
                    context.go('/nationality');
                  },
                  child: Text(
                    'Skip for now',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ).animate().fadeIn(delay: 500.ms, duration: 400.ms),
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  final String flag;
  final String name;
  final String native;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageTile({
    required this.flag,
    required this.name,
    required this.native,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        splashColor: const Color(0xFFC89B3C).withValues(alpha: 0.2),
        highlightColor: const Color(0xFFC89B3C).withValues(alpha: 0.1),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFFC89B3C).withValues(alpha: 0.15)
                : Colors.grey.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFFC89B3C)
                  : Colors.grey.withValues(alpha: 0.2),
              width: isSelected ? 2.5 : 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: const Color(0xFFC89B3C).withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Stack(
            children: [
              // Selected Checkmark
              if (isSelected)
                Positioned(
                  top: 6,
                  right: 6,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(
                      color: Color(0xFFC89B3C),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 14,
                    ),
                  ),
                ),

              // Content
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Flag
                    AnimatedScale(
                      scale: isSelected ? 1.1 : 1.0,
                      duration: const Duration(milliseconds: 200),
                      child: Text(
                        flag,
                        style: const TextStyle(fontSize: 28),
                      ),
                    ),

                    const SizedBox(height: 6),

                    // Language Name
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected
                            ? const Color(0xFFC89B3C)
                            : Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    // Native Name (if different)
                    if (native != name)
                      Text(
                        native,
                        style: TextStyle(
                          fontSize: 10,
                          color: isSelected
                              ? const Color(0xFFC89B3C).withValues(alpha: 0.8)
                              : Colors.grey[500],
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}