import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Abstract interface for saving and loading property form drafts locally.
abstract class DraftService {
  Future<void> saveDraft(Map<String, dynamic> data);
  Future<Map<String, dynamic>?> loadDraft();
  Future<void> clearDraft();
}

class SharedPreferencesDraftService implements DraftService {
  static const String _draftKey = 'property_create_draft';

  @override
  Future<void> saveDraft(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_draftKey, jsonEncode(data));
  }

  @override
  Future<Map<String, dynamic>?> loadDraft() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_draftKey);
    if (jsonStr != null && jsonStr.isNotEmpty) {
      try {
        return jsonDecode(jsonStr) as Map<String, dynamic>;
      } catch (e) {
        // Ignored, return null if corrupt
      }
    }
    return null;
  }

  @override
  Future<void> clearDraft() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_draftKey);
  }
}
