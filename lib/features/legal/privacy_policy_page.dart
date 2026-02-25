import 'package:flutter/material.dart';

import '../../core/widgets/custom_app_bar.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final sections = isArabic ? _arSections : _enSections;
    final metadata = isArabic
        ? 'الإصدار: 1.0.0 • تاريخ السريان: 20 سبتمبر 2026 • آخر مراجعة: 20 سبتمبر 2026'
        : 'Version: 1.0.0 • Effective date: 20 Sep 2026 • Last reviewed: 20 Sep 2026';

    return Scaffold(
      appBar: CustomAppBar(
        title: isArabic ? 'سياسة الخصوصية' : 'Privacy Policy',
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
    '1) Information we collect',
    'We collect account details (name, email, phone), booking activity, payment references, in-app interactions, and support communications. We do not store full payment card numbers in the app database.',
  ),
  _LegalSection(
    '2) Why we process your data',
    'We process data to create and secure your account, complete bookings, provide travel recommendations, respond to support requests, prevent fraud, and improve app performance and reliability.',
  ),
  _LegalSection(
    '3) Sharing and third parties',
    'We share only required information with trusted providers such as accommodation partners, payment processors, analytics and messaging services. Each provider is contractually required to safeguard your data.',
  ),
  _LegalSection(
    '4) Retention and security',
    'We keep personal data only for as long as necessary for legal, operational, and financial obligations. We use authentication controls, encrypted transport, and access restrictions to protect your information.',
  ),
  _LegalSection(
    '5) Your rights',
    'You can request access, correction, deletion, or export of your personal data. You can also adjust notification and privacy preferences from Settings. For legal requests, contact support@discoveregypt.app.',
  ),
  _LegalSection(
    '6) International users',
    'If you use the app outside Egypt, your information may be processed in other jurisdictions where our partners operate. We apply reasonable safeguards for cross-border data transfers.',
  ),
];

const List<_LegalSection> _arSections = [
  _LegalSection(
    '1) البيانات التي نقوم بجمعها',
    'نجمع بيانات الحساب (الاسم، البريد الإلكتروني، الهاتف)، وسجل الحجوزات، ومراجع الدفع، والتفاعلات داخل التطبيق، ورسائل الدعم. لا نقوم بتخزين أرقام البطاقات البنكية الكاملة داخل قاعدة بيانات التطبيق.',
  ),
  _LegalSection(
    '2) أسباب معالجة البيانات',
    'نقوم بمعالجة البيانات لإنشاء الحساب وتأمينه، وإتمام الحجوزات، وتقديم توصيات السفر، والرد على طلبات الدعم، ومنع الاحتيال، وتحسين أداء التطبيق وموثوقيته.',
  ),
  _LegalSection(
    '3) المشاركة مع أطراف خارجية',
    'نشارك فقط البيانات الضرورية مع مزوّدي الخدمة الموثوقين مثل شركاء الإقامة، وجهات معالجة الدفع، وخدمات التحليلات والرسائل. ويلتزم كل مزود بحماية البيانات تعاقديًا.',
  ),
  _LegalSection(
    '4) الاحتفاظ والأمان',
    'نحتفظ بالبيانات الشخصية فقط للمدة اللازمة للالتزامات القانونية والتشغيلية والمالية. ونستخدم ضوابط مصادقة ونقلًا مشفرًا وتقييدًا للصلاحيات لحماية معلوماتك.',
  ),
  _LegalSection(
    '5) حقوقك',
    'يمكنك طلب الوصول إلى بياناتك الشخصية أو تصحيحها أو حذفها أو تصديرها. كما يمكنك تعديل إعدادات الإشعارات والخصوصية من صفحة الإعدادات. للطلبات القانونية تواصل عبر support@discoveregypt.app.',
  ),
  _LegalSection(
    '6) المستخدمون الدوليون',
    'إذا استخدمت التطبيق خارج مصر، فقد تتم معالجة بياناتك في دول أخرى يعمل بها شركاؤنا. نحن نطبق ضمانات معقولة عند نقل البيانات عبر الحدود.',
  ),
];
