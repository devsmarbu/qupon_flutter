import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../main/presentation/widgets/app_footer.dart';
import '../../../localization/presentation/cubit/locale_cubit.dart';
import '../../../localization/data/services/localization_service.dart';

class AnimalCarePage extends StatelessWidget {
  const AnimalCarePage({super.key});

  @override
  Widget build(BuildContext context) {
    final localeCubit = context.watch<LocaleCubit>();
    final isArabic = localeCubit.state.languageCode == 'ar';

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Divider ──────────────────────────────────────────────────
            Container(height: 1, color: const Color(0xFFE2E8F0)),

            // ── Category Header ───────────────────────────────────────────
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
                      child: Icon(Icons.pets, color: Colors.white, size: 26),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    LocalizationService().getString(
                      'ANIMAL_CARE',
                      AppLocalizations.of(context)!.animalCare,
                    ),
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
            ),

            // ── Placeholder Content ───────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 48),
              child: Center(
                child: Text(
                  LocalizationService().getString(
                    'ANIMAL_CARE_COMING_SOON',
                    AppLocalizations.of(context)!.animalCareComingSoon,
                  ),
                  style: const TextStyle(fontSize: 16, color: Color(0xFF64748B)),
                ),
              ),
            ),

            // ── Footer ────────────────────────────────────────────────────
            // const AppFooter(),
          ],
        ),
      ),
    );
  }
}
