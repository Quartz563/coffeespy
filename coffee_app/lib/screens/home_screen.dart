import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/cafe.dart';
import '../models/price_report.dart';
import '../services/api_services.dart';
import '../theme/coffee_spy_colors.dart';
import '../widgets/app_drawer.dart';
import '../widgets/cafe_card.dart';
import '../widgets/price_text.dart';
import '../widgets/section_label.dart';
import '../widgets/stylized_map.dart';
import 'cafe_screen.dart';

enum _SortBy { price, name }

enum _ViewMode { list, map }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _searchController = TextEditingController();

  bool _isLoading = true;
  List<Cafe> _cafes = [];
  Map<int, List<PriceReport>> _reportsByCafe = {};
  _SortBy _sortBy = _SortBy.price;
  _ViewMode _viewMode = _ViewMode.list;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _load();
    _searchController.addListener(() {
      setState(() => _query = _searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _isLoading = true);
    try {
      final cafes = await ApiService.fetchCafes();
      final entries = await Future.wait(
        cafes.map((c) async {
          try {
            final reports = await ApiService.fetchReports(c.id);
            return MapEntry(c.id, reports);
          } catch (_) {
            return MapEntry(c.id, <PriceReport>[]);
          }
        }),
      );
      if (!mounted) return;
      setState(() {
        _cafes = cafes;
        _reportsByCafe = Map.fromEntries(entries);
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  double? _cheapest(int cafeId) {
    final reports = _reportsByCafe[cafeId];
    if (reports == null || reports.isEmpty) return null;
    return reports.map((r) => r.price).reduce(min);
  }

  List<Cafe> get _filteredSorted {
    final list = _cafes.where((c) {
      if (_query.isEmpty) return true;
      final q = _query.toLowerCase();
      return c.name.toLowerCase().contains(q) ||
          c.address.toLowerCase().contains(q);
    }).toList();
    list.sort((a, b) {
      if (_sortBy == _SortBy.name) return a.name.compareTo(b.name);
      final pa = _cheapest(a.id);
      final pb = _cheapest(b.id);
      if (pa == null && pb == null) return 0;
      if (pa == null) return 1;
      if (pb == null) return -1;
      return pa.compareTo(pb);
    });
    return list;
  }

  Cafe? get _cheapestCafe {
    Cafe? best;
    double? bestPrice;
    for (final c in _cafes) {
      final p = _cheapest(c.id);
      if (p == null) continue;
      if (bestPrice == null || p < bestPrice) {
        bestPrice = p;
        best = c;
      }
    }
    return best;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.coffeeColors;
    final ink = Theme.of(context).colorScheme.onSurface;

    return Scaffold(
      key: _scaffoldKey,
      endDrawer: const AppDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 8, 10, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(
                      style: GoogleFonts.newsreader(
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.6,
                        color: ink,
                      ),
                      children: [
                        const TextSpan(text: 'Coffee'),
                        TextSpan(
                          text: 'Spy',
                          style: TextStyle(color: colors.accent),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () =>
                        _scaffoldKey.currentState?.openEndDrawer(),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 2, 18, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: SectionLabel(
                  '◎ Price intel · crowd-sourced',
                  fontSize: 9.5,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 14, 18, 0),
              child: _ViewToggle(
                mode: _viewMode,
                onChanged: (m) => setState(() => _viewMode = m),
              ),
            ),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _viewMode == _ViewMode.list
                  ? _buildList(colors, ink)
                  : _buildMap(colors),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList(CoffeeSpyColors colors, Color ink) {
    final cheapestCafe = _cheapestCafe;
    final list = _filteredSorted;

    return ListView(
      padding: const EdgeInsets.only(bottom: 24),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search, color: colors.muted, size: 18),
              hintText: 'Search cafes or suburbs',
              hintStyle: GoogleFonts.hankenGrotesk(
                fontSize: 13,
                color: colors.muted,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
            ),
          ),
        ),
        if (cheapestCafe != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 0),
            child: InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CafeScreen(cafe: cheapestCafe),
                ),
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(color: colors.accent, width: 3),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'CHEAPEST NEARBY',
                            style: GoogleFonts.spaceMono(
                              fontSize: 9,
                              letterSpacing: 1.2,
                              color: colors.muted,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            cheapestCafe.name,
                            style: GoogleFonts.newsreader(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: ink,
                            ),
                          ),
                        ],
                      ),
                    ),
                    PriceText(
                      '\$${_cheapest(cheapestCafe.id)!.toStringAsFixed(2)}',
                      fontSize: 27,
                      color: colors.accent,
                    ),
                  ],
                ),
              ),
            ),
          ),
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SectionLabel('Nearby cafes'),
              InkWell(
                onTap: () => setState(
                  () => _sortBy = _sortBy == _SortBy.price
                      ? _SortBy.name
                      : _SortBy.price,
                ),
                child: SectionLabel(
                  'Sort · ${_sortBy == _SortBy.price ? 'Price' : 'Name'} ▾',
                ),
              ),
            ],
          ),
        ),
        if (list.isEmpty)
          Padding(
            padding: const EdgeInsets.all(32),
            child: Center(
              child: Text(
                'No cafes found',
                style: GoogleFonts.hankenGrotesk(color: colors.muted),
              ),
            ),
          )
        else
          ...list.map(
            (cafe) => CafeCard(
              cafe: cafe,
              cheapestPrice: _cheapest(cafe.id),
              reportCount: _reportsByCafe[cafe.id]?.length ?? 0,
            ),
          ),
      ],
    );
  }

  Widget _buildMap(CoffeeSpyColors colors) {
    final cheapestByCafe = {for (final c in _cafes) c.id: _cheapest(c.id)};
    final pins = layoutPins(_cafes, cheapestByCafe);
    final cheapestCafe = _cheapestCafe;

    return Stack(
      children: [
        Positioned.fill(
          child: StylizedMap(
            pins: pins,
            cheapestCafeId: cheapestCafe?.id,
            chipLabel: '◎ ${_cafes.length} CAFES NEARBY',
            onTapPin: (cafe) => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => CafeScreen(cafe: cafe)),
            ),
          ),
        ),
        if (cheapestCafe != null)
          Positioned(
            left: 14,
            right: 14,
            bottom: 14,
            child: InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CafeScreen(cafe: cheapestCafe),
                ),
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 11,
                ),
                decoration: BoxDecoration(
                  color: colors.accentBg,
                  border: Border.all(color: colors.accentLine),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'CHEAPEST NEARBY',
                          style: GoogleFonts.spaceMono(
                            fontSize: 9,
                            letterSpacing: 1,
                            color: colors.muted,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          cheapestCafe.name,
                          style: GoogleFonts.newsreader(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    PriceText(
                      '\$${_cheapest(cheapestCafe.id)!.toStringAsFixed(2)}',
                      fontSize: 21,
                      color: colors.accent,
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _ViewToggle extends StatelessWidget {
  final _ViewMode mode;
  final ValueChanged<_ViewMode> onChanged;

  const _ViewToggle({required this.mode, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final colors = context.coffeeColors;
    return Container(
      decoration: BoxDecoration(border: Border.all(color: colors.line)),
      child: Row(
        children: [
          Expanded(child: _seg(context, 'List', _ViewMode.list)),
          Expanded(child: _seg(context, 'Map', _ViewMode.map)),
        ],
      ),
    );
  }

  Widget _seg(BuildContext context, String label, _ViewMode value) {
    final colors = context.coffeeColors;
    final selected = mode == value;
    return InkWell(
      onTap: () => onChanged(value),
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 9),
        color: selected ? colors.accent : Colors.transparent,
        child: Text(
          label,
          style: GoogleFonts.spaceMono(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: selected ? colors.accentInk : colors.muted,
          ),
        ),
      ),
    );
  }
}
