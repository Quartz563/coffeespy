import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/cafe.dart';
import '../services/api_services.dart';
import '../theme/coffee_spy_colors.dart';

class _DrinkDef {
  final String value;
  final String label;
  final String sub;

  const _DrinkDef(this.value, this.label, this.sub);
}

const _drinkDefs = [
  _DrinkDef('flat_white', 'Flat White', 'Espresso · steamed milk'),
  _DrinkDef('long_black', 'Long Black', 'Espresso · hot water'),
  _DrinkDef('latte', 'Latte', 'Espresso · lots of milk'),
  _DrinkDef('cappuccino', 'Cappuccino', 'Espresso · foam'),
];

const _sizes = ['small', 'medium', 'large'];
const _milks = ['whole', 'skim', 'oat', 'almond', 'none'];

String _label(String value) {
  return value
      .split('_')
      .map((w) => w.isEmpty ? w : w[0].toUpperCase() + w.substring(1))
      .join(' ');
}

class ReportScreen extends StatefulWidget {
  final Cafe cafe;

  const ReportScreen({super.key, required this.cafe});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  int _step = 0;
  String? _drinkType;
  String? _size;
  String? _milkType;
  String _price = '';
  bool _isSubmitting = false;
  String? _errorMessage;

  void _press(String key) {
    setState(() {
      if (key == '⌫') {
        if (_price.isNotEmpty) _price = _price.substring(0, _price.length - 1);
      } else if (key == '.') {
        if (!_price.contains('.')) _price = '${_price.isEmpty ? '0' : _price}.';
      } else {
        if (_price.contains('.') && _price.split('.')[1].length >= 2) return;
        if (_price.replaceAll('.', '').length >= 6) return;
        _price = _price + key;
      }
    });
  }

  double get _priceValue => double.tryParse(_price) ?? 0;

  String? get _priceWarning {
    if (_price.isEmpty || _priceValue <= 0) return null;
    if (_priceValue < 2) return 'That looks low for a coffee — sure?';
    if (_priceValue > 12) return 'That looks high — double-check the amount.';
    return null;
  }

  void _back() {
    if (_step > 0) {
      setState(() => _step--);
    } else {
      Navigator.pop(context);
    }
  }

