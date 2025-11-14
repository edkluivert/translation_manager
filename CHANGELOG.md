# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2024-11-14

### Added
- Initial release of Translation Manager
- `TranslationManager` singleton for managing translations
- Automatic device locale detection
- `LocaleCubit` for locale state management with flutter_bloc
- String extensions (`.tr`, `.trParams()`, `.trPlural()`) for easy translation
- Fallback locale support for missing translations
- Parameter replacement with `@paramName` syntax
- Plural translation support
- Smart locale matching (exact match → language match → fallback)
- `Translations` abstract class for organizing translation files
- Complete documentation and examples

### Features
- Zero-dependency core (only requires `dart:ui`)
- GetX-inspired API for familiar syntax
- Type-safe translation keys
- Singleton pattern for global access
- Bloc integration for reactive locale changes
- Support for locale persistence (with optional shared_preferences)

## [Unreleased]

### Planned
- RTL (Right-to-Left) language support
- Nested translation keys (e.g., `'home.title'.tr`)
- Gender-based translations
- Advanced plural rules (zero, one, two, few, many, other)
- JSON file loading support
- Translation key validation tools
- Hot reload support for translations in development
- Translation coverage analysis

---

