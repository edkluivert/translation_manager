import 'package:example/app_translation.dart';
import 'package:example/locale_cubit.dart';
import 'package:example/locale_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:translation_manager/translation_manager.dart';


void main() {
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
            title: 'Translation Manager Demo',
            locale: state.locale,
            supportedLocales: context.read<LocaleCubit>().supportedLocales,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            // RTL Support: Automatically switch text direction based on locale
            builder: (context, child) {
              return Directionality(
                textDirection: TranslationManager().textDirection,
                child: child!,
              );
            },
            theme: ThemeData(
              primarySwatch: Colors.blue,
              useMaterial3: true,
            ),
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
          // RTL indicator badge
          if (TranslationManager().isRTL)
            Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'RTL',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () => _showLanguageDialog(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome message
            Text(
              'welcome'.trParams({'name': 'User'}),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),

            // Greeting with multiple parameters
            Text(
              'greeting'.trParams({
                'name': 'John',
                'count': '5',
              }),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 20),

            // Plural examples
            const Text(
              'Plural Examples:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text('You have 1 ${'items'.trPlural('items_plural', 1)}'),
            Text('You have 5 ${'items'.trPlural('items_plural', 5)}'),
            const SizedBox(height: 20),

            // Locale information card
            BlocBuilder<LocaleCubit, LocaleState>(
              builder: (context, state) {
                return Card(
                  color: TranslationManager().isRTL
                      ? Colors.orange.shade50
                      : Colors.blue.shade50,
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              TranslationManager().isRTL
                                  ? Icons.format_textdirection_r_to_l
                                  : Icons.format_textdirection_l_to_r,
                              color: TranslationManager().isRTL
                                  ? Colors.orange
                                  : Colors.blue,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Locale Information',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const Divider(height: 20),
                        _buildInfoRow(
                          'Current locale',
                          '${state.locale.languageCode}_${state.locale.countryCode}',
                        ),
                        _buildInfoRow(
                          'Language',
                          _getLanguageName(state.locale),
                        ),
                        _buildInfoRow(
                          'Text direction',
                          TranslationManager().isRTL ? 'RTL (Right-to-Left)' : 'LTR (Left-to-Right)',
                        ),
                        _buildInfoRow(
                          'Is RTL',
                          TranslationManager().isRTL ? '✓ Yes' : '✗ No',
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),

            // RTL Demo section
            if (TranslationManager().isRTL) ...[
              const Text(
                'RTL Layout Demo:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 12),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.check_circle, color: Colors.green),
                  title: Text('hello'.tr),
                  subtitle: Text('welcome'.trParams({'name': 'أحمد'})),
                  trailing: const Icon(Icons.arrow_forward),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Notice: Text, icons, and layout automatically flip for RTL languages!',
                style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
              ),
            ],
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showLanguageDialog(context),
        icon: const Icon(Icons.language),
        label: const Text('Change Language'),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
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
          content: SizedBox(
            width: double.maxFinite,
            child: ListView(
              shrinkWrap: true,
              children: cubit.supportedLocales.map((locale) {
                final isSelected = cubit.state.locale == locale;
                final isRTL = const ['ar', 'he', 'fa', 'ur'].contains(locale.languageCode);

                return ListTile(
                  leading: Icon(
                    isRTL
                        ? Icons.format_textdirection_r_to_l
                        : Icons.format_textdirection_l_to_r,
                    color: isRTL ? Colors.orange : Colors.blue,
                  ),
                  title: Text(_getLanguageName(locale)),
                  subtitle: Text(
                    '${locale.languageCode}_${locale.countryCode}${isRTL ? ' (RTL)' : ''}',
                    style: TextStyle(
                      fontSize: 12,
                      color: isRTL ? Colors.orange : Colors.grey,
                    ),
                  ),
                  trailing: isSelected
                      ? const Icon(Icons.check_circle, color: Colors.green)
                      : null,
                  selected: isSelected,
                  onTap: () {
                    cubit.changeLocale(locale);
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ),
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
      case 'ar':
        return 'العربية (Arabic)';
      default:
        return locale.languageCode;
    }
  }
}