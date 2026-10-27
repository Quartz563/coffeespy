import 'package:flutter/material.dart';

@immutable
class CoffeeSpyColors extends ThemeExtension<CoffeeSpyColors> {
  final Color accent;
  final Color accentInk;
  final Color accentBg;
  final Color accentLine;
  final Color verify;
  final Color mapStripe;
  final Color muted;
  final Color card;
  final Color line;

  const CoffeeSpyColors({
    required this.accent,
    required this.accentInk,
    required this.accentBg,
    required this.accentLine,
    required this.verify,
    required this.mapStripe,
    required this.muted,
    required this.card,
    required this.line,
  });

  static const dark = CoffeeSpyColors(
    accent: Color(0xFFD19A56),
    accentInk: Color(0xFF191410),
    accentBg: Color(0xFF241D17),
    accentLine: Color(0x52D19A56),
    verify: Color(0xFF8FB27E),
    mapStripe: Color(0xFF20190F),
    muted: Color(0xFF9C8B76),
    card: Color(0xFF241D17),
    line: Color(0x21EFE6D6),
  );

  static const light = CoffeeSpyColors(
    accent: Color(0xFFA8431F),
    accentInk: Color(0xFFF4EFE3),
    accentBg: Color(0xFFE3DBC8),
    accentLine: Color(0x4DA8431F),
    verify: Color(0xFF4F6B44),
    mapStripe: Color(0xFFE0D8C4),
    muted: Color(0xFF877E6D),
    card: Color(0xFFF4EFE3),
    line: Color(0x2B1B1712),
  );

  @override
  CoffeeSpyColors copyWith({
    Color? accent,
    Color? accentInk,
    Color? accentBg,
    Color? accentLine,
    Color? verify,
    Color? mapStripe,
    Color? muted,
    Color? card,
    Color? line,
  }) {
    return CoffeeSpyColors(
      accent: accent ?? this.accent,
      accentInk: accentInk ?? this.accentInk,
      accentBg: accentBg ?? this.accentBg,
      accentLine: accentLine ?? this.accentLine,
      verify: verify ?? this.verify,
      mapStripe: mapStripe ?? this.mapStripe,
      muted: muted ?? this.muted,
      card: card ?? this.card,
      line: line ?? this.line,
    );
  }

  @override
  CoffeeSpyColors lerp(ThemeExtension<CoffeeSpyColors>? other, double t) {
    if (other is! CoffeeSpyColors) return this;
    return CoffeeSpyColors(
      accent: Color.lerp(accent, other.accent, t)!,
      accentInk: Color.lerp(accentInk, other.accentInk, t)!,
      accentBg: Color.lerp(accentBg, other.accentBg, t)!,
      accentLine: Color.lerp(accentLine, other.accentLine, t)!,
      verify: Color.lerp(verify, other.verify, t)!,
      mapStripe: Color.lerp(mapStripe, other.mapStripe, t)!,
      muted: Color.lerp(muted, other.muted, t)!,
      card: Color.lerp(card, other.card, t)!,
      line: Color.lerp(line, other.line, t)!,
    );
  }
}

extension CoffeeSpyColorsX on BuildContext {
  CoffeeSpyColors get coffeeColors =>
      Theme.of(this).extension<CoffeeSpyColors>()!;
}
