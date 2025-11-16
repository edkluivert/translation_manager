import 'dart:ui';
import 'package:example/locale_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:translation_manager/translation_manager.dart';



/// Manages locale state and automatically detects device locale.
///
/// This Cubit automatically detects the user's device locale on initialization
/// and matches it against the supported locales. It also handles manual locale
/// changes through the UI.
///
/// Example:
/// ```dart
/// BlocProvider(
///   create: (context) => LocaleCubit(),
///   child: BlocBuilder<LocaleCubit, LocaleState>(
///     builder: (context, state) {
///       return MaterialApp(
///         locale: state.locale,
///         // ...
///       );
///     },
///   ),
/// )
/// ```
class LocaleCubit extends Cubit<LocaleState> {
  /// Creates a [LocaleCubit] and automatically initializes the locale.
  LocaleCubit() : super(const LocaleInitial()) {
    _initializeLocale();
  }

  /// List of locales supported by your application.
  ///
  /// Override this in a subclass to customize supported locales:
  /// ```dart
  /// class MyLocaleCubit extends LocaleCubit {
  ///   @override
  ///   List<Locale> get supportedLocales => [
  ///     const Locale('en', 'US'),
  ///     const Locale('fr', 'FR'),
  ///   ];
  /// }
  /// ```
  List<Locale> get supportedLocales => [
    const Locale('en', 'US'),
    const Locale('es', 'ES'),
    const Locale('fr', 'FR'),
    const Locale('de', 'DE'),
    const Locale('pt', 'BR'),
    const Locale('ar', 'AE'), // Arabic (RTL)
  ];

  Future<void> _initializeLocale() async {
    final deviceLocale = PlatformDispatcher.instance.locale;
    final matchedLocale = _findBestMatchingLocale(deviceLocale);

    TranslationManager().changeLocale(matchedLocale);
    emit(LocaleLoaded(matchedLocale));
  }

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

    // Return default locale
    return supportedLocales.first;
  }

  /// Changes the current locale to [locale].
  ///
  /// The locale will only change if it exists in [supportedLocales].
  ///
  /// Example:
  /// ```dart
  /// context.read<LocaleCubit>().changeLocale(const Locale('es', 'ES'));
  /// ```
  void changeLocale(Locale locale) {
    if (supportedLocales.contains(locale)) {
      TranslationManager().changeLocale(locale);
      emit(LocaleLoaded(locale));
    }
  }

  /// Changes the locale using language and optional country codes.
  ///
  /// Example:
  /// ```dart
  /// context.read<LocaleCubit>().changeLocaleByCode('fr', 'FR');
  /// ```
  void changeLocaleByCode(String languageCode, [String? countryCode]) {
    final locale = countryCode != null
        ? Locale(languageCode, countryCode)
        : Locale(languageCode);
    changeLocale(locale);
  }
}