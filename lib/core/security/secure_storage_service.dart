import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static const String _openaiApiKeyKey = 'secure_openai_api_key';
  static const String _geminiApiKeyKey = 'secure_gemini_api_key';

  static SecureStorageService? _instance;
  static SecureStorageService get instance =>
      _instance ?? SecureStorageService._();

  final FlutterSecureStorage _storage;

  SecureStorageService._()
      : _storage = const FlutterSecureStorage(
          aOptions: AndroidOptions(encryptedSharedPreferences: true),
          iOptions: IOSOptions(
            accessibility: KeychainAccessibility.first_unlock,
          ),
          mOptions: MacOsOptions(
            accessibility: KeychainAccessibility.first_unlock,
          ),
        );

  Future<void> saveOpenAIApiKey(String apiKey) =>
      _storage.write(key: _openaiApiKeyKey, value: apiKey);

  Future<String?> getOpenAIApiKey() =>
      _storage.read(key: _openaiApiKeyKey);

  Future<void> deleteOpenAIApiKey() =>
      _storage.delete(key: _openaiApiKeyKey);

  Future<void> saveGeminiApiKey(String apiKey) =>
      _storage.write(key: _geminiApiKeyKey, value: apiKey);

  Future<String?> getGeminiApiKey() =>
      _storage.read(key: _geminiApiKeyKey);

  Future<void> deleteGeminiApiKey() =>
      _storage.delete(key: _geminiApiKeyKey);
}
