/// A lightweight translation library for Flutter inspired by GetX.
///
/// This library provides simple internationalization with automatic locale
/// detection, parameter replacement, plural support, and RTL language support.
library translation_manager;

import 'dart:ui';

/// Manages translations for the entire application.
///
/// This is a singleton class that handles locale changes, translation lookups,
/// fallback behavior, and text direction for RTL languages.
///
/// Example:
/// ```dart
/// final translations = AppTranslations();
/// TranslationManager().addTranslations(translations.keys);
/// TranslationManager().setFallbackLocale(const Locale('en', 'US'));
/// ```
class TranslationManager {
  static final TranslationManager _instance = TranslationManager._internal();

  /// Returns the singleton instance of [TranslationManager].
  factory TranslationManager() => _instance;

  TranslationManager._internal();

  Map<String, Map<String, String>> _translations = {};
  Locale _currentLocale = const Locale('en', 'US');
  Locale? _fallbackLocale;

  /// List of RTL (Right-to-Left) language codes.
  static const List<String> _rtlLanguages = [
    'ar', // Arabic
    'fa', // Persian/Farsi
    'he', // Hebrew
    'ur', // Urdu
    'yi', // Yiddish
    'ji', // Yiddish (alternative code)
  ];

  /// Returns the current active locale.
  Locale get locale => _currentLocale;

  /// Returns the fallback locale used when translations are missing.
  Locale? get fallbackLocale => _fallbackLocale;

  /// Returns whether the current locale is RTL (Right-to-Left).
  ///
  /// Example:
  /// ```dart
  /// if (TranslationManager().isRTL) {
  ///   // Apply RTL layout
  /// }
  /// ```
  bool get isRTL => _rtlLanguages.contains(_currentLocale.languageCode);

  /// Returns the text direction for the current locale.
  ///
  /// Returns [TextDirection.rtl] for RTL languages (Arabic, Hebrew, etc.)
  /// and [TextDirection.ltr] for all other languages.
  ///
  /// Example:
  /// ```dart
  /// return Directionality(
  ///   textDirection: TranslationManager().textDirection,
  ///   child: child,
  /// );
  /// ```
  TextDirection get textDirection =>
      isRTL ? TextDirection.rtl : TextDirection.ltr;

  /// Resets the translation manager to its initial state.
  ///
  /// This is mainly used for testing purposes.
  void reset() {
    _translations = {};
    _currentLocale = const Locale('en', 'US');
    _fallbackLocale = null;
  }

  /// Initializes the translation manager with a map of translations.
  ///
  /// The [translations] map should be structured as:
  /// ```dart
  /// {
  ///   'en_US': {'hello': 'Hello', 'welcome': 'Welcome'},
  ///   'es_ES': {'hello': 'Hola', 'welcome': 'Bienvenido'},
  /// }
  /// ```
  void addTranslations(Map<String, Map<String, String>> translations) {
    _translations = translations;
  }

  /// Changes the current locale to [locale].
  ///
  /// The locale will only change if translations exist for the given locale.
  void changeLocale(Locale locale) {
    if (_translations.containsKey(_localeKey(locale))) {
      _currentLocale = locale;
    }
  }

  /// Sets the fallback locale to use when a translation is missing.
  ///
  /// If a translation key doesn't exist in the current locale,
  /// the manager will try to find it in the fallback locale.
  void setFallbackLocale(Locale locale) {
    _fallbackLocale = locale;
  }

  /// Translates a [key] to the current locale.
  ///
  /// If [params] are provided, any `@paramName` placeholders in the
  /// translation will be replaced with the corresponding values.
  ///
  /// Example:
  /// ```dart
  /// // Translation: 'welcome': 'Welcome @name'
  /// translate('welcome', params: {'name': 'John'})
  /// // Returns: 'Welcome John'
  /// ```
  ///
  /// If the key is not found, it falls back to the fallback locale,
  /// or returns the key itself if no translation exists.
  String translate(String key, {Map<String, String>? params}) {
    String localeKey = _localeKey(_currentLocale);
    String? translation = _translations[localeKey]?[key];

    if (translation == null && _fallbackLocale != null) {
      String fallbackKey = _localeKey(_fallbackLocale!);
      translation = _translations[fallbackKey]?[key];
    }

    translation ??= key;

    if (params != null) {
      params.forEach((paramKey, paramValue) {
        translation = translation!.replaceAll('@$paramKey', paramValue);
      });
    }

    return translation??'';
  }

  String _localeKey(Locale locale) {
    return locale.countryCode != null
        ? '${locale.languageCode}_${locale.countryCode}'
        : locale.languageCode;
  }
}

/// Provides convenient extension methods on [String] for translations.
///
/// These extensions enable GetX-style translation syntax.
extension TranslationExtension on String {
  /// Translates this string using the current locale.
  ///
  /// Example:
  /// ```dart
  /// 'hello'.tr // Returns: 'Hello'
  /// ```
  String get tr => TranslationManager().translate(this);

  /// Translates this string with parameter replacement.
  ///
  /// Example:
  /// ```dart
  /// 'welcome'.trParams({'name': 'John'}) // Returns: 'Welcome John'
  /// ```
  String trParams([Map<String, String>? params]) {
    return TranslationManager().translate(this, params: params);
  }

  /// Translates this string with plural support.
  ///
  /// Uses this string as the singular form and [pluralKey] as the plural form.
  /// Returns the singular form if [count] equals 1, otherwise returns the plural.
  ///
  /// Example:
  /// ```dart
  /// 'item'.trPlural('items_plural', 1)  // Returns: 'item'
  /// 'item'.trPlural('items_plural', 5)  // Returns: 'items'
  /// ```
  String trPlural(String pluralKey, int count) {
    return count == 1
        ? TranslationManager().translate(this)
        : TranslationManager().translate(pluralKey);
  }
}

/// Base class for organizing translation maps.
///
/// Extend this class to define your app's translations:
/// ```dart
/// class AppTranslations extends Translations {
///   @override
///   Map<String, Map<String, String>> get keys => {
///     'en_US': {'hello': 'Hello'},
///     'es_ES': {'hello': 'Hola'},
///   };
/// }
/// ```
abstract class Translations {
  /// Returns a map of locale codes to translation key-value pairs.
  Map<String, Map<String, String>> get keys;
}