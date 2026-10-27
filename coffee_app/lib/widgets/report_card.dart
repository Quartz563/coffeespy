import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/cafe.dart';
import '../models/price_report.dart';
import '../screens/login_screen.dart';
import '../services/api_services.dart';
import '../services/auth_service.dart';
import '../theme/coffee_spy_colors.dart';
import 'price_text.dart';

class ReportCard extends StatefulWidget {
  final Cafe cafe;
  final PriceReport report;
  final bool isMine;

  const ReportCard({
    super.key,
    required this.cafe,
    required this.report,
    required this.isMine,
  });

  @override
  State<ReportCard> createState() => _ReportCardState();
}

class _ReportCardState extends State<ReportCard> {
  String _label(String value) {
    return value
        .split('_')
        .map((w) => w.isEmpty ? w : w[0].toUpperCase() + w.substring(1))
        .join(' ');
  }

  Future<void> _onConfirmTap() async {
    final loggedIn = await AuthService.isLoggedIn();
    if (!mounted) return;
    if (!loggedIn) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
      return;
    }
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm price'),
        content: const Text('Confirm this is the current price?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Yes'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ApiService.createConfirmation(widget.cafe.id, widget.report.id);
      messenger.showSnackBar(const SnackBar(content: Text('Price confirmed!')));
    } catch (e) {
      messenger.showSnackBar(
        const SnackBar(
          content: Text("You can't confirm your own price report!"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.coffeeColors;
    final ink = Theme.of(context).colorScheme.onSurface;
    final report = widget.report;
    final milkSuffix = report.milkType == 'none' ? '' : ' milk';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: colors.line),
          left: widget.isMine
              ? BorderSide(color: colors.verify, width: 3)
              : BorderSide.none,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _label(report.drinkType),
                  style: GoogleFonts.newsreader(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w600,
                    color: ink,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${_label(report.size)} · ${_label(report.milkType)}$milkSuffix',
                  style: GoogleFonts.spaceMono(
                    fontSize: 9.5,
                    letterSpacing: 0.5,
                    color: colors.muted,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '@${report.user.username}',
                  style: GoogleFonts.hankenGrotesk(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
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
              PriceText('\$${report.price.toStringAsFixed(2)}', fontSize: 21),
              const SizedBox(height: 9),
              if (widget.isMine)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 11,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: colors.verify),
                  ),
                  child: Text(
                    'Yours',
                    style: GoogleFonts.spaceMono(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w700,
                      color: colors.verify,
                    ),
                  ),
                )
              else
                InkWell(
                  onTap: _onConfirmTap,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 11,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: colors.line),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check, size: 12, color: colors.verify),
                        const SizedBox(width: 5),
                        Text(
                          'Confirm',
                          style: GoogleFonts.spaceMono(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w700,
                            color: ink,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
