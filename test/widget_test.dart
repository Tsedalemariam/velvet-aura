import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import '../lib/main.dart';
import '../lib/providers/cart_provider.dart';
import '../lib/providers/currency_provider.dart';
import '../lib/providers/favorites_provider.dart';
import '../lib/providers/language_provider.dart';
import '../lib/providers/theme_provider.dart';

void main() {
  testWidgets('Velvet Aura app builds successfully', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => LanguageProvider()),
          ChangeNotifierProvider(create: (_) => CurrencyProvider()),
          ChangeNotifierProvider(create: (_) => CartProvider()),
          ChangeNotifierProvider(create: (_) => FavoritesProvider()),
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ],
        child: const VelvetAuraApp(),
      ),
    );

    await tester.pump();

    expect(tester.takeException(), isNull);
  });
}
