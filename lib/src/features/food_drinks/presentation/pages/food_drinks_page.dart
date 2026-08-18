import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../localization/presentation/cubit/locale_cubit.dart';
import '../../../localization/data/services/localization_service.dart';

class FoodDrinksPage extends StatelessWidget {
  const FoodDrinksPage({super.key});

  @override
  Widget build(BuildContext context) {
    final localeCubit = context.watch<LocaleCubit>();
    final isArabic = localeCubit.state.languageCode == 'ar';
    final title = LocalizationService().getString(
      'HOME_BEST_IN_FOOD',
      AppLocalizations.of(context)!.foodDrinks,
    );

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(height: 1, color: const Color(0xFFE2E8F0)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(Icons.restaurant_menu, color: Colors.white, size: 26),
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                LocalizationService().getString(
                  'FOOD_DRINKS_COMING_SOON',
                  AppLocalizations.of(context)!.foodDrinksComingSoon,
                ),
                style: const TextStyle(fontSize: 16, color: Color(0xFF64748B)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
