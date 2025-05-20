import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../settings_model.dart';

class PreferencesService {
  final _db = FirebaseFirestore.instance;

  Future<void> save(SettingsModel sm) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    await _db.collection('users').doc(uid).set({
      'theme': sm.themeMode.name,
      'language': sm.locale?.languageCode,
    }, SetOptions(merge: true));
  }

  Future<void> loadInto(SettingsModel sm) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    final doc = await _db.collection('users').doc(uid).get();
    if (!doc.exists) return;

    final data = doc.data()!;
    sm.updateThemeMode(_parseTheme(data['theme']));
    sm.updateLocale(_parseLocale(data['language']));
  }

  ThemeMode _parseTheme(String? v) {
    switch (v) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  Locale? _parseLocale(String? v) => v == null ? null : Locale(v);
}
