import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/favorites_provider.dart';
import '../providers/currency_provider.dart';
import '../providers/language_provider.dart';
import 'perfume_hero_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favs = Provider.of<FavoritesProvider>(context);
    final currency = Provider.of<CurrencyProvider>(context);
    final lang = Provider.of<LanguageProvider>(context);
    final items = favs.favorites;

    return Scaffold(
      backgroundColor: const Color(0xFFFBF8F6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Color(0xFF5D4037)),
          onPressed: () => Navigator.pop(context),
        ),
        // FIXED: Dynamically translates based on your localization dictionary
        title: Text(
          lang.translate('favourites').toUpperCase(),
          style: const TextStyle(
            color: Color(0xFF5D4037),
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 3,
            fontFamily: 'Serif',
          ),
        ),
        centerTitle: true,
      ),
      body: items.isEmpty
          ? Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.favorite_border_rounded,
                size: 64, color: Colors.brown.shade200),
            const SizedBox(height: 16),
            Text(
              // FIXED: Added multi-language localized fallbacks for empty states
              lang.currentLanguage == 'am'
                  ? 'ምንም ተወዳጅ የለም።'
                  : lang.currentLanguage == 'fr'
                  ? 'Aucun favori pour le moment.'
                  : 'No favourites yet.',
              style: TextStyle(
                color: Colors.brown.shade300,
                fontSize: 15,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      )
          : GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.72,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final perfume = items[index];
          final price = currency.convert(perfume.price);
          final priceStr = currency.currencyCode == 'ETB'
              ? '${currency.symbol}${price.toStringAsFixed(0)}'
              : '${currency.symbol}${price.toStringAsFixed(2)}';

          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PerfumeHeroScreen(perfume: perfume),
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.brown.withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Image area
                  Expanded(
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(20)),
                          child: Container(
                            color: const Color(0xFFF5EDE8),
                            child: Center(
                              child: Hero(
                                tag: perfume.id,
                                child: Image.asset(
                                  perfume.imageUrls.first,
                                  fit: BoxFit.contain,
                                  errorBuilder: (_, __, ___) =>
                                  const Icon(
                                    Icons.image_not_supported_outlined,
                                    color: Color(0xFFD7CCC8),
                                    size: 48,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Remove from favorites button
                        Positioned(
                          top: 8,
                          right: 8,
                          child: GestureDetector(
                            onTap: () => favs.toggle(perfume),
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.85),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.favorite_rounded,
                                color: Color(0xFF6E3138),
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Info area
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lang.translate(perfume.name).toUpperCase(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                            color: Color(0xFF5D4037),
                            fontFamily: 'Serif',
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          priceStr,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF8D6E63),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}