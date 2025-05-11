import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AnimatedSlider extends StatefulWidget {
  AnimatedSlider({
    super.key,
    this.value = 0.0,
    this.min = 0.0,
    this.max = 1.0,
    this.divisions,
    this.barColor = Colors.white,
    this.rightFillColor = const Color.fromARGB(255, 86, 21, 198),
    this.leftFillColor = Colors.white12,
    this.height = 50.0,
    this.barWidth = 6.0,
    this.onChange,
    this.labelStyle = const TextStyle(
      fontSize: 16.0,
      color: Colors.white,
      fontWeight: FontWeight.w800,
    ),
    BorderRadius? cornerRadius,
  })  : assert(max > min),
        assert(value >= min && value <= max),
        _cornerRadius = cornerRadius ?? BorderRadius.circular(8.0);

  /// Valor real entre [min] e [max].
  final double value;
  final double min;
  final double max;
  final int? divisions; // número de steps (opcional)

  final Color barColor;
  final Color rightFillColor;
  final Color leftFillColor;
  final double height;
  final double barWidth;
  final BorderRadius _cornerRadius;
  final TextStyle labelStyle;
  final void Function(double value)? onChange;

  @override
  State<AnimatedSlider> createState() => _AnimatedSliderState();
}

const Duration _animationDuration = Duration(milliseconds: 100);
const double _barHorizontalMargins = 6.0;
const double _labelsHorizontalMargins = 12.0;

class _AnimatedSliderState extends State<AnimatedSlider> {
  late final double _dragBarWidth =
      widget.barWidth + (_barHorizontalMargins * 2);
  late final Size _dragRegion = Size(_dragBarWidth + 20, widget.height);

  // Internamente guardamos o progresso normalizado (0.0–1.0)
  late final ValueNotifier<double> _progressNotifier = ValueNotifier<double>(
    (widget.value - widget.min) / (widget.max - widget.min),
  );
  late final ValueNotifier<bool> _overflowingNotifier =
      ValueNotifier<bool>(false);

  TextStyle get _labelStyle {
    return widget.labelStyle.copyWith(
      color: widget.labelStyle.color
          ?.withOpacity(_overflowingNotifier.value ? 1 : 0.7),
    );
  }

  void _onTextSizeChange(
      double textWidth, double leftBoxWidth, double rightBoxWidth) {
    double labelWidth = textWidth + _labelsHorizontalMargins;
    if (leftBoxWidth < labelWidth || rightBoxWidth < labelWidth) {
      _overflowingNotifier.value = true;
    } else {
      _overflowingNotifier.value = false;
    }
  }

  void _onHorizontalDragUpdate(
      DragUpdateDetails dragDetails, double sliderWidth) {
    double normalized =
        (dragDetails.globalPosition.dx - _dragBarWidth) / sliderWidth;
    normalized = normalized.clamp(0.0, 1.0);

    // Se houver divisions, ajusta para o step mais próximo
    if (widget.divisions != null && widget.divisions! > 0) {
      final step = 1.0 / widget.divisions!;
      normalized = (normalized / step).round() * step;
    }

    _progressNotifier.value = normalized;
    // converte de volta para valor real
    final realValue = widget.min + normalized * (widget.max - widget.min);
    widget.onChange?.call(realValue);
    HapticFeedback.selectionClick();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: LayoutBuilder(
        builder: (context, constraints) {
          double sliderWidth = constraints.maxWidth;
          double sliderHeight = constraints.maxHeight;
          double sliderWidthWithoutBar = sliderWidth - _dragBarWidth;

          return ValueListenableBuilder<double>(
            valueListenable: _progressNotifier,
            builder: (context, progress, _) {
              double leftBoxWidth = sliderWidthWithoutBar * progress;
              double rightBoxWidth = sliderWidthWithoutBar - leftBoxWidth;
              int progressInPercentage = (progress * 100).toInt();

              return Stack(
                clipBehavior: Clip.none,
                children: [
                  // === Indicadores de steps ===

                  // === Track colorido e barra draggable ===
                  Row(
                    children: [
                      /// Left Box
                      AnimatedContainer(
                        width: leftBoxWidth,
                        height: 15,
                        duration: _animationDuration,
                        decoration: BoxDecoration(
                          color: widget.leftFillColor,
                          borderRadius: const BorderRadius.horizontal(
                            left: Radius.circular(20),
                            right: Radius.circular(8),
                          ),
                        ),
                      ),

                      /// Bar
                      _DraggableBar(
                        color: widget.barColor,
                        width: widget.barWidth,
                        cornerRadius: widget._cornerRadius,
                      ),

                      /// Right Box
                      AnimatedContainer(
                        width: rightBoxWidth,
                        height: 15,
                        duration: _animationDuration,
                        decoration: BoxDecoration(
                          color: widget.rightFillColor,
                          borderRadius: const BorderRadius.horizontal(
                            right: Radius.circular(20),
                            left: Radius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),

                  /// Área de arraste extra
                  Positioned.fromRect(
                    rect: Rect.fromCenter(
                      width: _dragRegion.width,
                      height: _dragRegion.height,
                      center: Offset(
                        leftBoxWidth + _dragBarWidth / 2,
                        sliderHeight / 2,
                      ),
                    ),
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onHorizontalDragUpdate: (d) =>
                          _onHorizontalDragUpdate(d, sliderWidth),
                    ),
                  ),
                  if (widget.divisions != null && widget.divisions! > 0)
                    ValueListenableBuilder<double>(
                      valueListenable: _progressNotifier,
                      builder: (context, progress, _) {
                        final activeIndex =
                            (progress * widget.divisions!).round();
                        return Positioned.fill(
                          child: LayoutBuilder(builder: (ctx, inner) {
                            return Row(
                              children: List.generate(
                                widget.divisions! + 1,
                                (i) {
                                  // se for o índice ativo, retorna um placeholder vazio
                                  if (i == activeIndex) {
                                    return const Expanded(child: SizedBox());
                                  }
                                  return const Expanded(
                                    child: Center(
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                        child: SizedBox(width: 6, height: 6),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          }),
                        );
                      },
                    ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class _DraggableBar extends StatelessWidget {
  const _DraggableBar({
    required this.width,
    required this.color,
    required this.cornerRadius,
  });

  final double width;
  final Color color;
  final BorderRadiusGeometry cornerRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: color,
        borderRadius: cornerRadius,
      ),
      margin: const EdgeInsets.symmetric(
        horizontal: _barHorizontalMargins,
      ),
    );
  }
}

class ComputedText extends StatefulWidget {
  const ComputedText(
    this.text, {
    super.key,
    required this.style,
    this.onSizeChange,
  });

  final String text;
  final TextStyle style;
  final void Function(double textWidth)? onSizeChange;

  @override
  State<ComputedText> createState() => _ComputedTextState();
}

class _ComputedTextState extends State<ComputedText> {
  Size _calculateSize() {
    final textLayout = TextPainter(
      text: TextSpan(text: widget.text, style: widget.style),
      maxLines: 1,
      textScaler: TextScaler.noScaling,
      textDirection: TextDirection.ltr,
    )..layout();
    return textLayout.size;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onSizeChange?.call(_calculateSize().width);
    });
  }

  @override
  void didUpdateWidget(covariant ComputedText oldWidget) {
    if (oldWidget.text != widget.text) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onSizeChange?.call(_calculateSize().width);
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      widget.text,
      style: widget.style,
    );
  }
}
