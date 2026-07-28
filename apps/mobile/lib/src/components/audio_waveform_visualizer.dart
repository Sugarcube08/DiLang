import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AudioWaveformVisualizer extends StatefulWidget {
  final bool isListening;
  final bool isSpeaking;
  final VoidCallback? onMicTap;

  const AudioWaveformVisualizer({
    super.key,
    required this.isListening,
    required this.isSpeaking,
    this.onMicTap,
  });

  @override
  State<AudioWaveformVisualizer> createState() => _AudioWaveformVisualizerState();
}

class _AudioWaveformVisualizerState extends State<AudioWaveformVisualizer>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeColor = widget.isListening
        ? AppColors.coral500
        : (widget.isSpeaking ? AppColors.turquoise500 : AppColors.turquoise400);

    return AnimatedBuilder(
      animation: _animController,
      builder: (context, child) {
        final val = _animController.value;

        return Stack(
          alignment: Alignment.center,
          children: [
            // Outer Pulsing Glow Aura Ring 1
            if (widget.isListening || widget.isSpeaking)
              Container(
                width: 170 + (val * 35),
                height: 170 + (val * 35),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: activeColor.withValues(alpha: 0.08 * (1.0 - val)),
                ),
              ),

            // Outer Pulsing Glow Aura Ring 2
            if (widget.isListening || widget.isSpeaking)
              Container(
                width: 130 + (val * 20),
                height: 130 + (val * 20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: activeColor.withValues(alpha: 0.15 * (1.0 - val)),
                ),
              ),

            // Live Animated Spectrum Frequency Bars Orbit
            SizedBox(
              width: 140,
              height: 140,
              child: CustomPaint(
                painter: _WaveformSpectrumPainter(
                  progress: val,
                  color: activeColor,
                  isListening: widget.isListening,
                  isSpeaking: widget.isSpeaking,
                ),
              ),
            ),

            // Center Interactive Mic / Voice Orb
            GestureDetector(
              onTap: widget.onMicTap,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: widget.isListening ? 92 : 84,
                height: widget.isListening ? 92 : 84,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: widget.isListening
                        ? [AppColors.coral500, const Color(0xFFE11D48)]
                        : [AppColors.turquoise400, AppColors.turquoise600],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: activeColor.withValues(alpha: 0.45),
                      blurRadius: 24,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: Icon(
                  widget.isListening
                      ? Icons.mic
                      : (widget.isSpeaking ? Icons.volume_up : Icons.mic_none),
                  color: Colors.white,
                  size: 38,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _WaveformSpectrumPainter extends CustomPainter {
  final double progress;
  final Color color;
  final bool isListening;
  final bool isSpeaking;

  _WaveformSpectrumPainter({
    required this.progress,
    required this.color,
    required this.isListening,
    required this.isSpeaking,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 6;

    final paint = Paint()
      ..color = color.withValues(alpha: 0.85)
      ..strokeWidth = 3.2
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    const totalBars = 32;
    for (int i = 0; i < totalBars; i++) {
      final angle = (i * 2 * math.pi) / totalBars;
      final phase = (i / totalBars) * 2 * math.pi;

      double barHeight = 8.0;
      if (isListening || isSpeaking) {
        barHeight = 8.0 + math.sin(progress * 2 * math.pi + phase).abs() * 22.0;
      }

      final startOffset = Offset(
        center.dx + (radius - barHeight) * math.cos(angle),
        center.dy + (radius - barHeight) * math.sin(angle),
      );

      final endOffset = Offset(
        center.dx + (radius + barHeight / 2) * math.cos(angle),
        center.dy + (radius + barHeight / 2) * math.sin(angle),
      );

      canvas.drawLine(startOffset, endOffset, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _WaveformSpectrumPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.isListening != isListening ||
        oldDelegate.isSpeaking != isSpeaking;
  }
}
