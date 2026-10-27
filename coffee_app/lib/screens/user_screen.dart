import 'package:coffee_app/models/price_report.dart';
import 'package:coffee_app/services/api_services.dart';
import 'package:coffee_app/services/auth_service.dart';
import 'package:coffee_app/theme/coffee_spy_colors.dart';
import 'package:coffee_app/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/user.dart';
import '../widgets/report_card.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  late List<PriceReport> reports = [];
  bool _isLoading = true;
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _isLoading = true);
    final user = await AuthService.getCurrentUser();
    if (user == null) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      //display "not logged in" screen here.
      return;
    }
    final reportSet = await ApiService.fetchUserReports(user.id);
    if (!mounted) return;
    setState(() {
      reports = reportSet;
      _currentUser = user;
      _isLoading = false;
    });
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
            : _currentUser == null
            ? _displayGuest(colors)
            : _displayUser(colors),
      ),
    );
  }

  Widget _displayUser(CoffeeSpyColors colors) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 8, 10, 0),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, size: 16),
                onPressed: () => Navigator.pop(context),
              ),
              Text(
                '${_currentUser!.username}\'s Profile',
                style: GoogleFonts.spaceMono(
                  fontSize: 11,
                  letterSpacing: 1.5,
                  color: colors.muted,
                ),
              ),
            ],
          ),
        ),
        //put something here, profile pic or stats? unsure.
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
              cafe: report.cafe,
              report: report,
              isMine: report.user.id == _currentUser!.id,
            ),
          ),
      ],
    );
  }

  Widget _displayGuest(CoffeeSpyColors colors) {
    return Column();
  }
}