  Future<void> _submit() async {
    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });
    try {
      await ApiService.createPriceReport(
        widget.cafe.id,
        _drinkType!,
        _milkType!,
        _size!,
        _priceValue,
      );
      if (!mounted) return;
      setState(() {
        _isSubmitting = false;
        _step = 3;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isSubmitting = false;
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.coffeeColors;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            if (_step != 3) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 18, 0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new, size: 16),
                      onPressed: _back,
                    ),
                    Text(
                      'NEW REPORT',
                      style: GoogleFonts.spaceMono(
                        fontSize: 11,
                        letterSpacing: 1.6,
                        color: colors.muted,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '0${_step + 1} / 03',
                      style: GoogleFonts.spaceMono(
                        fontSize: 11,
                        letterSpacing: 1.5,
                        color: colors.muted,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 9, 18, 0),
                child: Text(
                  '◎ ${widget.cafe.name}',
                  style: GoogleFonts.spaceMono(
                    fontSize: 10,
                    letterSpacing: 0.5,
                    color: colors.muted,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 13, 18, 0),
                child: Row(
                  children: List.generate(3, (i) {
                    final on = _step >= i;
                    return Expanded(
                      child: Container(
                        height: 3,
                        margin: EdgeInsets.only(right: i < 2 ? 5 : 0),
                        color: on ? colors.accent : colors.line,
                      ),
                    );
                  }),
                ),
              ),
            ],
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 260),
                transitionBuilder: (child, animation) => FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.06, 0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                ),
                child: KeyedSubtree(
                  key: ValueKey(_step),
                  child: _buildStep(colors),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep(CoffeeSpyColors colors) {
    switch (_step) {
      case 0:
        return _buildDrinkStep(colors);
      case 1:
        return _buildSizeMilkStep(colors);
      case 2:
        return _buildPriceStep(colors);
      default:
        return _buildDoneStep(colors);
    }
  }

  Widget _buildDrinkStep(CoffeeSpyColors colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 2),
          child: Text(
            'What did you order?',
            style: GoogleFonts.newsreader(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.4,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
        Expanded(
          child: ListView(
            children: _drinkDefs.map((d) {
              final selected = _drinkType == d.value;
              return InkWell(
                onTap: () => setState(() => _drinkType = d.value),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 15,
                  ),
                  decoration: BoxDecoration(
                    color: selected ? colors.card : null,
                    border: Border(
                      top: BorderSide(color: colors.line),
                      left: BorderSide(
                        color: selected ? colors.accent : Colors.transparent,
                        width: 3,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            d.label,
                            style: GoogleFonts.newsreader(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            d.sub,
                            style: GoogleFonts.spaceMono(
                              fontSize: 9,
                              letterSpacing: 0.5,
                              color: colors.muted,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: 21,
                        height: 21,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: selected ? colors.accent : null,
                          border: Border.all(
                            color: selected ? colors.accent : colors.line,
                          ),
                        ),
                        child: selected
                            ? Icon(
                                Icons.check,
                                size: 12,
                                color: colors.accentInk,
                              )
                            : null,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        _WizardFooter(
          nextEnabled: _drinkType != null,
          onNext: () => setState(() => _step = 1),
        ),
      ],
    );
  }

  Widget _buildSizeMilkStep(CoffeeSpyColors colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 2),
          child: Text(
            'Size & milk',
            style: GoogleFonts.newsreader(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.4,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
        Expanded(
          child: ListView(
            children: [
              _chipsSection(
                colors,
                'Size',
                _sizes,
                _size,
                (v) => setState(() => _size = v),
              ),
              _chipsSection(
                colors,
                'Milk',
                _milks,
                _milkType,
                (v) => setState(() => _milkType = v),
              ),
            ],
          ),
        ),
        _WizardFooter(
          nextEnabled: _size != null && _milkType != null,
          onBack: () => setState(() => _step = 0),
          onNext: () => setState(() => _step = 2),
        ),
      ],
    );
  }

  Widget _chipsSection(
    CoffeeSpyColors colors,
    String label,
    List<String> values,
    String? selectedValue,
    ValueChanged<String> onPick,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 22, 18, 11),
          child: Text(
            label.toUpperCase(),
            style: GoogleFonts.spaceMono(
              fontSize: 10,
              letterSpacing: 1.5,
              color: colors.muted,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: values.map((v) {
              final selected = selectedValue == v;
              return InkWell(
                onTap: () => onPick(v),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 9,
                  ),
                  decoration: BoxDecoration(
                    color: selected ? colors.accent : null,
                    border: Border.all(
                      color: selected ? colors.accent : colors.line,
                    ),
                  ),
                  child: Text(
                    _label(v),
                    style: GoogleFonts.spaceMono(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: selected
                          ? colors.accentInk
                          : Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildPriceStep(CoffeeSpyColors colors) {
    final warning = _priceWarning;
    final display = '\$${_price.isEmpty ? '0.00' : _price}';
    final keys = [
      '1',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
      '.',
      '0',
      '⌫',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 2),
          child: Text(
            'What did it cost?',
            style: GoogleFonts.newsreader(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.4,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 18),
          child: Text(
            'TAP TO ENTER PRICE',
            textAlign: TextAlign.center,
            style: GoogleFonts.spaceMono(
              fontSize: 10,
              letterSpacing: 1.5,
              color: colors.muted,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Text(
            display,
            textAlign: TextAlign.center,
            style: GoogleFonts.spaceMono(
              fontSize: 52,
              fontWeight: FontWeight.w700,
              letterSpacing: -2,
              color: _price.isEmpty
                  ? colors.muted
                  : Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
        if (warning != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 8, 22, 0),
            child: Text(
              '⚠ $warning',
              textAlign: TextAlign.center,
              style: GoogleFonts.spaceMono(
                fontSize: 10,
                letterSpacing: 0.4,
                color: colors.accent,
              ),
            ),
          ),
        if (_errorMessage != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 8, 22, 0),
            child: Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 16, 14, 0),
            child: GridView.count(
              crossAxisCount: 3,
              mainAxisSpacing: 1,
              crossAxisSpacing: 1,
              childAspectRatio: 1.9,
              children: keys.map((k) {
                return InkWell(
                  onTap: () => _press(k),
                  child: Container(
                    alignment: Alignment.center,
                    color: colors.card,
                    child: Text(
                      k,
                      style: GoogleFonts.spaceMono(
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        _WizardFooter(
          nextEnabled: _priceValue > 0 && !_isSubmitting,
          nextLabel: _isSubmitting ? 'Submitting…' : 'Submit',
          onBack: () => setState(() => _step = 1),
          onNext: _submit,
        ),
      ],
    );
  }

  Widget _buildDoneStep(CoffeeSpyColors colors) {
    final ink = Theme.of(context).colorScheme.onSurface;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 26),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: const Duration(milliseconds: 450),
            curve: Curves.elasticOut,
            builder: (context, value, child) =>
                Transform.scale(scale: value, child: child),
            child: Container(
              width: 62,
              height: 62,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.verify,
              ),
              child: Icon(Icons.check, size: 30, color: colors.card),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'Price logged',
            style: GoogleFonts.newsreader(
              fontSize: 27,
              fontWeight: FontWeight.w600,
              color: ink,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Thanks for the intel — it's live now.",
            style: GoogleFonts.hankenGrotesk(fontSize: 12.5, color: colors.muted),
            textAlign: TextAlign.center,
          ),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 22),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              border: Border.all(color: colors.line),
            ),
            child: Column(
              children: [
                _receiptRow(colors, 'Cafe', widget.cafe.name),
                _receiptRow(colors, 'Drink', _label(_drinkType ?? '')),
                _receiptRow(
                  colors,
                  'Size · Milk',
                  '${_label(_size ?? '')} · ${_label(_milkType ?? '')}',
                ),
                Divider(color: colors.line, height: 18),
                _receiptRow(
                  colors,
                  'Total',
                  '\$${_priceValue.toStringAsFixed(2)}',
                  bold: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '◎ Thanks for spying on prices at ${widget.cafe.name}',
            style: GoogleFonts.spaceMono(
              fontSize: 9.5,
              letterSpacing: 1,
              color: colors.verify,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 26),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('See it on the cafe'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _receiptRow(CoffeeSpyColors colors, String label, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.spaceMono(fontSize: 12, color: colors.muted),
          ),
          Text(
            value,
            style: GoogleFonts.spaceMono(
              fontSize: bold ? 16 : 12,
              fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

class _WizardFooter extends StatelessWidget {
  final bool nextEnabled;
  final String nextLabel;
  final VoidCallback? onBack;
  final VoidCallback onNext;

  const _WizardFooter({
    required this.nextEnabled,
    this.nextLabel = 'Next',
    this.onBack,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.coffeeColors;
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
      child: Row(
        children: [
          if (onBack != null) ...[
            SizedBox(
              width: 92,
              height: 47,
              child: OutlinedButton(
                onPressed: onBack,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: colors.line),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                child: const Text('Back'),
              ),
            ),
            const SizedBox(width: 10),
          ],
          Expanded(
            child: SizedBox(
              height: 47,
              child: ElevatedButton(
                onPressed: nextEnabled ? onNext : null,
                child: Text(nextLabel),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
