import 'package:flutter/material.dart';
import 'budgie_circular_logo.dart';
import 'glass_components.dart';
import '../theme/app_colors.dart';

/// DiLang Responsive & Adaptive Layout Wrapper
class AdaptiveLayout extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final List<AdaptiveDestination> destinations;
  final Widget body;

  const AdaptiveLayout({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.destinations,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Widget wrappedBody = AtmosphereBackground(child: body);

    // Desktop Layout (> 1024px)
    if (width >= 1024) {
      return Scaffold(
        body: Row(
          children: [
            Container(
              width: 260,
              color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
              child: Column(
                children: [
                  const SizedBox(height: 36),
                  // DiLang Header Logo & Branding (No version suffix)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const BudgieCircularLogo(size: 42, showGlow: true),
                      const SizedBox(width: 14),
                      Text(
                        'DiLang',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 36),
                  Expanded(
                    child: ListView.builder(
                      itemCount: destinations.length,
                      itemBuilder: (context, index) {
                        final item = destinations[index];
                        final isSelected = index == selectedIndex;
                        return ListTile(
                          leading: Icon(
                            item.icon,
                            color: isSelected
                                ? AppColors.turquoise500
                                : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                          ),
                          title: Text(
                            item.label,
                            style: TextStyle(
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              color: isSelected
                                  ? AppColors.turquoise500
                                  : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                            ),
                          ),
                          selected: isSelected,
                          onTap: () => onDestinationSelected(index),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const VerticalDivider(width: 1),
            Expanded(child: wrappedBody),
          ],
        ),
      );
    }

    // Tablet Layout (600px - 1024px)
    if (width >= 600) {
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              leading: const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: BudgieCircularLogo(size: 36),
              ),
              selectedIndex: selectedIndex,
              onDestinationSelected: onDestinationSelected,
              labelType: NavigationRailLabelType.selected,
              destinations: destinations.map((d) {
                return NavigationRailDestination(
                  icon: Icon(d.icon),
                  label: Text(d.label),
                );
              }).toList(),
            ),
            const VerticalDivider(width: 1),
            Expanded(child: wrappedBody),
          ],
        ),
      );
    }

    // Mobile Phone Layout (< 600px)
    return Scaffold(
      body: wrappedBody,
    );
  }
}

class AdaptiveDestination {
  final IconData icon;
  final String label;

  const AdaptiveDestination({required this.icon, required this.label});
}
