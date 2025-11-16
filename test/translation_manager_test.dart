import 'dart:ui';
import 'package:flutter_test/flutter_test.dart';
import 'package:translation_manager/translation_manager.dart';

class TestTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': {
      'hello': 'Hello',
      'welcome': 'Welcome @name',
      'item': 'item',
      'item_plural': 'items',
      'greeting': 'Hello @name, you have @count messages',
    },
    'es_ES': {
      'hello': 'Hola',
      'welcome': 'Bienvenido @name',
      'item': 'artículo',
      'item_plural': 'artículos',
    },
    'fr': {
      'hello': 'Bonjour',
    },
  };
}

void main() {
  late TranslationManager manager;

  setUp(() {
    manager = TranslationManager();
    manager.reset(); // Reset before each test
    final translations = TestTranslations();
    manager.addTranslations(translations.keys);
  });

  tearDown(() {
    manager.reset(); // Clean up after each test
  });

  group('TranslationManager', () {
    test('should be a singleton', () {
      final instance1 = TranslationManager();
      final instance2 = TranslationManager();
      expect(instance1, same(instance2));
    });

    test('should have default locale of en_US', () {
      expect(manager.locale, equals(const Locale('en', 'US')));
    });

    test('should add translations', () {
      final translations = {'en_US': {'test': 'Test'}};
      manager.addTranslations(translations);
      expect(manager.translate('test'), equals('Test'));
    });

    test('should change locale', () {
      manager.changeLocale(const Locale('es', 'ES'));
      expect(manager.locale, equals(const Locale('es', 'ES')));
    });

    test('should not change to unsupported locale', () {
      manager.changeLocale(const Locale('de', 'DE'));
      expect(manager.locale, equals(const Locale('en', 'US')));
    });

    test('should set fallback locale', () {
      manager.setFallbackLocale(const Locale('en', 'US'));
      expect(manager.fallbackLocale, equals(const Locale('en', 'US')));
    });
  });

  group('Basic Translation', () {
    test('should translate simple key', () {
      expect('hello'.tr, equals('Hello'));
    });

    test('should translate to different locale', () {
      manager.changeLocale(const Locale('es', 'ES'));
      expect('hello'.tr, equals('Hola'));
    });

    test('should return key if translation not found', () {
      expect('nonexistent'.tr, equals('nonexistent'));
    });

    test('should handle locale without country code', () {
      manager.changeLocale(const Locale('fr'));
      expect('hello'.tr, equals('Bonjour'));
    });
  });

  group('Parameter Replacement', () {
    test('should replace single parameter', () {
      expect(
        'welcome'.trParams({'name': 'John'}),
        equals('Welcome John'),
      );
    });

    test('should replace multiple parameters', () {
      expect(
        'greeting'.trParams({'name': 'Alice', 'count': '5'}),
        equals('Hello Alice, you have 5 messages'),
      );
    });

    test('should handle missing parameters', () {
      expect(
        'welcome'.trParams({}),
        equals('Welcome @name'),
      );
    });

    test('should work with different locales', () {
      manager.changeLocale(const Locale('es', 'ES'));
      expect(
        'welcome'.trParams({'name': 'Juan'}),
        equals('Bienvenido Juan'),
      );
    });
  });

  group('Plural Translation', () {
    test('should return singular for count = 1', () {
      expect('item'.trPlural('item_plural', 1), equals('item'));
    });

    test('should return plural for count > 1', () {
      expect('item'.trPlural('item_plural', 5), equals('items'));
    });

    test('should return plural for count = 0', () {
      expect('item'.trPlural('item_plural', 0), equals('items'));
    });

    test('should work with different locales', () {
      manager.changeLocale(const Locale('es', 'ES'));
      expect('item'.trPlural('item_plural', 1), equals('artículo'));
      expect('item'.trPlural('item_plural', 5), equals('artículos'));
    });
  });

  group('Fallback Locale', () {
    test('should use fallback when translation missing', () {
      manager.setFallbackLocale(const Locale('en', 'US'));
      manager.changeLocale(const Locale('es', 'ES'));
      expect('greeting'.tr, equals('Hello @name, you have @count messages'));
    });

    test('should prefer current locale over fallback', () {
      manager.setFallbackLocale(const Locale('en', 'US'));
      manager.changeLocale(const Locale('es', 'ES'));
      expect('hello'.tr, equals('Hola'));
    });

    test('should return key if not in fallback either', () {
      manager.setFallbackLocale(const Locale('en', 'US'));
      manager.changeLocale(const Locale('es', 'ES'));
      expect('missing_key'.tr, equals('missing_key'));
    });
  });

  group('Edge Cases', () {
    test('should handle empty translation value', () {
      manager.addTranslations({
        'en_US': {'empty': ''}
      });
      expect('empty'.tr, equals(''));
    });

    test('should handle special characters in translation', () {
      manager.addTranslations({
        'en_US': {'special': 'Hello! How are you? 🎉'}
      });
      expect('special'.tr, equals('Hello! How are you? 🎉'));
    });

    test('should handle null params', () {
      expect('hello'.trParams(null), equals('Hello'));
    });

    test('should handle multiple @ symbols', () {
      manager.addTranslations({
        'en_US': {'email': 'Email: @email'}
      });
      expect(
        'email'.trParams({'email': 'test@example.com'}),
        equals('Email: test@example.com'),
      );
    });
  });

  group('Translations Abstract Class', () {
    test('should implement keys getter', () {
      final translations = TestTranslations();
      expect(translations.keys, isA<Map<String, Map<String, String>>>());
      expect(translations.keys.containsKey('en_US'), isTrue);
    });
  });
}