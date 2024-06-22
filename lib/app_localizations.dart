import 'dart:convert'; // Import the dart:convert library to work with JSON data.
import 'package:flutter/material.dart'; // Import Flutter's material design package.
import 'package:flutter/services.dart'; // Import Flutter's services package to load assets.

class AppLocalizations {
  final Locale? locale; // The locale for which the translations are loaded.
  late Map<String, String> _localizedStrings; // A map to store the loaded localized strings.

  AppLocalizations({required this.locale}); // Constructor to initialize the locale.

  // Method to access the AppLocalizations instance from the context.
  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  // The delegate for AppLocalizations.
  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  // Method to load JSON files containing localized strings.
  Future<void> loadJsonFiles() async {
    try {
      // Load the JSON file for the specified locale.
      final jsonString = await rootBundle.loadString('assets/lang/${locale!.languageCode}.json');
      if (jsonString.isEmpty) {
        return; // If the JSON file is empty, return early.
      }
      // Decode the JSON string into a Map.
      final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
      // Convert the Map to a Map<String, String> and store it in _localizedStrings.
      _localizedStrings = jsonMap.map((key, value) => MapEntry(key, value.toString()));
    } catch (e) {
      // Print an error message if there is an exception.
      print("Error loading JSON file: $e");
      _localizedStrings = {}; // Initialize _localizedStrings to an empty map on error.
    }
  }

  // Method to translate a given key to its localized value.
  String translate(String key) => _localizedStrings[key] ?? 'Translation not found';
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate(); // Constructor for the delegate.

  // Method to check if the locale is supported.
  @override
  bool isSupported(Locale locale) {
    return ['en', 'ar'].contains(locale.languageCode); // Supports English and Arabic.
  }

  // Method to load the AppLocalizations for the specified locale.
  @override
  Future<AppLocalizations> load(Locale locale) async {
    final localizations = AppLocalizations(locale: locale); // Create an instance of AppLocalizations.
    await localizations.loadJsonFiles(); // Load the JSON files for the locale.
    return localizations; // Return the loaded AppLocalizations instance.
  }

  // Method to determine if the localizations should be reloaded.
  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) => false;
}
