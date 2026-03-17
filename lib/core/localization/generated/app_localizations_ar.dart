// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'اكتشف مصر';

  @override
  String get navHome => 'الرئيسية';

  @override
  String get navSearch => 'بحث';

  @override
  String get navExplore => 'استكشف';

  @override
  String get navTrips => 'الرحلات';

  @override
  String get navProfile => 'الملف الشخصي';

  @override
  String get marketplaceTitle => 'السوق';

  @override
  String get marketplaceSubtitle =>
      'احجز الفنادق والشقق والجولات والمرشدين والسيارات والمعالم والمطاعم من مكان واحد.';

  @override
  String get featuredListings => 'عروض مميزة';

  @override
  String get browseByCategory => 'تصفح حسب الفئة';

  @override
  String get searchTitle => 'ابحث في مصر';

  @override
  String get searchHint => 'ابحث عن الفنادق والجولات والمعالم والمزيد';

  @override
  String get searchEmpty => 'لا توجد نتائج مطابقة للفلاتر الحالية.';

  @override
  String get loadMore => 'عرض المزيد';

  @override
  String get listingDetails => 'تفاصيل الإعلان';

  @override
  String get bookNow => 'احجز الآن';

  @override
  String get saveToTrip => 'أضف إلى البرنامج';

  @override
  String get savedToFavorites => 'تمت الإضافة إلى المفضلة';

  @override
  String get removedFromFavorites => 'تمت الإزالة من المفضلة';

  @override
  String get itineraryTitle => 'مخطط الرحلة';

  @override
  String get itineraryEmpty =>
      'ابدأ بإضافة الإقامات والأنشطة لبناء رحلتك في مصر.';

  @override
  String get itinerarySummary => 'ملخص الرحلة';

  @override
  String get estimatedSpend => 'الميزانية التقديرية';

  @override
  String get vendorDashboardTitle => 'لوحة البائع';

  @override
  String get vendorCreateListing => 'إنشاء إعلان';

  @override
  String get vendorListings => 'إعلاناتك';

  @override
  String get vendorPendingApproval => 'بانتظار الموافقة';

  @override
  String get vendorApproved => 'تمت الموافقة';

  @override
  String get vendorDraft => 'مسودة';

  @override
  String get adminDashboardTitle => 'لوحة الإدارة';

  @override
  String get staffDashboardTitle => 'فريق العمليات';

  @override
  String get settingsTitle => 'الإعدادات';

  @override
  String get workspaceMode => 'وضع المنصة';

  @override
  String get workspaceModeHelp =>
      'يمكنك معاينة تجربة السائح والبائع والإدارة والعمليات محلياً حتى يتم ربط صلاحيات الخلفية.';

  @override
  String get touristRole => 'سائح';

  @override
  String get vendorRole => 'بائع';

  @override
  String get adminRole => 'مدير';

  @override
  String get staffRole => 'موظف';

  @override
  String get languageEnglish => 'الإنجليزية';

  @override
  String get languageArabic => 'العربية';

  @override
  String get supportTickets => 'تذاكر الدعم';

  @override
  String get approvalQueue => 'قائمة الموافقات';

  @override
  String get secureSessionActive => 'تم تفعيل تخزين الجلسة الآمن.';

  @override
  String get reviewInAdmin => 'راجع في لوحة الإدارة';

  @override
  String get submitForReview => 'إرسال للمراجعة';

  @override
  String get approvedStatus => 'معتمد';

  @override
  String get pendingStatus => 'قيد الانتظار';

  @override
  String get draftStatus => 'مسودة';

  @override
  String get resolveTicket => 'إغلاق';

  @override
  String get moveToInProgress => 'بدء المعالجة';

  @override
  String get backToDashboard => 'العودة إلى اللوحة';

  @override
  String get startExploring => 'ابدأ الاستكشاف';

  @override
  String get bookableCategoriesNotice =>
      'المطاعم للاكتشاف والتقييم في الإصدار الأول. باقي الفئات قابلة للحجز.';
}
