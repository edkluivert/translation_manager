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
    'de_DE': {
      'hello': 'Hallo',
      'welcome': 'Willkommen @name',
      'items': 'Artikel',
      'items_plural': 'Artikel',
      'greeting': 'Hallo, @name! Du hast @count Nachrichten.',
    },
    'pt_BR': {
      'hello': 'Olá',
      'welcome': 'Bem-vindo @name',
      'items': 'item',
      'items_plural': 'itens',
      'greeting': 'Olá, @name! Você tem @count mensagens.',
    },
    'ar_AE': {
      'hello': 'مرحبا',
      'welcome': 'مرحبا @name',
      'items': 'عنصر',
      'items_plural': 'عناصر',
      'greeting': 'مرحبا، @name! لديك @count رسائل.',
    },
  };
}