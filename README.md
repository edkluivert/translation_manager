# Flutter Translation Manager

A lightweight, GetX-inspired translation library for Flutter that provides simple internationalization with automatic locale detection and Bloc integration.

## Features

✨ **Simple API** - Clean, intuitive syntax inspired by GetX  
🌍 **Locale Detection** - Automatically detects user's device language  
🔄 **Dynamic Switching** - Change languages on the fly  
💾 **Persistent Storage** - Optional locale preference saving  
🎯 **Type Safe** - Full Dart type safety  
🔌 **Bloc Integration** - Works seamlessly with flutter_bloc

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  translation_manager: ^1.0.0
  flutter_bloc: ^8.1.3
  flutter_localizations:
    sdk: flutter
```

Then run:

```bash
flutter pub get
```

## Quick Start

### 1. Define Your Translations

Create a translations file (e.g., `lib/translations/app_translations.dart`):

```dart
import 'package:translation_manager/translation_manager.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': {
      'hello': 'Hello',
      'welcome': 'Welcome @name',
      'items': 'item',
      'items_plural': 'items',
      'greeting': 'Hello, @name! You have @count messages.',
    },
    'es_ES': {
      'hello': 'Hola',
      'welcome': 'Bienvenido @name',
      'items': 'artículo',
      'items_plural': 'artículos',
      'greeting': 'Hola, @name! Tienes @count mensajes.',
    },
    'fr_FR': {
      'hello': 'Bonjour',
      'welcome': 'Bienvenue @name',
      'items': 'article',
      'items_plural': 'articles',
      'greeting': 'Bonjour, @name! Vous avez @count messages.',
    },
  };
}
```

### 2. Initialize in main.dart

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:translation_manager/translation_manager.dart';
import 'translations/app_translations.dart';

void main() {
  // Initialize translations
  final translations = AppTranslations();
  TranslationManager().addTranslations(translations.keys);
  TranslationManager().setFallbackLocale(const Locale('en', 'US'));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LocaleCubit(),
      child: BlocBuilder<LocaleCubit, LocaleState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'My App',
            locale: state.locale,
            supportedLocales: context.read<LocaleCubit>().supportedLocales,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: const HomePage(),
          );
        },
      ),
    );
  }
}
```

### 3. Use Translations in Your UI

```dart
import 'package:flutter/material.dart';
import 'package:translation_manager/translation_manager.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('hello'.tr), // Simple translation
      ),
      body: Column(
        children: [
          // Translation with parameters
          Text('welcome'.trParams({'name': 'John'})),

          // Plural translation
          Text('You have 5 ${'items'.trPlural('items_plural', 5)}'),

          // Multiple parameters
          Text('greeting'.trParams({
            'name': 'Alice',
            'count': '3',
          })),
        ],
      ),
    );
  }
}
```

## Usage

### Basic Translation

```dart
'hello'.tr  // Returns: "Hello" (or translated text)
```

### Translation with Parameters

Use `@paramName` in your translation strings:

```dart
// In translations:
'welcome': 'Welcome @name'

// In code:
'welcome'.trParams({'name': 'John'})  // Returns: "Welcome John"
```

### Plural Translation

```dart
// Define both singular and plural keys in your translations:
'item': 'item',
'item_plural': 'items',

// Usage:
'item'.trPlural('item_plural', 1)  // Returns: "item"
'item'.trPlural('item_plural', 5)  // Returns: "items"

// Real-world example:
int count = 3;
Text('You have $count ${'item'.trPlural('item_plural', count)}')
// Output: "You have 3 items"
```

### Change Language

```dart
// Using the Cubit (recommended)
context.read<LocaleCubit>().changeLocale(const Locale('es', 'ES'));

// Or by language code
context.read<LocaleCubit>().changeLocaleByCode('fr', 'FR');

// Direct access to TranslationManager
TranslationManager().changeLocale(const Locale('de', 'DE'));
```

### Get Current Locale

```dart
// From Cubit state
BlocBuilder<LocaleCubit, LocaleState>(
builder: (context, state) {
return Text('Current: ${state.locale.languageCode}');
},
)

// From TranslationManager
final currentLocale = TranslationManager().locale;
```

## Configuration

### Define Supported Locales

In your `LocaleCubit`, you can customize the supported locales:

