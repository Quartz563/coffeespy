import 'package:flutter/foundation.dart';

class ThemeController extends ChangeNotifier {
  bool _isDark = true;

  bool get isDark => _isDark;

  void toggleDark() {
    _isDark = !_isDark;
    notifyListeners();
  }

  void setDark(bool value) {
    if (_isDark == value) return;
    _isDark = value;
    notifyListeners();
  }
}
