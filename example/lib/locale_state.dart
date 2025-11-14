import 'dart:ui';

import 'package:equatable/equatable.dart';

abstract class LocaleState extends Equatable {
  final Locale locale;

  const LocaleState(this.locale);

  @override
  List<Object> get props => [locale];
}

class LocaleInitial extends LocaleState {
  const LocaleInitial() : super(const Locale('en', 'US'));
}

class LocaleLoaded extends LocaleState {
  const LocaleLoaded(super.locale);
}
