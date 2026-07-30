import 'dart:async';
import 'package:flutter/material.dart';
import '../../data/models/home_banner.dart';

/// Promotional banner slider driven by real API data.
class HomePromoSliderApi extends StatefulWidget {
  final List<HomeBanner> banners;

  const HomePromoSliderApi({super.key, required this.banners});

  @override
  State<HomePromoSliderApi> createState() => _HomePromoSliderApiState();
}

class _HomePromoSliderApiState extends State<HomePromoSliderApi> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (widget.banners.length > 1) {
      _timer = Timer.periodic(const Duration(seconds: 4), (_) {
        if (_pageController.hasClients && widget.banners.isNotEmpty) {
          final next = (_currentPage + 1) % widget.banners.length;
          _pageController.animateToPage(
            next,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOutCubic,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    if (widget.banners.isEmpty) return const SizedBox.shrink();
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 200,
          margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (i) => setState(() => _currentPage = i),
              itemCount: widget.banners.length,
              itemBuilder: (context, index) {
                final b = widget.banners[index];
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      b.imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      loadingBuilder: (ctx, child, progress) {
                        if (progress == null) return child;
                        return Container(
                          color: const Color(0xFFF1F5F9),
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFFFF6B35),
                              strokeWidth: 2,
                            ),
                          ),
                        );
                      },
                      errorBuilder: (ctx, _, __) => Container(
                        color: const Color(0xFFF1F5F9),
                        child: const Center(
                          child: Icon(
                            Icons.image_not_supported_outlined,
                            size: 40,
                            color: Color(0xFF94A3B8),
                          ),
                        ),
                      ),
                    ),
                    // Gradient overlay
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.8),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Title and subtitle overlay
                    Positioned(
                      bottom: 16,
                      left: 16,
                      right: 16,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            isArabic && b.titleAr.isNotEmpty ? b.titleAr : b.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.2,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                isArabic && b.subtitleAr.isNotEmpty ? b.subtitleAr : b.subtitle,
                                style: const TextStyle(
                                  color: Color(0xFFFF6B35),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w900,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
        // Indicator Dots
        if (widget.banners.length > 1)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.banners.length,
              (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: _currentPage == index ? 14 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: _currentPage == index ? const Color(0xFFFF6B35) : const Color(0xFFFFE0D3),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
