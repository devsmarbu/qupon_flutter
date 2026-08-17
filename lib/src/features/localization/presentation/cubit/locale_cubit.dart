import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/services/localization_service.dart';

class LocaleCubit extends Cubit<Locale> {
  LocaleCubit() : super(const Locale('en')) {
    LocalizationService().setLanguage(state.languageCode);
  }

  void toggleLocale() {
    if (state.languageCode == 'en') {
      LocalizationService().setLanguage('ar');
      emit(const Locale('ar'));
    } else {
      LocalizationService().setLanguage('en');
      emit(const Locale('en'));
    }
  }

  void setLocale(Locale locale) {
    LocalizationService().setLanguage(locale.languageCode);
    emit(locale);
  }
}
