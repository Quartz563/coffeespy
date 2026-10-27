import 'package:coffee_app/screens/user_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../screens/login_screen.dart';
import '../services/auth_service.dart';
import '../theme/coffee_spy_colors.dart';
import '../theme/theme_controller.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  late Future<_Account> _account = _loadAccount();

  Future<_Account> _loadAccount() async {
    final loggedIn = await AuthService.isLoggedIn();
    final username = loggedIn ? await AuthService.getCurrentUsername() : null;
    return _Account(loggedIn: loggedIn, username: username);
  }

  void _refresh() {
    if (!mounted) return;
    setState(
      () => _account = _loadAccount(),
    ); //this is a major error, check for mount first
  }

  void _comingSoon(String feature) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('$feature is coming soon')));
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.coffeeColors;
    final ink = Theme.of(context).colorScheme.onSurface;

    return Drawer(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: SafeArea(
        child: FutureBuilder<_Account>(
          future: _account,
          builder: (context, snapshot) {
            final account = snapshot.data ?? const _Account(loggedIn: false);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 26, 20, 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 21,
                                  backgroundColor: colors.card,
                                  child: Text(
                                    account.loggedIn &&
                                            account.username != null &&
                                            account.username!.isNotEmpty
                                        ? account.username![0].toUpperCase()
                                        : '?',
                                    style: GoogleFonts.spaceMono(
                                      color: colors.muted,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      account.loggedIn
                                          ? account.username ?? 'Signed in'
                                          : 'Guest',
                                      style: GoogleFonts.newsreader(
                                        fontSize: 19,
                                        fontWeight: FontWeight.w600,
                                        color: ink,
                                      ),
                                    ),
                                    Text(
                                      account.loggedIn
                                          ? 'Signed in'
                                          : 'Not signed in',
                                      style: GoogleFonts.spaceMono(
                                        fontSize: 9,
                                        letterSpacing: 0.5,
                                        color: colors.muted,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, size: 18),
                            color: colors.muted,
                            onPressed: () async {
                              Navigator.pop(context);
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const UserScreen(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      if (!account.loggedIn) ...[
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              Navigator.pop(context);
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ),
                              );
                              _refresh();
                            },
                            child: const Text('Log in to report prices'),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Divider(height: 1, color: colors.line),
                _DrawerRow(
                  label: 'Settings',
                  onTap: () => _comingSoon('Settings'),
                ),
                _DrawerRow(
                  label: 'Notifications',
                  onTap: () => _comingSoon('Notifications'),
                ),
                _DrawerRow(
                  label: 'About CoffeeSpy',
                  onTap: () => _comingSoon('About CoffeeSpy'),
                ),
                if (account.loggedIn)
                  _DrawerRow(
                    label: 'Log out',
                    onTap: () async {
                      await AuthService.logout();
                      _refresh();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Logged out')),
                        );
                      }
                    },
                  ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 18,
                  ),
                  decoration: BoxDecoration(
                    border: Border(top: BorderSide(color: colors.line)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Appearance',
                        style: GoogleFonts.hankenGrotesk(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: ink,
                        ),
                      ),
                      const _AppearanceToggle(),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                  child: Text(
                    '◎ CoffeeSpy · v1.0',
                    style: GoogleFonts.spaceMono(
                      fontSize: 9,
                      letterSpacing: 1,
                      color: colors.muted,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _AppearanceToggle extends StatelessWidget {
  const _AppearanceToggle();

  @override
  Widget build(BuildContext context) {
    final colors = context.coffeeColors;
    final controller = context.watch<ThemeController>();
    return Container(
      decoration: BoxDecoration(border: Border.all(color: colors.line)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _SegButton(
            label: '☾ Dark',
            selected: controller.isDark,
            onTap: () => controller.setDark(true),
          ),
          _SegButton(
            label: '☀ Light',
            selected: !controller.isDark,
            onTap: () => controller.setDark(false),
          ),
        ],
      ),
    );
  }
}

class _SegButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _SegButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.coffeeColors;
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
        color: selected ? colors.accent : Colors.transparent,
        child: Text(
          label,
          style: GoogleFonts.spaceMono(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: selected ? colors.accentInk : colors.muted,
          ),
        ),
      ),
    );
  }
}

class _DrawerRow extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _DrawerRow({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = context.coffeeColors;
    final ink = Theme.of(context).colorScheme.onSurface;
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: colors.line)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: GoogleFonts.hankenGrotesk(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: ink,
              ),
            ),
            Icon(Icons.chevron_right, size: 18, color: colors.muted),
          ],
        ),
      ),
    );
  }
}

class _Account {
  final bool loggedIn;
  final String? username;

  const _Account({required this.loggedIn, this.username});
}
