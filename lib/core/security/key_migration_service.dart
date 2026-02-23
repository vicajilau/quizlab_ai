import 'package:shared_preferences/shared_preferences.dart';
import 'package:quiz_app/core/security/encryption_service.dart';
import 'package:quiz_app/core/security/secure_storage_service.dart';

class KeyMigrationService {
  static const String _migrationFlag =
      'keys_migrated_to_secure_storage_v1';

  static Future<void> migrateIfNeeded() async {
    final prefs = await SharedPreferences.getInstance();
    final alreadyMigrated = prefs.getBool(_migrationFlag) ?? false;
    if (alreadyMigrated) return;

    final secureStorage = SecureStorageService.instance;

    // Migrate OpenAI key
    final encryptedOpenAI = prefs.getString('openai_api_key');
    if (encryptedOpenAI != null && encryptedOpenAI.isNotEmpty) {
      final plainKey = EncryptionService.decrypt(encryptedOpenAI);
      if (plainKey.isNotEmpty) {
        await secureStorage.saveOpenAIApiKey(plainKey);
      }
      await prefs.remove('openai_api_key');
    }

    // Migrate Gemini key
    final encryptedGemini = prefs.getString('gemini_api_key');
    if (encryptedGemini != null && encryptedGemini.isNotEmpty) {
      final plainKey = EncryptionService.decrypt(encryptedGemini);
      if (plainKey.isNotEmpty) {
        await secureStorage.saveGeminiApiKey(plainKey);
      }
      await prefs.remove('gemini_api_key');
    }

    await prefs.setBool(_migrationFlag, true);
  }
}
