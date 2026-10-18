import 'package:flutter/material.dart';

class CurrencyProvider extends ChangeNotifier {
  String _currencyCode = 'USD';

  // Approximate rates relative to USD (update with live API in production)
  static const Map<String, double> _rates = {
    'USD': 1.00,
    'EUR': 0.92,
    'GBP': 0.79,
    'ETB': 57.50,
    'AED': 3.67,
    'SAR': 3.75,
  };

  static const Map<String, String> _symbols = {
    'USD': '\$',
    'EUR': '€',
    'GBP': '£',
    'ETB': 'Br',
    'AED': 'د.إ',
    'SAR': '﷼',
  };

  static const Map<String, String> _labels = {
    'USD': 'US Dollar',
    'EUR': 'Euro',
    'GBP': 'British Pound',
    'ETB': 'Ethiopian Birr',
    'AED': 'UAE Dirham',
    'SAR': 'Saudi Riyal',
  };

  String get currencyCode => _currencyCode;
  String get symbol => _symbols[_currencyCode] ?? '\$';
  String get label => _labels[_currencyCode] ?? 'US Dollar';
  List<String> get availableCurrencies => _rates.keys.toList();

  void setCurrency(String code) {
    if (_rates.containsKey(code)) {
      _currencyCode = code;
      notifyListeners();
    }
  }

  /// Convert a USD base price to the current currency.
  double convert(double usdPrice) {
    return usdPrice * (_rates[_currencyCode] ?? 1.0);
  }

  /// Format a USD price into the current currency string.
  String format(double usdPrice) {
    final converted = convert(usdPrice);

    // For currencies like ETB that get large numbers, no decimals.
    if (_currencyCode == 'ETB') {
      return '$symbol${converted.toStringAsFixed(0)}';
    }

    return '$symbol${converted.toStringAsFixed(2)}';
  }
}
