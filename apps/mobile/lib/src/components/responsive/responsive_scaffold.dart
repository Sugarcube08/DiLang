import 'package:flutter/material.dart';
import 'responsive_breakpoints.dart';
import '../glass_components.dart';
import '../toucan_circular_logo.dart';
import '../../theme/app_colors.dart';
import '../../theme/design_tokens.dart';

class ResponsiveNavigationDestination {
  final IconData icon;
  final IconData? activeIcon;
  final String label;
  final String? badgeText;

  const ResponsiveNavigationDestination({
    required this.icon,
    this.activeIcon,
    required this.label,
    this.badgeText,
  });
}

/// Adaptive Scaffold supporting BottomNav (Compact), NavigationRail (Medium),
/// and Persistent Sidebar (Expanded & Large) with RTL awareness.
class ResponsiveScaffold extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final List<ResponsiveNavigationDestination> destinations;
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final Widget? secondaryPane; // Optional multi-panel layout for desktop/tablets

  const ResponsiveScaffold({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.destinations,
    required this.body,
    this.appBar,
    this.floatingActionButton,
    this.secondaryPane,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Widget mainBody = AtmosphereBackground(child: body);

    // 1. Large / Expanded Layout (Persistent Sidebar & Multi-Panel)
    if (context.isExpanded || context.isLarge) {
      return Scaffold(
        appBar: appBar,
        floatingActionButton: floatingActionButton,
        body: Row(
          children: [
            // Sidebar
            Container(
              width: context.isLarge ? 280 : 240,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                border: Border(
                  right: BorderSide(
                    color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.08),
                    width: 1,
                  ),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: DesignTokens.space32),
                  // App Branding Header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: DesignTokens.space20),
                    child: Row(
                      children: [
                        const ToucanCircularLogo(size: 40, showGlow: true),
                        const SizedBox(width: DesignTokens.space12),
                        Expanded(
                          child: Text(
                            'DiLang',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.5,
                              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: DesignTokens.space32),

                  // Navigation Items
                  Expanded(
                    child: ListView.builder(
                      itemCount: destinations.length,
                      padding: const EdgeInsets.symmetric(horizontal: DesignTokens.space12),
                      itemBuilder: (context, index) {
                        final item = destinations[index];
                        final isSelected = index == selectedIndex;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: DesignTokens.space4),
                          child: ListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
                            ),
                            selectedTileColor: AppColors.turquoise500.withValues(alpha: 0.15),
                            leading: Icon(
                              isSelected ? (item.activeIcon ?? item.icon) : item.icon,
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
                            trailing: item.badgeText != null
                                ? Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: AppColors.turquoise500.withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      item.badgeText!,
                                      style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.turquoise400,
                                      ),
                                    ),
                                  )
                                : null,
                            selected: isSelected,
                            onTap: () => onDestinationSelected(index),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Main Content Area
            Expanded(child: mainBody),

            // Optional Multi-Panel Secondary Pane (Desktop Split-View)
            if (secondaryPane != null) ...[
              VerticalDivider(
                width: 1,
                color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.08),
              ),
              SizedBox(
                width: context.isLarge ? 360 : 300,
                child: secondaryPane!,
              ),
            ],
          ],
        ),
      );
    }

    // 2. Medium Layout (Navigation Rail)
    if (context.isMedium) {
      return Scaffold(
        appBar: appBar,
        floatingActionButton: floatingActionButton,
        body: Row(
          children: [
            NavigationRail(
              leading: const Padding(
                padding: EdgeInsets.symmetric(vertical: DesignTokens.space16),
                child: ToucanCircularLogo(size: 36),
              ),
              selectedIndex: selectedIndex,
              onDestinationSelected: onDestinationSelected,
              labelType: NavigationRailLabelType.selected,
              destinations: destinations.map((d) {
                return NavigationRailDestination(
                  icon: Icon(d.icon),
                  selectedIcon: Icon(d.activeIcon ?? d.icon),
                  label: Text(d.label),
                );
              }).toList(),
            ),
            VerticalDivider(
              width: 1,
              color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.08),
            ),
            Expanded(child: mainBody),
          ],
        ),
      );
    }

    // 3. Compact Layout (Bottom Navigation Bar)
    return Scaffold(
      appBar: appBar,
      body: mainBody,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: GlassNavigationBar(
        currentIndex: selectedIndex,
        onTap: onDestinationSelected,
        items: destinations.map((d) {
          return GlassNavItem(
            icon: d.icon,
            label: d.label,
          );
        }).toList(),
      ),
    );
  }
}
