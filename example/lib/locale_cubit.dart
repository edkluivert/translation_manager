
// Cubit
import 'dart:ui';

import 'package:example/locale_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:translation_manager/translation_manager.dart';

class LocaleCubit extends Cubit<LocaleState> {
  LocaleCubit() : super(const LocaleInitial()) {
    _initializeLocale();
  }

  /// List of supported locales in your app
  final List<Locale> supportedLocales = [
    const Locale('en', 'US'),
    const Locale('es', 'ES'),
    const Locale('fr', 'FR'),
    const Locale('de', 'DE'),
    const Locale('pt', 'BR'),
  ];

  /// Initialize locale by detecting user's device locale
  Future<void> _initializeLocale() async {
    // Get device locale
    final deviceLocale = PlatformDispatcher.instance.locale;

    // Find best matching locale
    final matchedLocale = _findBestMatchingLocale(deviceLocale);

    // Update translation manager
    TranslationManager().changeLocale(matchedLocale);

    // Emit new state
    emit(LocaleLoaded(matchedLocale));
  }

  /// Find the best matching locale from supported locales
  Locale _findBestMatchingLocale(Locale deviceLocale) {
    // Try exact match (language + country)
    for (var locale in supportedLocales) {
      if (locale.languageCode == deviceLocale.languageCode &&
          locale.countryCode == deviceLocale.countryCode) {
        return locale;
      }
    }

    // Try language-only match
    for (var locale in supportedLocales) {
      if (locale.languageCode == deviceLocale.languageCode) {
        return locale;
      }
    }

    // Return default locale (first in list)
    return supportedLocales.first;
  }

  /// Manually change locale
  void changeLocale(Locale locale) {
    if (supportedLocales.contains(locale)) {
      TranslationManager().changeLocale(locale);
      emit(LocaleLoaded(locale));
    }
  }

  /// Change locale by language code
  void changeLocaleByCode(String languageCode, [String? countryCode]) {
    final locale = countryCode != null
        ? Locale(languageCode, countryCode)
        : Locale(languageCode);
    changeLocale(locale);
  }
}
