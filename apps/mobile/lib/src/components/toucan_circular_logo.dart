import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme/app_colors.dart';

/// DiLang Official Single Circular Toucan Mascot & Brand Logo
/// Renders the vector SVG asset with smooth scaling and ambient glow options.
class ToucanCircularLogo extends StatelessWidget {
  final double size;
  final bool showGlow;
  final String assetPath;

  const ToucanCircularLogo({
    super.key,
    this.size = 48,
    this.showGlow = false,
    this.assetPath = 'assets/logos/icon/logo.svg',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: showGlow
            ? [
                BoxShadow(
                  color: AppColors.turquoise500.withValues(alpha: 0.4),
                  blurRadius: size * 0.3,
                  spreadRadius: 2,
                ),
              ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size / 2),
        child: SvgPicture.asset(
          assetPath,
          width: size,
          height: size,
          fit: BoxFit.contain,
          placeholderBuilder: (context) => Container(
            color: AppColors.turquoise500,
            child: const Icon(Icons.flutter_dash, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
