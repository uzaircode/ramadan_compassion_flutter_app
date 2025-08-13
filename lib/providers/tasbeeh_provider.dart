import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TasbeehProvider extends ChangeNotifier {
  int _count = 0;
  int _target = 33;
  int _totalCount = 0;
  List<int> _presetTargets = [33, 99, 100];

  int get count => _count;
  int get target => _target;
  int get totalCount => _totalCount;
  List<int> get presetTargets => _presetTargets;
  double get progress => _target > 0 ? _count / _target : 0;
  bool get isComplete => _count >= _target;

  TasbeehProvider() {
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    _count = prefs.getInt('tasbeeh_count') ?? 0;
    _target = prefs.getInt('tasbeeh_target') ?? 33;
    _totalCount = prefs.getInt('tasbeeh_total') ?? 0;
    notifyListeners();
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('tasbeeh_count', _count);
    await prefs.setInt('tasbeeh_target', _target);
    await prefs.setInt('tasbeeh_total', _totalCount);
  }

  void increment() {
    if (_count < _target) {
      _count++;
      _totalCount++;
      _saveData();
      notifyListeners();
    }
  }

  void reset() {
    _count = 0;
    _saveData();
    notifyListeners();
  }

  void setTarget(int newTarget) {
    if (newTarget > 0) {
      _target = newTarget;
      if (_count > _target) {
        _count = 0;
      }
      _saveData();
      notifyListeners();
    }
  }

  void setCustomTarget(int customTarget) {
    if (customTarget > 0 && customTarget <= 9999) {
      setTarget(customTarget);
    }
  }

  Future<void> resetAll() async {
    _count = 0;
    _target = 33;
    _totalCount = 0;
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    notifyListeners();
  }
}