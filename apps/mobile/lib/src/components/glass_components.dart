import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_gradients.dart';
import '../theme/app_radius.dart';

/// Layered Background Atmosphere Widget
/// Renders ambient color aura blobs so optical glass panels refract soft light!
class AtmosphereBackground extends StatelessWidget {
  final Widget child;

  const AtmosphereBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      children: [
        // Base Atmosphere Gradient
        Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
            gradient: LinearGradient(
              colors: isDark
                  ? const [Color(0xFF070B12), Color(0xFF0F172A)]
                  : const [Color(0xFFF8FAFC), Color(0xFFF1F5F9)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),

        // Ambient Top-Left Turquoise Aura Blob
        Positioned(
          top: -80,
          left: -80,
          child: Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.turquoise500.withValues(alpha: isDark ? 0.12 : 0.08),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
              child: const SizedBox.expand(),
            ),
          ),
        ),

        // Ambient Bottom-Right Mint Aura Blob
        Positioned(
          bottom: -100,
          right: -60,
          child: Container(
            width: 320,
            height: 320,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.mint500.withValues(alpha: isDark ? 0.10 : 0.06),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 90, sigmaY: 90),
              child: const SizedBox.expand(),
            ),
          ),
        ),

        // Child Content Screen
        child,
      ],
    );
  }
}

/// Optical Glass Container Component with Physical Light Reflection & Refraction
class GlassContainer extends StatelessWidget {
  final Widget child;
  final double blur;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final Color? borderColor;
  final Gradient? gradient;
  final double? width;
  final double? height;

  const GlassContainer({
    super.key,
    required this.child,
    this.blur = 22.0,
    this.padding,
    this.margin,
    this.borderRadius,
    this.borderColor,
    this.gradient,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final radius = borderRadius ?? AppRadius.borderLarge;

    // Optical Glass Specular Highlight Gradient (Top-Left Light Reflection)
    final glassShaderGradient = LinearGradient(
      colors: isDark
          ? const [
              Color.fromRGBO(255, 255, 255, 0.15),
              Color.fromRGBO(255, 255, 255, 0.03),
            ]
          : const [
              Color.fromRGBO(255, 255, 255, 0.85),
              Color.fromRGBO(255, 255, 255, 0.45),
            ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: [
          BoxShadow(
            color: isDark
                ? const Color.fromRGBO(0, 0, 0, 0.35)
                : const Color.fromRGBO(0, 0, 0, 0.06),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            padding: padding ?? const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: gradient ?? glassShaderGradient,
              borderRadius: radius,
              border: Border.all(
                color: borderColor ??
                    (isDark
                        ? const Color.fromRGBO(255, 255, 255, 0.15)
                        : const Color.fromRGBO(255, 255, 255, 0.90)),
                width: 1.2,
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// Floating Optical Glass Card Component with Dynamic Light Response
class GlassCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final Color? accentColor;

  const GlassCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.margin,
    this.borderRadius,
    this.accentColor,
  });

  @override
  State<GlassCard> createState() => _GlassCardState();
}

class _GlassCardState extends State<GlassCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    Widget content = AnimatedScale(
      scale: _isHovered ? 1.01 : 1.0,
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
      child: GlassContainer(
        padding: widget.padding,
        margin: widget.margin,
        borderRadius: widget.borderRadius,
        borderColor: _isHovered
            ? AppColors.turquoise500.withValues(alpha: 0.6)
            : widget.accentColor?.withValues(alpha: 0.35),
        child: widget.child,
      ),
    );

    if (widget.onTap != null) {
      return MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: widget.borderRadius ?? AppRadius.borderLarge,
            child: content,
          ),
        ),
      );
    }
    return content;
  }
}

/// Interactive Optical Glass Selection Chip
class GlassChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final IconData? icon;
  final VoidCallback onTap;

  const GlassChip({
    super.key,
    required this.label,
    required this.isSelected,
    this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.borderPill,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: AppRadius.borderPill,
            gradient: isSelected ? AppGradients.primary : null,
            color: isSelected
                ? null
                : (isDark
                    ? const Color.fromRGBO(30, 41, 59, 0.5)
                    : const Color.fromRGBO(255, 255, 255, 0.6)),
            border: Border.all(
              color: isSelected
                  ? Colors.transparent
                  : (isDark
                      ? const Color.fromRGBO(255, 255, 255, 0.15)
                      : const Color.fromRGBO(255, 255, 255, 0.8)),
              width: 1.2,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.turquoise500.withValues(alpha: 0.35),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 16,
                  color: isSelected
                      ? Colors.white
                      : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                ),
                const SizedBox(width: 6),
              ],
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                  color: isSelected
                      ? Colors.white
                      : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Floating Optical Glass Bottom Navigation Bar
class GlassNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<GlassNavItem> items;

  const GlassNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: GlassContainer(
        blur: 26,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        borderRadius: AppRadius.borderPill,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(items.length, (index) {
            final item = items[index];
            final isSelected = index == currentIndex;

            return Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => onTap(index),
                borderRadius: AppRadius.borderPill,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: AppRadius.borderPill,
                    color: isSelected
                        ? AppColors.turquoise500.withValues(alpha: 0.18)
                        : Colors.transparent,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        item.icon,
                        size: 20,
                        color: isSelected
                            ? AppColors.turquoise500
                            : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                      ),
                      if (isSelected) ...[
                        const SizedBox(width: 8),
                        Text(
                          item.label,
                          style: const TextStyle(
                            color: AppColors.turquoise500,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class GlassNavItem {
  final IconData icon;
  final String label;

  const GlassNavItem({required this.icon, required this.label});
}
