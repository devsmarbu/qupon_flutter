import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../localization/presentation/cubit/locale_cubit.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({
    super.key,
    this.selectedIndex = 0,
    this.onItemSelected,
  });

  /// The currently selected menu index.
  final int selectedIndex;

  /// Callback invoked when the user taps a menu item, passing its index.
  final ValueChanged<int>? onItemSelected;

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final localeCubit = context.watch<LocaleCubit>();
    final isArabic = localeCubit.state.languageCode == 'ar';

    // Menu items — labels only, no icons, matching the screenshot
    final List<Map<String, dynamic>> menuItems = [
      {'label': l10n.drawerHome, 'index': 0},
      {'label': isArabic ? 'الأطعمة والمشروبات' : 'Food & Drinks', 'index': 1},
      {'label': isArabic ? 'رعاية الحيوانات' : 'Animal Care', 'index': 2},
      {'label': isArabic ? 'الصفقات السابقة' : 'Past Deals', 'index': 3},
      {'label': l10n.drawerCart, 'index': 4},
      {'label': isArabic ? 'الحساب' : 'Account', 'index': 5},
    ];

    return Drawer(
      backgroundColor: Colors.white,
      elevation: 16,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header row: "Menu" + X close ──────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Menu',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0F172A),
                      letterSpacing: 0.2,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(
                      Icons.close,
                      color: Color(0xFF0F172A),
                      size: 22,
                    ),
                  ),
                ],
              ),
            ),

            // ── Search bar ─────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                height: 46,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: const Color(0xFFCBD5E1),
                    width: 1.2,
                  ),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 14),
                    const Icon(
                      Icons.search,
                      color: Color(0xFF94A3B8),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF334155),
                        ),
                        decoration: InputDecoration(
                          hintText: isArabic
                              ? 'ابحث عن كوبونات، بائعين...'
                              : 'Search for coupons, vendors...',
                          hintStyle: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF94A3B8),
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 8),

            // ── Menu items ─────────────────────────────────────────────
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: menuItems.length,
                itemBuilder: (context, index) {
                  final item = menuItems[index];
                  final itemIndex = item['index'] as int;
                  final isSelected = widget.selectedIndex == itemIndex;

                  return InkWell(
                    onTap: () {
                      // Close the drawer first
                      Navigator.of(context).pop();
                      // Notify parent of the selected index
                      widget.onItemSelected?.call(itemIndex);
                    },
                    splashColor: AppColors.primary.withValues(alpha: 0.08),
                    highlightColor: AppColors.primary.withValues(alpha: 0.04),
                    child: Container(
                      decoration: isSelected
                          ? const BoxDecoration(
                              border: Border(
                                left: BorderSide(
                                  color: AppColors.primary,
                                  width: 3,
                                ),
                              ),
                            )
                          : null,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 15,
                        ),
                        child: Text(
                          item['label'] as String,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: isSelected
                                ? AppColors.primary
                                : const Color(0xFF4E7080),
                            letterSpacing: 0.1,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
