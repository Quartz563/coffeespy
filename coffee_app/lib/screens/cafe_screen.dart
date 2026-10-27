import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/cafe.dart';
import '../models/price_report.dart';
import '../services/api_services.dart';
import '../services/auth_service.dart';
import '../theme/coffee_spy_colors.dart';
import '../widgets/app_drawer.dart';
import '../widgets/report_card.dart';
import '../widgets/stylized_map.dart';
import 'login_screen.dart';
import 'report_screen.dart';

class CafeScreen extends StatefulWidget {
  final Cafe cafe;

  const CafeScreen({super.key, required this.cafe});

  @override
  State<CafeScreen> createState() => _CafeScreenState();
}

class _CafeScreenState extends State<CafeScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  late List<PriceReport> reports = [];
  bool _isLoading = true;
  int? _currentUserId;

  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _isLoading = true);
    setState(() => _error = "");
    try {
      final results = await Future.wait([
        ApiService.fetchReports(widget.cafe.id),
        AuthService.getCurrentUserId(),
      ]);
      if (!mounted) return;
      setState(() {
        reports = results[0] as List<PriceReport>;
        _currentUserId = results[1] as int?;
        _isLoading = false;
      });
    } catch (e) {
      if(!mounted) return;
      setState(() => _isLoading = false);
      setState(() => _error = e.toString()); //todo display error message?
    }
  }

  Future<void> _startReport() async {
    final loggedIn = await AuthService.isLoggedIn();
    if (!mounted) return;
    if (loggedIn) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ReportScreen(cafe: widget.cafe),
        ),
      );
      _load();
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.coffeeColors;
    final ink = Theme.of(context).colorScheme.onSurface;

    return Scaffold(
      key: _scaffoldKey,
      endDrawer: const AppDrawer(),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: const EdgeInsets.only(bottom: 24),
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 8, 10, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new, size: 16),
                          onPressed: () => Navigator.pop(context),
                        ),
                        Text(
                          widget.cafe.name.toUpperCase(),
                          style: GoogleFonts.spaceMono(
                            fontSize: 11,
                            letterSpacing: 1.6,
                            color: colors.muted,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.more_vert, size: 18),
                          onPressed: () =>
                              _scaffoldKey.currentState?.openEndDrawer(),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 8, 18, 0),
                    child: MapPlaceholderPanel(
                      label: '◎ MAP · ${widget.cafe.address.toUpperCase()}',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 16, 18, 0),
                    child: Text(
                      widget.cafe.name,
                      style: GoogleFonts.newsreader(
                        fontSize: 33,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -1,
                        color: ink,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 6, 18, 0),
                    child: Text(
                      widget.cafe.address,
                      style: GoogleFonts.hankenGrotesk(
                        fontSize: 12,
                        color: colors.muted,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 16, 18, 0),
                    child: _StatRow(reports: reports),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 16, 18, 2),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _startReport,
                        icon: const Icon(Icons.add),
                        label: const Text('Report a price'),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 22, 18, 4),
                    child: Text(
                      'PRICE INTEL',
                      style: GoogleFonts.spaceMono(
                        fontSize: 10,
                        letterSpacing: 1.5,
                        color: colors.muted,
                      ),
                    ),
                  ),
                  if (reports.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(32),
                      child: Center(
                        child: Text(
                          'No reports yet!',
                          style: GoogleFonts.hankenGrotesk(color: colors.muted),
                        ),
                      ),
                    )
                  else
                    ...reports.map(
                      (report) => ReportCard(
                        cafe: widget.cafe,
                        report: report,
                        isMine: report.user.id == _currentUserId,
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final List<PriceReport> reports;

  const _StatRow({required this.reports});

  @override
  Widget build(BuildContext context) {
    final colors = context.coffeeColors;
    final prices = reports.map((r) => r.price).toList();
    final avg = prices.isEmpty
        ? null
        : prices.reduce((a, b) => a + b) / prices.length;
    final cheapest = prices.isEmpty ? null : prices.reduce(min);

    String fmt(double? v) => v == null ? '—' : '\$${v.toStringAsFixed(2)}';

    return Container(
      decoration: BoxDecoration(border: Border.all(color: colors.line)),
      child: Row(
        children: [
          Expanded(child: _stat(context, 'AVG PRICE', fmt(avg))),
          Expanded(
            child: _stat(context, 'CHEAPEST', fmt(cheapest), bordered: true),
          ),
          Expanded(
            child: _stat(
              context,
              'REPORTS',
              '${reports.length}',
              bordered: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _stat(
    BuildContext context,
    String label,
    String value, {
    bool bordered = false,
  }) {
    final colors = context.coffeeColors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
      decoration: BoxDecoration(
        border: bordered ? Border(left: BorderSide(color: colors.line)) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.spaceMono(
              fontSize: 8,
              letterSpacing: 0.8,
              color: colors.muted,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.spaceMono(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
