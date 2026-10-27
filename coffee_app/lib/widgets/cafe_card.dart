import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/cafe.dart';
import '../screens/cafe_screen.dart';
import '../theme/coffee_spy_colors.dart';
import 'price_text.dart';

class CafeCard extends StatelessWidget {
  final Cafe cafe;
  final double? cheapestPrice;
  final int reportCount;

  const CafeCard({
    super.key,
    required this.cafe,
    this.cheapestPrice,
    this.reportCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.coffeeColors;
    final ink = Theme.of(context).colorScheme.onSurface;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CafeScreen(cafe: cafe)),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: colors.line)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cafe.name,
                        style: GoogleFonts.newsreader(
                          fontSize: 19,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.2,
                          color: ink,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        cafe.address,
                        style: GoogleFonts.hankenGrotesk(
                          fontSize: 11.5,
                          color: colors.muted,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (cheapestPrice != null) ...[
                      Text(
                        'FROM',
                        style: GoogleFonts.spaceMono(
                          fontSize: 8,
                          letterSpacing: 0.8,
                          color: colors.muted,
                        ),
                      ),
                      PriceText(
                        '\$${cheapestPrice!.toStringAsFixed(2)}',
                        fontSize: 20,
                      ),
                    ] else
                      Text(
                        'No reports yet',
                        style: GoogleFonts.hankenGrotesk(
                          fontSize: 11,
                          color: colors.muted,
                        ),
                      ),
                  ],
                ),
              ],
            ),
            if (reportCount > 0) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.check_circle, size: 13, color: colors.verify),
                  const SizedBox(width: 5),
                  Text(
                    '$reportCount ${reportCount == 1 ? 'report' : 'reports'}',
                    style: GoogleFonts.spaceMono(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: colors.verify,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
