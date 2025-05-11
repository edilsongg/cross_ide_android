import 'package:flutter/material.dart';

class CustomSliderThumbRect extends SliderComponentShape {
  final double thumbRadius;
  final double thumbHeight;
  final int min;
  final int max;

  const CustomSliderThumbRect({
    required this.thumbRadius,
    required this.thumbHeight,
    required this.min,
    required this.max,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter? labelPainter,
    required RenderBox parentBox,
    required Size sizeWithOverflow,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
  }) {
    final canvas = context.canvas;

    // Desenha o retângulo arredondado
    final rRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: center,
        width: thumbHeight * 1.2,
        height: thumbHeight * 0.6,
      ),
      Radius.circular(thumbRadius * 0.4),
    );
    final paint = Paint()
      ..color = sliderTheme.activeTrackColor!
      ..style = PaintingStyle.fill;
    canvas.drawRRect(rRect, paint);

    // Prepara e desenha o texto com o valor
    final textSpan = TextSpan(
      text: _formatValue(value),
      style: TextStyle(
        fontSize: thumbHeight * 0.3,
        fontWeight: FontWeight.w700,
        color: sliderTheme.thumbColor,
        height: 1,
      ),
    );
    final tp = TextPainter(
      text: textSpan,
      textAlign: TextAlign.center,
      textDirection: textDirection,
      textScaleFactor: textScaleFactor,
    )..layout();
    final textOffset = Offset(
      center.dx - tp.width / 2,
      center.dy - tp.height / 2,
    );
    tp.paint(canvas, textOffset);
  }

  String _formatValue(double value) {
    final v = (min + (max - min) * value).round();
    return v.toString();
  }
}