```dart
import 'package:translation_manager/translation_manager.dart';

class MyLocaleCubit extends LocaleCubit {
  @override
  List<Locale> get supportedLocales => [
    const Locale('en', 'US'),
    const Locale('es', 'ES'),
    const Locale('fr', 'FR'),
    const Locale('de', 'DE'),
    const Locale('pt', 'BR'),
    const Locale('zh', 'CN'),
  ];
}
```

Then use your custom cubit:

```dart
BlocProvider(
create: (context) => MyLocaleCubit(),
child: // ...
)
```

### Fallback Locale

Set a fallback locale for missing translations:

```dart
TranslationManager().setFallbackLocale(const Locale('en', 'US'));
```

If a translation key is missing in the current locale, it will use the fallback locale.

## Advanced Features

### Language Picker Dialog

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:translation_manager/translation_manager.dart';

void showLanguageDialog(BuildContext context) {
  final cubit = context.read<LocaleCubit>();

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Choose Language'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: cubit.supportedLocales.map((locale) {
          return ListTile(
            title: Text(_getLanguageName(locale)),
            trailing: cubit.state.locale == locale
                ? const Icon(Icons.check, color: Colors.green)
                : null,
            onTap: () {
              cubit.changeLocale(locale);
              Navigator.pop(context);
            },
          );
        }).toList(),
      ),
    ),
  );
}

String _getLanguageName(Locale locale) {
  const names = {
    'en': 'English',
    'es': 'Español',
    'fr': 'Français',
    'de': 'Deutsch',
    'pt': 'Português',
    'zh': '中文',
  };
  return names[locale.languageCode] ?? locale.languageCode;
}
```

### Persistent Locale Storage

To remember user's language preference between app sessions, add `shared_preferences`:

```yaml
dependencies:
  shared_preferences: ^2.2.0
```

Create a custom cubit with persistence:

```dart
import 'dart:ui';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translation_manager/translation_manager.dart';

class PersistentLocaleCubit extends LocaleCubit {
  final SharedPreferences _prefs;
  static const String _localeKey = 'app_locale';

  PersistentLocaleCubit(this._prefs) : super() {
    _loadSavedLocale();
  }

  Future<void> _loadSavedLocale() async {
    final savedLocaleCode = _prefs.getString(_localeKey);

    if (savedLocaleCode != null) {
      final parts = savedLocaleCode.split('_');
      final locale = Locale(parts[0], parts.length > 1 ? parts[1] : null);

      if (supportedLocales.contains(locale)) {
        changeLocale(locale);
      }
    }
  }

  @override
  void changeLocale(Locale locale) {
    if (supportedLocales.contains(locale)) {
      final localeCode = locale.countryCode != null
          ? '${locale.languageCode}_${locale.countryCode}'
          : locale.languageCode;
      _prefs.setString(_localeKey, localeCode);
      super.changeLocale(locale);
    }
  }
}
```

Update `main.dart`:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  
  final translations = AppTranslations();
  TranslationManager().addTranslations(translations.keys);
  TranslationManager().setFallbackLocale(const Locale('en', 'US'));

  runApp(MyApp(prefs: prefs));
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;
  
  const MyApp({super.key, required this.prefs});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PersistentLocaleCubit(prefs),
      child: BlocBuilder<LocaleCubit, LocaleState>(
        builder: (context, state) {
          return MaterialApp(
            locale: state.locale,
            supportedLocales: context.read<LocaleCubit>().supportedLocales,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: const HomePage(),
          );
        },
      ),
    );
  }
}
```

### Organize Large Translation Files

For apps with many translations, split them into multiple classes:

```dart
// lib/translations/home_translations.dart
class HomeTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': {
      'home.title': 'Home',
      'home.welcome': 'Welcome back!',
    },
    'es_ES': {
      'home.title': 'Inicio',
      'home.welcome': '¡Bienvenido de nuevo!',
    },
  };
}

// lib/translations/settings_translations.dart
class SettingsTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': {
      'settings.title': 'Settings',
      'settings.language': 'Language',
    },
    'es_ES': {
      'settings.title': 'Configuración',
      'settings.language': 'Idioma',
    },
  };
}

// lib/translations/app_translations.dart
class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys {
    final home = HomeTranslations().keys;
    final settings = SettingsTranslations().keys;
    
    // Merge all translations
    final merged = <String, Map<String, String>>{};
    
    for (var locale in home.keys) {
      merged[locale] = {
        ...?home[locale],
        ...?settings[locale],
      };
    }
    
    return merged;
  }
}
```

