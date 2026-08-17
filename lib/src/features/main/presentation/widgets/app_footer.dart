import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../localization/data/services/localization_service.dart';
import '../../../localization/presentation/cubit/locale_cubit.dart';

/// Common footer widget matching the Qupon brand design.
/// Shows logo, contact details, navigation links, and social links.
class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    // Watch LocaleCubit to rebuild when language changes
    context.watch<LocaleCubit>();
    final loc = LocalizationService();

    return Container(
      color: const Color(0xFF0D0D0D),
      padding: const EdgeInsets.fromLTRB(24, 36, 24, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Logo ───────────────────────────────────────────────────────
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Qupon',
                style: TextStyle(
                  color: Color(0xFFFF6B35),
                  fontSize: 52,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -2,
                  height: 1,
                ),
              ),
              Transform.translate(
                offset: const Offset(5, -4),
                child: const Text(
                  'كيوبون',
                  style: TextStyle(
                    color: Color(0xFFFF6B35),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),

          // ── Address ────────────────────────────────────────────────────
          Text(
            loc.getString(
              'FOOTER_ADDRESS',
              'Doha, Qatar, West Bay, Al Reem Tower, Building\n'
              'number 37, 11th floor, office 46, P.O. Box 24355',
            ),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              height: 1.65,
            ),
          ),
          const SizedBox(height: 20),

          // ── Phone ──────────────────────────────────────────────────────
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: loc.getString('FOOTER_PHONE', 'Phone: '),
                  style: const TextStyle(
                    color: Color(0xFFFF6B35),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const TextSpan(
                  text: '+974 3122 4113',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // ── Email ──────────────────────────────────────────────────────
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: loc.getString('FOOTER_EMAIL', 'Email: '),
                  style: const TextStyle(
                    color: Color(0xFFFF6B35),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const TextSpan(
                  text: 'info@qupon.qa',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 36),

          // ── COMPANY + SUPPORT (two columns) ────────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // COMPANY column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      loc.getString('FOOTER_COMPANY', 'COMPANY'),
                      style: const TextStyle(
                        color: Color(0xFFFF6B35),
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _FooterLink(label: loc.getString('FOOTER_ABOUT_US', 'About Us')),
                  ],
                ),
              ),
              // SUPPORT column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      loc.getString('FOOTER_SUPPORT', 'SUPPORT'),
                      style: const TextStyle(
                        color: Color(0xFFFF6B35),
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _FooterLink(label: loc.getString('FOOTER_TERMS', 'Terms & Conditions')),
                    const SizedBox(height: 12),
                    _FooterLink(label: loc.getString('FOOTER_REFUND_POLICY', 'Refund Policy')),
                    const SizedBox(height: 12),
                    _FooterLink(label: loc.getString('FOOTER_CONTACT_US', 'Contact Us')),
                    const SizedBox(height: 12),
                    _FooterLink(label: loc.getString('FOOTER_PRIVACY_POLICY', 'Privacy Policy')),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 36),

          // ── MY ACCOUNT ─────────────────────────────────────────────────
          Text(
            loc.getString('FOOTER_MY_ACCOUNT', 'MY ACCOUNT'),
            style: const TextStyle(
              color: Color(0xFFFF6B35),
              fontSize: 13,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 16),
          _FooterLink(label: loc.getString('FOOTER_MY_ORDERS', 'My Orders')),
          const SizedBox(height: 12),
          _FooterLink(label: loc.getString('FOOTER_MY_WISHLIST', 'My Wishlist')),
          const SizedBox(height: 36),

          // ── Follow Us ──────────────────────────────────────────────────
          Row(
            children: [
              Text(
                loc.getString('FOOTER_FOLLOW_US', 'Follow Us'),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 14),
              // Instagram-style circular button
              GestureDetector(
                onTap: () {},
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF6B35),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),

          // ── Powered by ─────────────────────────────────────────────────
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: loc.getString('FOOTER_POWERED_BY_PREFIX', 'Powered by: '),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                  ),
                ),
                TextSpan(
                  text: loc.getString('FOOTER_POWERED_BY_BRAND', 'Paradigm Marketing And Advertising'),
                  style: const TextStyle(
                    color: Color(0xFFFF6B35),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// A tappable footer link item.
class _FooterLink extends StatelessWidget {
  const _FooterLink({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          height: 1.3,
        ),
      ),
    );
  }
}
