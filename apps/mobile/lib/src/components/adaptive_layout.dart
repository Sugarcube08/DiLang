import 'package:flutter/material.dart';
import 'responsive/responsive.dart';

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
    return ResponsiveScaffold(
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      destinations: destinations.map((d) {
        return ResponsiveNavigationDestination(
          icon: d.icon,
          label: d.label,
        );
      }).toList(),
      body: body,
    );
  }
}

class AdaptiveDestination {
  final IconData icon;
  final String label;

  const AdaptiveDestination({required this.icon, required this.label});
}