## API Reference

### TranslationManager

| Method | Description |
|--------|-------------|
| `addTranslations(Map)` | Initialize translations with locale map |
| `changeLocale(Locale)` | Change current locale |
| `setFallbackLocale(Locale)` | Set fallback for missing translations |
| `translate(String, {params})` | Get translation for key with optional params |
| `locale` | Get current locale |
| `fallbackLocale` | Get fallback locale |

### String Extensions

| Extension | Description | Example |
|-----------|-------------|---------|
| `.tr` | Basic translation | `'hello'.tr` |
| `.trParams(Map)` | Translation with parameters | `'welcome'.trParams({'name': 'John'})` |
| `.trPlural(String, int)` | Plural translation | `'item'.trPlural('item_plural', 5)` |

### LocaleCubit

| Property/Method | Description |
|--------|-------------|
| `state.locale` | Current locale |
| `supportedLocales` | List of supported locales |
| `changeLocale(Locale)` | Change app locale |
| `changeLocaleByCode(String, [String?])` | Change locale by language code |

### LocaleState

| State | Description |
|-------|-------------|
| `LocaleInitial` | Initial state before locale detection |
| `LocaleLoaded(Locale)` | Locale has been loaded and set |

## Best Practices

### 1. Key Naming Convention

Use hierarchical, dot-separated keys for better organization:

```dart
'home.title': 'Home'
'home.welcome': 'Welcome'
'settings.title': 'Settings'
'settings.language': 'Language'
'profile.edit': 'Edit Profile'
```

### 2. Parameter Naming

Use clear, descriptive parameter names:

```dart
// Good
'greeting': 'Hello, @userName! You have @messageCount new messages.'

// Avoid
'greeting': 'Hello, @a! You have @b new messages.'
```

### 3. Always Define Plurals

Define both singular and plural forms:

```dart
'message': 'message',
'message_plural': 'messages',
'notification': 'notification',
'notification_plural': 'notifications',
```

### 4. Set Fallback Locale

Always configure a fallback locale in your `main.dart`:

```dart
TranslationManager().setFallbackLocale(const Locale('en', 'US'));
```

### 5. Locale Code Format

Use the correct format: `languageCode_COUNTRYCODE`

```dart
// Correct
'en_US', 'es_ES', 'fr_FR', 'pt_BR'

// Incorrect
'en-US', 'en', 'EN_US'
```

## Troubleshooting

### Translation not showing

**Problem:** Translations return the key instead of translated text

**Solutions:**
- Verify the key exists in your translations map
- Check locale code format (must be `en_US`, not `en-US`)
- Ensure `TranslationManager().addTranslations()` was called in `main()`
- Set a fallback locale: `TranslationManager().setFallbackLocale()`

### Locale not changing

**Problem:** Language doesn't change when calling `changeLocale()`

**Solutions:**
- Verify the locale exists in `supportedLocales` list
- Ensure `BlocBuilder<LocaleCubit, LocaleState>` wraps your `MaterialApp`
- Check that `locale` property is bound to `state.locale`
- Verify `localizationsDelegates` are added to `MaterialApp`

### Parameters not replacing

**Problem:** Parameters like `@name` appear literally in translated text

**Solutions:**
- Verify parameter uses `@` prefix: `@name` not `{name}` or `$name`
- Check parameter key in `trParams()` matches the translation: `'name'` for `@name`
- Ensure parameter values are strings: `{'count': '5'}` not `{'count': 5}`

### MaterialLocalizations Error

**Problem:** Error: "No MaterialLocalizations found"

**Solution:** Add localization delegates to `MaterialApp`:

```dart
MaterialApp(
  localizationsDelegates: const [
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  // ...
)
```

## Examples

Check out the `/example` folder for complete working examples:

- **Basic Setup** - Simple app with translations
- **Language Picker** - App with language selection dialog
- **Persistent Storage** - App that remembers language preference
- **Large App** - Example with organized translation files

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

## License

MIT License - see the [LICENSE](LICENSE) file for details.

## Support

- 📫 Report issues on [GitHub Issues](https://edkluivert/yourusername/translation_manager/issues)
- 💬 Discuss on [GitHub Discussions](https://edkluivert/yourusername/translation_manager/discussions)
- ⭐ Star the repo if you find it useful!

---

Made with ❤️ for the Flutter community