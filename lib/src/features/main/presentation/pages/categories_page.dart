import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../localization/presentation/cubit/locale_cubit.dart';
import '../../../localization/data/services/localization_service.dart';
import '../../../home/data/models/home_category.dart';
import '../../../home/data/repositories/home_repository.dart';
import '../../../offers/presentation/pages/category_offers_page.dart';
import '../../../main/presentation/pages/main_page.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../../l10n/app_localizations.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key, this.onNavigateHome});

  final VoidCallback? onNavigateHome;

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  List<HomeCategory>? _categories;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final categories = await context.read<HomeRepository>().getCategories();
      if (!mounted) return;
      setState(() {
        _categories = categories;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString().replaceAll('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final localeCubit = context.watch<LocaleCubit>();
    final isArabic = localeCubit.state.languageCode == 'ar';

    return SafeArea(
      child: _buildBody(context, isArabic),
    );
  }

  Widget _buildBody(BuildContext context, bool isArabic) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.wifi_off_outlined, size: 48, color: Color(0xFFCBD5E1)),
              const SizedBox(height: 16),
              Text(
                LocalizationService().getString(
                  'CATEGORIES_LOAD_ERROR',
                  isArabic
                      ? 'فشل تحميل الفئات. يرجى التحقق من اتصالك بالإنترنت.'
                      : 'Failed to load categories. Please check your network connection.',
                ),
                textAlign: TextAlign.center,
                style: const TextStyle(color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _fetchCategories,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(LocalizationService().getString('RETRY', AppLocalizations.of(context)!.retryLabel)),
              ),
            ],
          ),
        ),
      );
    }

    final categories = _categories ?? [];
    return _buildContent(context, categories, isArabic);
  }

  Widget _buildContent(BuildContext context, List<HomeCategory> categories, bool isArabic) {
    final l10n = AppLocalizations.of(context)!;
    final totalOffers = categories.fold<int>(0, (sum, cat) => sum + cat.offersCount);
    final totalCategories = categories.length;

    final subtitleText = LocalizationService().getString(
      'CATEGORIES_SUBTITLE',
      isArabic
          ? '$totalOffers عرضاً عبر $totalCategories فئات مميزة'
          : '$totalOffers offers across $totalCategories premium categories',
    );

    return RefreshIndicator(
      color: AppColors.primary,
      backgroundColor: Colors.white,
      onRefresh: _fetchCategories,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header Navigation Back to Home ──────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: InkWell(
                onTap: widget.onNavigateHome,
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isArabic ? Icons.arrow_forward : Icons.arrow_back,
                        size: 18,
                        color: AppColors.textDarkBlue,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        l10n.drawerHome,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDarkBlue,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ── Page Titles ────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    LocalizationService().getString('NAV_CATEGORIES', l10n.navCategories),
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF0F172A),
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitleText,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF64748B),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // ── Categories Vertical List ───────────────────────────────────────
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: categories.length,
              padding: const EdgeInsets.only(bottom: 32),
              itemBuilder: (context, index) {
                final cat = categories[index];
                final name = isArabic ? cat.nameAr : cat.name;

                final offersCountText = isArabic
                    ? '${cat.offersCount} ${cat.offersCount == 1 ? 'عرض' : 'عروض'}'
                    : '${cat.offersCount} ${cat.offersCount == 1 ? 'OFFER' : 'OFFERS'}';

                final hasValidIcon = cat.iconUrl.startsWith('http');
                final hasValidImage = cat.imageUrl.startsWith('http');
                final imageUrlToUse = hasValidIcon ? cat.iconUrl : (hasValidImage ? cat.imageUrl : '');

                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFFE2E8F0),
                      width: 1.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: InkWell(
                    onTap: () async {
                      final viewCart = await Navigator.of(context).push<bool>(
                        MaterialPageRoute(
                          builder: (context) => CategoryOffersPage(category: cat),
                        ),
                      );
                      if (viewCart == true && context.mounted) {
                        final mainPageState = context.findAncestorStateOfType<MainPageState>();
                        if (mainPageState != null) {
                          mainPageState.setSelectedIndex(3); // Cart is index 3
                        }
                      }
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          // Category Circle Icon/Image
                          Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFFF1F5F9),
                              border: Border.all(
                                color: const Color(0xFFE2E8F0),
                                width: 1,
                              ),
                            ),
                            child: ClipOval(
                              child: imageUrlToUse.isNotEmpty
                                  ? Image.network(
                                      imageUrlToUse,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => const Icon(
                                        Icons.category_outlined,
                                        color: Color(0xFF94A3B8),
                                        size: 28,
                                      ),
                                    )
                                  : const Icon(
                                      Icons.category_outlined,
                                      color: Color(0xFF94A3B8),
                                      size: 28,
                                    ),
                            ),
                          ),
                          const SizedBox(width: 16),

                          // Title and Offers count
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0F172A),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  offersCountText.toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.primary,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Arrow Forward Indicator
                          Icon(
                            isArabic ? Icons.arrow_back : Icons.arrow_forward,
                            color: const Color(0xFF64748B),
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
