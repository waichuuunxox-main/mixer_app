import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';
import 'mock_service.dart';

/// Helper to provide an ApiService when an API key is configured,
/// otherwise fall back to MockService.
class ApiHelper {
  static const _apiKeyPref = 'mixzer_api_key';

  /// Save API key to shared preferences
  static Future<void> saveApiKey(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_apiKeyPref, key);
  }

  /// Read stored API key (or empty string)
  static Future<String> readApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_apiKeyPref) ?? '';
  }

  static Future<Object> service() async {
    final key = await readApiKey();
    if (key.isNotEmpty) {
      return ApiService(apiKey: key);
    }
    return MockService();
  }
}
