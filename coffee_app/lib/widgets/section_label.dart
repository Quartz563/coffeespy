import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/coffee_spy_colors.dart';

class SectionLabel extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color? color;

  const SectionLabel(this.text, {super.key, this.fontSize = 10, this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: GoogleFonts.spaceMono(
        fontSize: fontSize,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.4,
        color: color ?? context.coffeeColors.muted,
      ),
    );
  }
}
