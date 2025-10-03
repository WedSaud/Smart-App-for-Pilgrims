// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Navigating through cities`
  String get first_onboarding_title1 {
    return Intl.message(
      'Navigating through cities',
      name: 'first_onboarding_title1',
      desc: '',
      args: [],
    );
  }

  /// `Select App Language`
  String get selectAppLanguage {
    return Intl.message(
      'Select App Language',
      name: 'selectAppLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Choose your preferred language from the options below`
  String get choosePreferredLanguage {
    return Intl.message(
      'Choose your preferred language from the options below',
      name: 'choosePreferredLanguage',
      desc: '',
      args: [],
    );
  }

  /// `English`
  String get english {
    return Intl.message(
      'English',
      name: 'english',
      desc: '',
      args: [],
    );
  }

  /// `Urdu`
  String get urdu {
    return Intl.message(
      'Urdu',
      name: 'urdu',
      desc: '',
      args: [],
    );
  }

  /// `Continue`
  String get continueButton {
    return Intl.message(
      'Continue',
      name: 'continueButton',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get registerScreenTitle {
    return Intl.message(
      'Login',
      name: 'registerScreenTitle',
      desc: '',
      args: [],
    );
  }

  /// `Email Address`
  String get label {
    return Intl.message(
      'Email Address',
      name: 'label',
      desc: '',
      args: [],
    );
  }

  /// `Enter Your Email Address`
  String get registerScreenSubTitle {
    return Intl.message(
      'Enter Your Email Address',
      name: 'registerScreenSubTitle',
      desc: '',
      args: [],
    );
  }

  /// `Continue With Google`
  String get continueWithGoogleLabel {
    return Intl.message(
      'Continue With Google',
      name: 'continueWithGoogleLabel',
      desc: '',
      args: [],
    );
  }

  /// `or`
  String get orLable {
    return Intl.message(
      'or',
      name: 'orLable',
      desc: '',
      args: [],
    );
  }

  /// `Enter`
  String get optScreenTitle1 {
    return Intl.message(
      'Enter',
      name: 'optScreenTitle1',
      desc: '',
      args: [],
    );
  }

  /// `Verfication Code`
  String get optScreenTitle2 {
    return Intl.message(
      'Verfication Code',
      name: 'optScreenTitle2',
      desc: '',
      args: [],
    );
  }

  /// `Enter the verfication code we just send to your email`
  String get optScreenSubTitle {
    return Intl.message(
      'Enter the verfication code we just send to your email',
      name: 'optScreenSubTitle',
      desc: '',
      args: [],
    );
  }

  /// `Didn't receive the code?`
  String get optScreenData {
    return Intl.message(
      'Didn\'t receive the code?',
      name: 'optScreenData',
      desc: '',
      args: [],
    );
  }

  /// `Resend`
  String get optScreenResendButton {
    return Intl.message(
      'Resend',
      name: 'optScreenResendButton',
      desc: '',
      args: [],
    );
  }

  /// `Verify`
  String get optScreenVerficationButton {
    return Intl.message(
      'Verify',
      name: 'optScreenVerficationButton',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
      Locale.fromSubtags(languageCode: 'ur'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
