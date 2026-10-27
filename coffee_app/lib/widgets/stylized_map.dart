import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/cafe.dart';
import '../theme/coffee_spy_colors.dart';
import 'price_text.dart';

class _StripePainter extends CustomPainter {
  final Color stripeColor;
  final Color lineColor;

  _StripePainter({required this.stripeColor, required this.lineColor});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = stripeColor);

    void diagonalLines(double angleDeg, double gap, Color color) {
      final paint = Paint()
        ..color = color
        ..strokeWidth = 1;
      final angle = angleDeg * pi / 180;
      final dx = cos(angle);
      final dy = sin(angle);
      final diag = size.width + size.height;
      for (double offset = -diag; offset < diag; offset += gap) {
        final cx = size.width / 2 + offset * -dy;
        final cy = size.height / 2 + offset * dx;
        final p1 = Offset(cx - dx * diag, cy - dy * diag);
        final p2 = Offset(cx + dx * diag, cy + dy * diag);
        canvas.drawLine(p1, p2, paint);
      }
    }

    diagonalLines(35, 27, lineColor);
    diagonalLines(-52, 35, lineColor);
  }

  @override
  bool shouldRepaint(covariant _StripePainter oldDelegate) =>
      oldDelegate.stripeColor != stripeColor ||
      oldDelegate.lineColor != lineColor;
}

class MapPlaceholderPanel extends StatelessWidget {
  final String label;
  final double height;

  const MapPlaceholderPanel({
    super.key,
    required this.label,
    this.height = 120,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.coffeeColors;
    return Container(
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(border: Border.all(color: colors.line)),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: _StripePainter(
                stripeColor: colors.mapStripe,
                lineColor: colors.line,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              border: Border.all(color: colors.line),
            ),
            child: Text(
              label,
              style: GoogleFonts.spaceMono(
                fontSize: 9.5,
                letterSpacing: 1,
                color: colors.muted,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CafePin {
  final Cafe cafe;
  final double? cheapestPrice;
  final double left;
  final double top;

  const CafePin({
    required this.cafe,
    required this.cheapestPrice,
    required this.left,
    required this.top,
  });
}

/// Deterministic pseudo-random layout for cafe pins on the stylized map.
/// There's no real geocoding here — positions are seeded on cafe.id purely
/// for visual variety, not actual geography.
List<CafePin> layoutPins(List<Cafe> cafes, Map<int, double?> cheapestByCafe) {
  return cafes.map((cafe) {
    final rnd = Random(cafe.id);
    final left = 0.16 + rnd.nextDouble() * 0.68;
    final top = 0.18 + rnd.nextDouble() * 0.58;
    return CafePin(
      cafe: cafe,
      cheapestPrice: cheapestByCafe[cafe.id],
      left: left,
      top: top,
    );
  }).toList();
}

class StylizedMap extends StatelessWidget {
  final List<CafePin> pins;
  final int? cheapestCafeId;
  final ValueChanged<Cafe>? onTapPin;
  final String? chipLabel;

  const StylizedMap({
    super.key,
    required this.pins,
    this.cheapestCafeId,
    this.onTapPin,
    this.chipLabel,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.coffeeColors;

    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        return Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: _StripePainter(
                  stripeColor: colors.mapStripe,
                  lineColor: colors.line,
                ),
              ),
            ),
            ..._roads(colors, size),
            Positioned(
              left: size.width * 0.5 - 7,
              top: size.height * 0.52 - 7,
              child: Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colors.verify,
                  boxShadow: [
                    BoxShadow(
                      color: colors.verify.withValues(alpha: 0.3),
                      blurRadius: 0,
                      spreadRadius: 5,
                    ),
                  ],
                ),
              ),
            ),
            for (final pin in pins)
              Positioned(
                left: size.width * pin.left,
                top: size.height * pin.top,
                child: FractionalTranslation(
                  translation: const Offset(-0.5, -1),
                  child: _Pin(
                    pin: pin,
                    isCheapest: pin.cafe.id == cheapestCafeId,
                    onTap: onTapPin == null
                        ? null
                        : () => onTapPin!(pin.cafe),
                  ),
                ),
              ),
            if (chipLabel != null)
              Positioned(
                left: 14,
                top: 14,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 11,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    border: Border.all(color: colors.line),
                  ),
                  child: Text(
                    chipLabel!,
                    style: GoogleFonts.spaceMono(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                      color: colors.muted,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  List<Widget> _roads(CoffeeSpyColors colors, Size size) {
    final roadColor = colors.card.withValues(alpha: 0.8);
    return [
      Positioned(
        left: -30,
        right: -30,
        top: size.height * 0.37,
        child: Transform.rotate(
          angle: -6 * pi / 180,
          child: Container(height: 16, color: roadColor),
        ),
      ),
      Positioned(
        left: -30,
        right: -30,
        top: size.height * 0.71,
        child: Transform.rotate(
          angle: 4 * pi / 180,
          child: Container(height: 11, color: roadColor),
        ),
      ),
    ];
  }
}

class _Pin extends StatelessWidget {
  final CafePin pin;
  final bool isCheapest;
  final VoidCallback? onTap;

  const _Pin({required this.pin, required this.isCheapest, this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = context.coffeeColors;
    final bg = isCheapest
        ? colors.accent
        : Theme.of(context).cardColor;
    final fg = isCheapest ? colors.accentInk : Theme.of(context).colorScheme.onSurface;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
            decoration: BoxDecoration(
              color: bg,
              border: Border.all(
                color: isCheapest ? colors.accent : colors.line,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: pin.cheapestPrice != null
                ? PriceText(
                    '\$${pin.cheapestPrice!.toStringAsFixed(2)}',
                    fontSize: 11,
                    color: fg,
                  )
                : Text(
                    '—',
                    style: GoogleFonts.spaceMono(fontSize: 11, color: fg),
                  ),
          ),
          CustomPaint(size: const Size(7, 5), painter: _TipPainter(bg)),
        ],
      ),
    );
  }
}

class _TipPainter extends CustomPainter {
  final Color color;

  _TipPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();
    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant _TipPainter oldDelegate) =>
      oldDelegate.color != color;
}
