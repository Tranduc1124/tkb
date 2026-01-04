import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  String? _backgroundImagePath;

  String? get backgroundImagePath => _backgroundImagePath;

  ThemeProvider() {
    _loadBackground();
  }

  Future<void> _loadBackground() async {
    final prefs = await SharedPreferences.getInstance();
    _backgroundImagePath = prefs.getString('bg_path');
    notifyListeners();
  }

  Future<void> setBackgroundImage(String path) async {
    _backgroundImagePath = path;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('bg_path', path);
    notifyListeners();
  }

  Future<void> resetBackground() async {
    _backgroundImagePath = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('bg_path');
    notifyListeners();
  }

  ImageProvider? getBackgroundImageProvider() {
    if (_backgroundImagePath == null) return null;
    return FileImage(File(_backgroundImagePath!));
  }
}
