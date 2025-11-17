# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.2] - 2025-11-17

### Added
- Initial release of Translation Manager
- `TranslationManager` singleton for managing translations
- Automatic device locale detection
- String extensions (`.tr`, `.trParams()`, `.trPlural()`) for easy translation
- Fallback locale support for missing translations
- Parameter replacement with `@paramName` syntax
- Plural translation support
- Smart locale matching (exact match → language match → fallback)
- `Translations` abstract class for organizing translation files
- **RTL (Right-to-Left) language support**
    - Automatic detection for Arabic, Hebrew, Persian, Urdu, and Yiddish
    - `isRTL` property to check if current locale is RTL
    - `textDirection` getter for easy layout integration
- Complete documentation and examples
- Comprehensive test suite with 50+ test cases

### Features
- Zero dependencies (only requires `dart:ui`)
- GetX-inspired API for familiar syntax
- Type-safe translation keys
- Singleton pattern for global access
- Framework agnostic - works with any state management solution
- Support for locale persistence (with optional shared_preferences)

## [Unreleased]

### Planned
- Nested translation keys (e.g., `'home.title'.tr`)
- Gender-based translations
- Advanced plural rules (zero, one, two, few, many, other)
- JSON file loading support
- Translation key validation tools
- Hot reload support for translations in development
- Translation coverage analysis

---

For migration guides and breaking changes, see [MIGRATION.md](MIGRATION.md)