import 'package:flutter/material.dart';

import '../../../main/presentation/widgets/app_footer.dart';

class AnimalCarePage extends StatelessWidget {
  const AnimalCarePage({super.key});

  @override
  Widget build(BuildContext context) {
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
                  const Text(
                    'Animal Care',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
            ),

            // ── Placeholder Content ───────────────────────────────────────
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 48),
              child: Center(
                child: Text(
                  'Animal Care offers coming soon...',
                  style: TextStyle(fontSize: 16, color: Color(0xFF64748B)),
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
