library;

import 'dart:ui';

/// Singleton manager for handling app translations
class TranslationManager {
  static final TranslationManager _instance = TranslationManager._internal();
  factory TranslationManager() => _instance;
  TranslationManager._internal();

  Map<String, Map<String, String>> _translations = {};
  Locale _currentLocale = const Locale('en', 'US');
  Locale? _fallbackLocale;

  Locale get locale => _currentLocale;
  Locale? get fallbackLocale => _fallbackLocale;

  void addTranslations(Map<String, Map<String, String>> translations) {
    _translations = translations;
  }

  void changeLocale(Locale locale) {
    if (_translations.containsKey(_localeKey(locale))) {
      _currentLocale = locale;
    }
  }

  void setFallbackLocale(Locale locale) {
    _fallbackLocale = locale;
  }

  String translate(String key, {Map<String, String>? params}) {
    String localeKey = _localeKey(_currentLocale);
    String? translation = _translations[localeKey]?[key];

    // Try fallback if not found in current locale
    if (translation == null && _fallbackLocale != null) {
      String fallbackKey = _localeKey(_fallbackLocale!);
      translation = _translations[fallbackKey]?[key];
    }

    // Use the key itself if no translation exists
    translation ??= key;

    // Replace @param placeholders with actual values
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

/// String extensions for easy translation syntax
extension TranslationExtension on String {
  String get tr => TranslationManager().translate(this);

  String trParams([Map<String, String>? params]) {
    return TranslationManager().translate(this, params: params);
  }

  String trPlural(String pluralKey, int count) {
    return count == 1
        ? TranslationManager().translate(this)
        : TranslationManager().translate(pluralKey);
  }
}

/// Base class for defining translation maps
abstract class Translations {
  Map<String, Map<String, String>> get keys;
}


