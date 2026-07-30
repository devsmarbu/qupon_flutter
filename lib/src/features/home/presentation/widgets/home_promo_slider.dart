import 'dart:async';
import 'package:flutter/material.dart';

class HomePromoSlider extends StatefulWidget {
  const HomePromoSlider({super.key});

  @override
  State<HomePromoSlider> createState() => _HomePromoSliderState();
}

class _HomePromoSliderState extends State<HomePromoSlider> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  final List<_SliderItem> _banners = const [
    _SliderItem(
      assetPath: 'assets/banner_cats.png',
      title: 'Teeth Scaling and Polishing',
      quponPrice: '449 QR',
      amountSaved: '11 QR',
    ),
    _SliderItem(
      assetPath: 'assets/banner_brunch.jpg',
      title: 'Weekend Brunch Special',
      quponPrice: '199 QR',
      amountSaved: '50 QR',
    ),
    _SliderItem(
      assetPath: 'assets/banner_other.jpg',
      title: 'Premium Spa Experience',
      quponPrice: '299 QR',
      amountSaved: '100 QR',
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Auto-scroll slider every 4 seconds
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_pageController.hasClients) {
        final nextPage = (_currentPage + 1) % _banners.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  void _goToPrevious() {
    if (_pageController.hasClients) {
      final prevPage = (_currentPage - 1 + _banners.length) % _banners.length;
      _pageController.animateToPage(
        prevPage,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void _goToNext() {
    if (_pageController.hasClients) {
      final nextPage = (_currentPage + 1) % _banners.length;
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
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
    return Container(
      height: 200,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
        child: Stack(
          children: [
            // ── Slider Pages ─────────────────────────────────────────────────
            PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemCount: _banners.length,
              itemBuilder: (context, index) {
                return Image.asset(
                  _banners[index].assetPath,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: const Color(0xFFF1F5F9),
                      child: const Center(
                        child: Icon(
                          Icons.image_not_supported_outlined,
                          size: 40,
                          color: Color(0xFF94A3B8),
                        ),
                      ),
                    );
                  },
                );
              },
            ),

            // ── Dark gradient overlay (bottom) ───────────────────────────────
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 130,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.75),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),

            // ── Price info overlay (bottom left) ─────────────────────────────
            Positioned(
              bottom: 14,
              left: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'QUPON PRICE',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                    ),
                  ),
                  Text(
                    _banners[_currentPage].quponPrice,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Row(
                    children: [
                      const Text(
                        'AMOUNT SAVED',
                        style: TextStyle(
                          color: Color(0xFFFF6B35),
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _banners[_currentPage].amountSaved,
                        style: const TextStyle(
                          color: Color(0xFFFF6B35),
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _banners[_currentPage].title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            // ── Left Arrow ───────────────────────────────────────────────────
            Positioned(
              left: 8,
              top: 0,
              bottom: 0,
              child: Center(
                child: GestureDetector(
                  onTap: _goToPrevious,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.35),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.chevron_left,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ),
              ),
            ),

            // ── Right Arrow ──────────────────────────────────────────────────
            Positioned(
              right: 8,
              top: 0,
              bottom: 0,
              child: Center(
                child: GestureDetector(
                  onTap: _goToNext,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.35),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.chevron_right,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SliderItem {
  final String assetPath;
  final String title;
  final String quponPrice;
  final String amountSaved;

  const _SliderItem({
    required this.assetPath,
    required this.title,
    required this.quponPrice,
    required this.amountSaved,
  });
}
