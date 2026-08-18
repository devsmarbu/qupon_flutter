import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/preferences/pref_store.dart';
import '../../data/services/localization_service.dart';

class LocaleCubit extends Cubit<Locale> {
  LocaleCubit() : super(_getInitialLocale()) {
    LocalizationService().setLanguage(state.languageCode);
  }

  static Locale _getInitialLocale() {
    final code = PrefStore().loadString(AppStrings.keyLanguage);
    if (code == 'ar') {
      return const Locale('ar');
    }
    return const Locale('en');
  }

  void toggleLocale() {
    if (state.languageCode == 'en') {
      LocalizationService().setLanguage('ar');
      PrefStore().saveString(AppStrings.keyLanguage, 'ar');
      emit(const Locale('ar'));
    } else {
      LocalizationService().setLanguage('en');
      PrefStore().saveString(AppStrings.keyLanguage, 'en');
      emit(const Locale('en'));
    }
  }

  void setLocale(Locale locale) {
    LocalizationService().setLanguage(locale.languageCode);
    PrefStore().saveString(AppStrings.keyLanguage, locale.languageCode);
    emit(locale);
  }
}
