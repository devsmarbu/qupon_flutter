import 'package:flutter/material.dart';

/// Common footer widget matching the Qupon brand design.
/// Shows logo, contact details, navigation links, and social links.
class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
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
          const Text(
            'Doha, Qatar, West Bay, Al Reem Tower, Building\n'
            'number 37, 11th floor, office 46, P.O. Box 24355',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              height: 1.65,
            ),
          ),
          const SizedBox(height: 20),

          // ── Phone ──────────────────────────────────────────────────────
          RichText(
            text: const TextSpan(
              children: [
                TextSpan(
                  text: 'Phone: ',
                  style: TextStyle(
                    color: Color(0xFFFF6B35),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextSpan(
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
            text: const TextSpan(
              children: [
                TextSpan(
                  text: 'Email: ',
                  style: TextStyle(
                    color: Color(0xFFFF6B35),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextSpan(
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
                    const Text(
                      'COMPANY',
                      style: TextStyle(
                        color: Color(0xFFFF6B35),
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _FooterLink(label: 'About Us'),
                  ],
                ),
              ),
              // SUPPORT column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'SUPPORT',
                      style: TextStyle(
                        color: Color(0xFFFF6B35),
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _FooterLink(label: 'Terms & Conditions'),
                    const SizedBox(height: 12),
                    _FooterLink(label: 'Refund Policy'),
                    const SizedBox(height: 12),
                    _FooterLink(label: 'Contact Us'),
                    const SizedBox(height: 12),
                    _FooterLink(label: 'Privacy Policy'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 36),

          // ── MY ACCOUNT ─────────────────────────────────────────────────
          const Text(
            'MY ACCOUNT',
            style: TextStyle(
              color: Color(0xFFFF6B35),
              fontSize: 13,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 16),
          _FooterLink(label: 'My Orders'),
          const SizedBox(height: 12),
          _FooterLink(label: 'My Wishlist'),
          const SizedBox(height: 36),

          // ── Follow Us ──────────────────────────────────────────────────
          Row(
            children: [
              const Text(
                'Follow Us',
                style: TextStyle(
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
            text: const TextSpan(
              children: [
                TextSpan(
                  text: 'Powered by: ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                  ),
                ),
                TextSpan(
                  text: 'Paradigm Marketing And Advertising',
                  style: TextStyle(
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
