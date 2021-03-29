import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final bottomNavigationBarProvider =
    ChangeNotifierProvider<BottomNavigationBarModel>(
  (ref) => BottomNavigationBarModel(),
);

class BottomNavigationBarModel extends ChangeNotifier {
  int _currentIndex = 1;
  String? _currentProviderId;
  int get currentIndex => _currentIndex;
  String? get currentProviderId => _currentProviderId;
  set currentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  set currentProviderId(String? providerId) {
    _currentProviderId = providerId;
    notifyListeners();
  }
}
