import 'package:flutter/material.dart';

/// A horizontally scrollable row of category bubbles shown on the home page.
class HomeCategorySection extends StatelessWidget {
  const HomeCategorySection({super.key});

  static const _categories = [
    _Category(label: 'Electronics', icon: Icons.devices_other_outlined),
    _Category(label: 'Fashion', icon: Icons.checkroom_outlined),
    _Category(label: 'Food & Drinks', icon: Icons.restaurant_outlined),
    _Category(label: 'Health', icon: Icons.health_and_safety_outlined),
    _Category(label: 'Beauty', icon: Icons.spa_outlined),
    _Category(label: 'Travel', icon: Icons.flight_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final cat = _categories[index];
          return _CategoryBubble(category: cat);
        },
      ),
    );
  }
}

class _CategoryBubble extends StatelessWidget {
  const _CategoryBubble({required this.category});

  final _Category category;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.only(right: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Circular avatar
            Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFF1F5F9),
                border: Border.all(
                  color: const Color(0xFFE2E8F0),
                  width: 1.5,
                ),
              ),
              child: Center(
                child: Icon(
                  category.icon,
                  size: 30,
                  color: const Color(0xFF475569),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              category.label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF0F172A),
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _Category {
  final String label;
  final IconData icon;

  const _Category({required this.label, required this.icon});
}
