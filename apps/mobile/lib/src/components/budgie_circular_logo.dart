import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// DiLang Official Single Circular Budgie Mascot & Brand Logo
/// Rendered with smooth vector geometry for crisp scaling on all screen DPIs.
class BudgieCircularLogo extends StatelessWidget {
  final double size;
  final bool showGlow;

  const BudgieCircularLogo({
    super.key,
    this.size = 48,
    this.showGlow = false,
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
      child: CustomPaint(
        painter: _BudgieCircularPainter(),
      ),
    );
  }
}

class _BudgieCircularPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final radius = size.width / 2;

    // 1. Circular Outer Background (Soft Sky Gradient Container)
    final bgPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFFE0F2FE), Color(0xFFBAE6FD)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawCircle(Offset(cx, cy), radius, bgPaint);

    // Border Rim (Turquoise)
    final rimPaint = Paint()
      ..color = AppColors.turquoise500
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.05;
    canvas.drawCircle(Offset(cx, cy), radius - (size.width * 0.025), rimPaint);

    // 2. Crown Crest (Gold Feathers)
    final crownPaint = Paint()
      ..color = AppColors.budgieCrown
      ..style = PaintingStyle.fill;
    final crownPath = Path()
      ..moveTo(cx - radius * 0.25, cy - radius * 0.6)
      ..quadraticBezierTo(cx, cy - radius * 0.95, cx + radius * 0.25, cy - radius * 0.6)
      ..close();
    canvas.drawPath(crownPath, crownPaint);

    // 3. Budgie Body (Turquoise)
    final bodyPaint = Paint()
      ..color = AppColors.budgieBody
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(cx, cy + radius * 0.08), radius * 0.68, bodyPaint);

    // 4. Belly Feather Arc (Soft Cream/White)
    final bellyPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.9)
      ..style = PaintingStyle.fill;
    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy + radius * 0.2), radius: radius * 0.52),
      0.3,
      2.54,
      true,
      bellyPaint,
    );

    // 5. Blush Cheeks (Coral Pink)
    final cheekPaint = Paint()
      ..color = AppColors.budgieCheek.withValues(alpha: 0.45)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(cx - radius * 0.38, cy + radius * 0.1), radius * 0.12, cheekPaint);
    canvas.drawCircle(Offset(cx + radius * 0.38, cy + radius * 0.1), radius * 0.12, cheekPaint);

    // 6. Beak (Amber Orange)
    final beakPaint = Paint()
      ..color = AppColors.budgieBeak
      ..style = PaintingStyle.fill;
    final beakPath = Path()
      ..moveTo(cx - radius * 0.12, cy + radius * 0.02)
      ..quadraticBezierTo(cx, cy + radius * 0.26, cx + radius * 0.12, cy + radius * 0.02)
      ..close();
    canvas.drawPath(beakPath, beakPaint);

    // 7. Expressive Sparkle Eyes
    final eyeWhite = Paint()..color = Colors.white;
    final eyePupil = Paint()..color = const Color(0xFF0F172A);

    final leftEyeCenter = Offset(cx - radius * 0.24, cy - radius * 0.15);
    final rightEyeCenter = Offset(cx + radius * 0.24, cy - radius * 0.15);
    final eyeRadius = radius * 0.16;

    canvas.drawCircle(leftEyeCenter, eyeRadius, eyeWhite);
    canvas.drawCircle(rightEyeCenter, eyeRadius, eyeWhite);

    canvas.drawCircle(leftEyeCenter + Offset(radius * 0.02, 0), eyeRadius * 0.55, eyePupil);
    canvas.drawCircle(rightEyeCenter - Offset(radius * 0.02, 0), eyeRadius * 0.55, eyePupil);

    // Eye Catchlight Sparkles
    canvas.drawCircle(leftEyeCenter - Offset(radius * 0.04, radius * 0.04), eyeRadius * 0.2, eyeWhite);
    canvas.drawCircle(rightEyeCenter - Offset(radius * 0.04, radius * 0.04), eyeRadius * 0.2, eyeWhite);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
