import 'package:flutter/material.dart';

import '../../core/widgets/custom_app_bar.dart';

class TermsOfServicePage extends StatelessWidget {
  const TermsOfServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final sections = isArabic ? _arSections : _enSections;
    final metadata = isArabic
        ? 'الإصدار: 1.0.0 • تاريخ السريان: 20 سبتمبر 2026 • آخر تحديث: 20 سبتمبر 2026'
        : 'Version: 1.0.0 • Effective date: 20 Sep 2026 • Last updated: 20 Sep 2026';

    return Scaffold(
      appBar: CustomAppBar(
        title: isArabic ? 'شروط الاستخدام' : 'Terms of Service',
        showBackButton: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(metadata, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 16),
          for (final section in sections) ...[
            Text(
              section.title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 8),
            Text(section.body),
            const SizedBox(height: 16),
          ],
        ],
      ),
    );
  }
}

class _LegalSection {
  const _LegalSection(this.title, this.body);

  final String title;
  final String body;
}

const List<_LegalSection> _enSections = [
  _LegalSection(
    '1) Acceptance of terms',
    'By creating an account or using Discover Egypt, you agree to these Terms and all applicable laws. If you disagree with any part, you must stop using the app.',
  ),
  _LegalSection(
    '2) Bookings and payments',
    'Prices, availability, and booking conditions are provided by travel partners and may change. You are responsible for reviewing cancellation policies before payment.',
  ),
  _LegalSection(
    '3) User responsibilities',
    'You agree to provide accurate account details, keep your credentials secure, and avoid unlawful or abusive use of the platform, including fraudulent bookings or reviews.',
  ),
  _LegalSection(
    '4) Reviews and user content',
    'Content you submit must be truthful and respectful. We may moderate, remove, or restrict content that violates law, policy, or partner requirements.',
  ),
  _LegalSection(
    '5) Service availability',
    'We aim to keep the service available, but we cannot guarantee uninterrupted access. Maintenance, network issues, or third-party outages may affect features temporarily.',
  ),
  _LegalSection(
    '6) Liability and changes',
    'To the extent permitted by law, Discover Egypt is not liable for indirect losses related to partner services. We may update these Terms, and continued use means acceptance of updates.',
  ),
];

const List<_LegalSection> _arSections = [
  _LegalSection(
    '1) قبول الشروط',
    'باستخدامك لتطبيق Discover Egypt أو بإنشاء حساب، فإنك توافق على هذه الشروط والقوانين المعمول بها. إذا لم توافق على أي بند، يجب عليك التوقف عن استخدام التطبيق.',
  ),
  _LegalSection(
    '2) الحجوزات والمدفوعات',
    'الأسعار والتوفر وشروط الحجز يتم توفيرها من شركاء السفر وقد تتغير. أنت مسؤول عن مراجعة سياسات الإلغاء قبل إتمام الدفع.',
  ),
  _LegalSection(
    '3) مسؤوليات المستخدم',
    'تتعهد بتقديم بيانات صحيحة، والحفاظ على سرية بيانات الدخول، وعدم إساءة استخدام المنصة أو إجراء حجوزات أو تقييمات احتيالية.',
  ),
  _LegalSection(
    '4) التقييمات ومحتوى المستخدم',
    'يجب أن يكون المحتوى الذي ترسله صادقًا ومحترمًا. ويحق لنا مراجعة أو حذف أو تقييد أي محتوى يخالف القوانين أو السياسات أو متطلبات الشركاء.',
  ),
  _LegalSection(
    '5) إتاحة الخدمة',
    'نسعى لتوفير الخدمة بشكل مستمر، لكن لا يمكن ضمان عدم الانقطاع بشكل كامل. قد تؤثر الصيانة أو مشاكل الشبكة أو أعطال الجهات الخارجية على بعض الميزات مؤقتًا.',
  ),
  _LegalSection(
    '6) المسؤولية والتحديثات',
    'إلى الحد المسموح به قانونيًا، لا تتحمل Discover Egypt المسؤولية عن الخسائر غير المباشرة المتعلقة بخدمات الشركاء. قد نقوم بتحديث هذه الشروط واستمرارك في الاستخدام يعني قبولك للتحديثات.',
  ),
];
