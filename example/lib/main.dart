import 'package:example/locale_cubit.dart';
import 'package:example/locale_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:translation_manager/translation_manager.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys =>
      {
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


void main() {
  final translations = AppTranslations();
  TranslationManager().addTranslations(translations.keys);
  TranslationManager().setFallbackLocale(const Locale('en', 'US'));

  ///   // Basic translation
  print('hello'.tr); // Output: Hello

  ///   // Translation with parameters
  print('welcome'.trParams({'name': 'John'})); // Output: Welcome John

  ///   // Plural translation
  print('items'.trPlural('items_plural', 1)); // Output: item
  print('items'.trPlural('items_plural', 5)); // Output: items

  // Change locale
  TranslationManager().changeLocale(const Locale('es', 'ES'));
  print('hello'.tr); // Output: Hola

  // Multiple parameters
  print('greeting'.trParams({
    'name': 'John',
    'count': '5'}));


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LocaleCubit(),
      child: BlocBuilder<LocaleCubit, LocaleState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            ),
            locale: state.locale,
            supportedLocales: context
                .read<LocaleCubit>()
                .supportedLocales,
            localizationsDelegates: [
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

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('hello'.tr),
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () => _showLanguageDialog(context),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'welcome'.trParams({'name': 'User'}),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            Text(
              'greeting'.trParams({
                'name': 'John',
                'count': '5',
              }),
            ),
            const SizedBox(height: 20),
            BlocBuilder<LocaleCubit, LocaleState>(
              builder: (context, state) {
                return Text(
                  'Current locale: ${state.locale.languageCode}_${state.locale.countryCode}',
                  style: Theme.of(context).textTheme.bodySmall,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    final cubit = context.read<LocaleCubit>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Choose Language'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: cubit.supportedLocales.map((locale) {
              return ListTile(
                title: Text(_getLanguageName(locale)),
                onTap: () {
                  cubit.changeLocale(locale);
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  String _getLanguageName(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return 'English';
      case 'es':
        return 'Español';
      case 'fr':
        return 'Français';
      case 'de':
        return 'Deutsch';
      case 'pt':
        return 'Português';
      default:
        return locale.languageCode;
    }
  }
}
