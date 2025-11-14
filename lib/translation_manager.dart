/// Support for doing something awesome.
///
/// More dartdocs go here.
library;

import 'dart:ui';

export 'src/translation_manager_base.dart';

class TranslationManager {
  static final TranslationManager _instance = TranslationManager._internal();
  factory TranslationManager() => _instance;
  TranslationManager._internal();

  Map<String, Map<String, String>> _translations = {};
  Locale _currentLocale = const Locale('en', 'US');
  Locale? _fallbackLocale;

  /// Get current locale
  Locale get locale => _currentLocale;

  /// Get fallback locale
  Locale? get fallbackLocale => _fallbackLocale;

  /// Initialize translations with a map of locales
  void addTranslations(Map<String, Map<String, String>> translations) {
    _translations = translations;
  }

  /// Set current locale
  void changeLocale(Locale locale) {
    if (_translations.containsKey(_localeKey(locale))) {
      _currentLocale = locale;
    }
  }

  /// Set fallback locale
  void setFallbackLocale(Locale locale) {
    _fallbackLocale = locale;
  }

  /// Get translation for a key
  String translate(String key, {Map<String, String>? params}) {
    String localeKey = _localeKey(_currentLocale);
    String? translation = _translations[localeKey]?[key];

    // Try fallback locale if translation not found
    if (translation == null && _fallbackLocale != null) {
      String fallbackKey = _localeKey(_fallbackLocale!);
      translation = _translations[fallbackKey]?[key];
    }

    // Return key if no translation found
    translation ??= key;

    // Replace parameters if provided
    if (params != null) {
      params.forEach((paramKey, paramValue) {
        translation = translation!.replaceAll('@$paramKey', paramValue);
      });
    }

    return translation??'';
  }

  /// Get locale key in format "en_US"
  String _localeKey(Locale locale) {
    return locale.countryCode != null
        ? '${locale.languageCode}_${locale.countryCode}'
        : locale.languageCode;
  }
}

/// Extension on String to enable .tr syntax
extension TranslationExtension on String {
  /// Translate the string key
  String get tr => TranslationManager().translate(this);

  /// Translate with parameters
  String trParams([Map<String, String>? params]) {
    return TranslationManager().translate(this, params: params);
  }

  /// Translate with plural support
  String trPlural(String pluralKey, int count) {
    return count == 1
        ? TranslationManager().translate(this)
        : TranslationManager().translate(pluralKey);
  }
}

/// Base class for translation files
abstract class Translations {
  Map<String, Map<String, String>> get keys;
}


