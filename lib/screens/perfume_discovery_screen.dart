import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import '../core/perfume_data.dart';
import '../models/perfume_model.dart';
import '../providers/language_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/favorites_provider.dart';
import '../widgets/premium_card.dart';
import '../widgets/luxe_bottom_nav_bar.dart';
import '../widgets/language_toggle_action.dart';
import 'perfume_hero_screen.dart';
import 'cart_screen.dart';
import 'favorites_screen.dart';

// ==========================================
// AMBIENT BACKGROUND SYSTEM
// ==========================================
class AmbientParticle {
  double xPct;
  double yPct;
  double radius;
  double opacity;
  double speed;
  double angle;

  AmbientParticle({
    required this.xPct,
    required this.yPct,
    required this.radius,
    required this.opacity,
    required this.speed,
    required this.angle,
  });
}

class AmbientBackground extends StatefulWidget {
  const AmbientBackground({super.key});

  @override
  State<AmbientBackground> createState() => _AmbientBackgroundState();
}

class _AmbientBackgroundState extends State<AmbientBackground> with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  final List<AmbientParticle> _particles = [];
  final int _particleCount = 10;
  final math.Random _random = math.Random();
  Duration _lastElapsed = Duration.zero;

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < _particleCount; i++) {
      _particles.add(AmbientParticle(
        xPct: _random.nextDouble(),
        yPct: _random.nextDouble(),
        radius: _random.nextDouble() * 30 + 20,
        opacity: _random.nextDouble() * 0.20 + 0.10,
        speed: _random.nextDouble() * 0.015 + 0.008,
        angle: _random.nextDouble() * math.pi * 2,
      ));
    }

    _ticker = createTicker((elapsed) {
      if (_lastElapsed == Duration.zero) {
        _lastElapsed = elapsed;
        return;
      }

      final double dt = (elapsed.inMicroseconds - _lastElapsed.inMicroseconds) / 1000000.0;
      _lastElapsed = elapsed;

      setState(() {
        for (var p in _particles) {
          p.xPct += math.cos(p.angle) * p.speed * dt;
          p.yPct += math.sin(p.angle) * p.speed * dt;

          if (_random.nextDouble() < 0.01) {
            p.angle += (_random.nextDouble() - 0.5) * 0.4;
          }

          if (p.xPct < -0.15) p.xPct = 1.15;
          if (p.xPct > 1.15) p.xPct = -0.15;
          if (p.yPct < -0.15) p.yPct = 1.15;
          if (p.yPct > 1.15) p.yPct = -0.15;
        }
      });
    });
    _ticker.start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _AmbientPainter(particles: _particles),
    );
  }
}

class _AmbientPainter extends CustomPainter {
  final List<AmbientParticle> particles;
  _AmbientPainter({required this.particles});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (var p in particles) {
      final center = Offset(p.xPct * size.width, p.yPct * size.height);

      paint.shader = RadialGradient(
        colors: [
          const Color(0xFFE8D7D3).withOpacity(p.opacity),
          const Color(0xFFE8D7D3).withOpacity(0.0),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: p.radius * 2));

      canvas.drawCircle(center, p.radius * 2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _AmbientPainter oldDelegate) => true;
}

class ExactMockupCurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFEFE7E4)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(0, size.height * 0.29);

    path.cubicTo(
      size.width * 0.38, size.height * 0.29,
      size.width * 0.52, size.height * 0.49,
      size.width * 0.72, size.height * 0.95,
    );

    path.lineTo(size.width * 0.72, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ==========================================
// MAIN SCREEN WIDGET
// ==========================================
class PerfumeDiscoveryScreen extends StatefulWidget {
  const PerfumeDiscoveryScreen({super.key});

  @override
  State<PerfumeDiscoveryScreen> createState() => _PerfumeDiscoveryScreenState();
}

class _PerfumeDiscoveryScreenState extends State<PerfumeDiscoveryScreen> {
  int selectedCategoryIndex = 0;
  String searchQuery = '';

  String selectedGenderFilter = 'ALL';
  String selectedFlavorFilter = 'ALL';

  final List<String> genderOptions = ['ALL', 'WOMEN', 'MEN', 'UNISEX'];
  final List<String> flavorOptions = ['ALL', 'WOODY', 'CITRUS', 'FLORAL', 'SWEET'];

  final ScrollController _imagesController = ScrollController();
  final ScrollController _namesController = ScrollController();
  final GlobalKey<ScaffoldState> _discoveryScaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _imagesController.addListener(() {
      if (_imagesController.hasClients && _namesController.hasClients) {
        if (_namesController.offset != _imagesController.offset) {
          _namesController.jumpTo(_imagesController.offset);
        }
      }
    });
  }

  @override
  void dispose() {
    _imagesController.dispose();
    _namesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final size = MediaQuery.of(context).size;

    final double cardItemWidth = size.width * 0.54;

    final List<PerfumeModel> localizedCollection =
    PerfumeData.getLocalizedCollection(languageProvider.currentLanguage);

    final List<String> categoryKeys = ['all'];
    for (var perfume in localizedCollection) {
      if (perfume.brandLine.isNotEmpty) {
        final formattedBrand = perfume.brandLine.toUpperCase();
        if (!categoryKeys.contains(formattedBrand)) {
          categoryKeys.add(formattedBrand);
        }
      }
    }

    if (selectedCategoryIndex >= categoryKeys.length) {
      selectedCategoryIndex = 0;
    }

    final List<PerfumeModel> filteredPerfumes = localizedCollection.where((perfume) {
      final String nameRaw = perfume.name.toLowerCase();
      final String brandKeyRaw = perfume.brandLine.toLowerCase();
      final String brandTranslatedRaw = languageProvider.translate(perfume.brandLine).toLowerCase();

      final String descEnRaw = perfume.descriptionEn.toLowerCase();
      final String descFrRaw = perfume.descriptionFr.toLowerCase();

      bool containsKeyword(String keyword) {
        return nameRaw.contains(keyword) ||
            brandKeyRaw.contains(keyword) ||
            brandTranslatedRaw.contains(keyword) ||
            descEnRaw.contains(keyword) ||
            descFrRaw.contains(keyword);
      }

      final matchesSearch = nameRaw.contains(searchQuery.toLowerCase()) ||
          brandKeyRaw.contains(searchQuery.toLowerCase()) ||
          brandTranslatedRaw.contains(searchQuery.toLowerCase());

      bool matchesBrand = true;
      if (selectedCategoryIndex != 0) {
        final selectedCategoryName = categoryKeys[selectedCategoryIndex].toLowerCase();
        matchesBrand = (brandKeyRaw == selectedCategoryName);
      }

      bool matchesGender = true;
      if (selectedGenderFilter != 'ALL') {
        final genderTarget = selectedGenderFilter.toLowerCase();

        if (genderTarget == 'women') {
          matchesGender = containsKeyword('women') ||
              containsKeyword('femme') ||
              containsKeyword('her') ||
              containsKeyword('female') ||
              containsKeyword('rose');
        } else if (genderTarget == 'men') {
          matchesGender = containsKeyword('men') ||
              containsKeyword('homme') ||
              containsKeyword('him') ||
              containsKeyword('male') ||
              containsKeyword('masculine') ||
              containsKeyword('noir');
        } else if (genderTarget == 'unisex') {
          matchesGender = containsKeyword('unisex') ||
              containsKeyword('shared') ||
              containsKeyword('aura') ||
              (!containsKeyword('men') && !containsKeyword('women') && !containsKeyword('femme') && !containsKeyword('homme'));
        }
      }

      bool matchesFlavor = true;
      if (selectedFlavorFilter != 'ALL') {
        final flavorTarget = selectedFlavorFilter.toLowerCase();

        if (flavorTarget == 'woody') {
          matchesFlavor = containsKeyword('woody') || containsKeyword('wood') ||
              containsKeyword('boisé') || containsKeyword('bois') ||
              containsKeyword('oud') || containsKeyword('cedar') ||
              containsKeyword('sandalwood') || containsKeyword('patchouli');
        } else if (flavorTarget == 'citrus') {
          matchesFlavor = containsKeyword('citrus') || containsKeyword('bergamot') ||
              containsKeyword('lemon') || containsKeyword('fresh') ||
              containsKeyword('agrumes') || containsKeyword('frais') ||
              containsKeyword('mandarin') || containsKeyword('orange');
        } else if (flavorTarget == 'floral') {
          matchesFlavor = containsKeyword('floral') || containsKeyword('flower') ||
              containsKeyword('fleuri') || containsKeyword('fleurs') ||
              containsKeyword('rose') || containsKeyword('jasmine') ||
              containsKeyword('blossom') || containsKeyword('bloom');
        } else if (flavorTarget == 'sweet') {
          matchesFlavor = containsKeyword('sweet') || containsKeyword('vanilla') ||
              containsKeyword('sucré') || containsKeyword('vanille') ||
              containsKeyword('amber') || containsKeyword('honey') ||
              containsKeyword('caramel') || containsKeyword('gourmand');
        }
      }

      return matchesSearch && matchesBrand && matchesGender && matchesFlavor;
    }).toList();

    return ListenableBuilder(
      listenable: Listenable.merge([languageProvider, cartProvider]),
      builder: (context, child) {
        return Scaffold(
          key: _discoveryScaffoldKey,
          backgroundColor: Colors.transparent,
          drawer: Drawer(
            backgroundColor: const Color(0xFFFBF8F6),
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: const BoxDecoration(color: Color(0xFFB08E8E)),
                  child: Center(
                    child: Text(
                      languageProvider.translate('app_name').toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        letterSpacing: 4,
                        fontFamily: 'Serif',
                      ),
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.grid_view_rounded, color: Color(0xFF8D6E63)),
                  title: Text(languageProvider.translate('catalog')),
                  onTap: () => Navigator.pop(context),
                ),
                ListTile(
                  leading: const Icon(Icons.favorite_rounded, color: Color(0xFF8D6E63)),
                  title: Text(languageProvider.translate('favourites')),
                  trailing: favoritesProvider.favorites.isNotEmpty
                      ? Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8D7D3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${favoritesProvider.favorites.length}',
                      style: const TextStyle(
                        color: Color(0xFF6E3138),
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                      : null,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const FavoritesScreen()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.shopping_basket_rounded, color: Color(0xFF8D6E63)),
                  title: Text(languageProvider.translate('my_cart')),
                  trailing: cartProvider.itemCount > 0
                      ? Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Color(0xFF8A5A58),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${cartProvider.itemCount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                      : null,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CartScreen()),
                    );
                  },
                ),
                const Divider(color: Color(0xFFE8D7D3), indent: 16, endIndent: 16, height: 30),
              ],
            ),
          ),
          body: Stack(
            children: [
              Container(
                width: double.infinity,
                height: double.infinity,
                color: const Color(0xFFF2E2DF),
              ),
              const Positioned.fill(
                child: AmbientBackground(),
              ),
              Positioned.fill(
                child: CustomPaint(painter: ExactMockupCurvePainter()),
              ),
              Positioned(
                top: size.height * 0.26,
                left: -size.width * 0.10,
                child: Container(
                  width: size.width * 1.3,
                  height: size.width * 1.3,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Colors.white.withOpacity(0.75),
                        Colors.white.withOpacity(0.30),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                ),
              ),
              SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 110),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            languageProvider.translate('featured'),
                            style: const TextStyle(
                                fontSize: 15,
                                color: Color(0xFFB89A95),
                                letterSpacing: 1.5,
                                fontWeight: FontWeight.w400),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            languageProvider.translate('categories'),
                            style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF6E3138),
                                fontFamily: 'Serif'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 40,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: categoryKeys.length,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemBuilder: (context, index) {
                          final isSelected = index == selectedCategoryIndex;
                          final rawKey = categoryKeys[index];

                          final displayTitle = rawKey == 'all'
                              ? languageProvider.translate('all')
                              : languageProvider.translate(rawKey);

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedCategoryIndex = index;
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isSelected ? const Color(0xFF8A5A58) : Colors.transparent,
                                  width: isSelected ? 1.2 : 0.0,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  displayTitle.toUpperCase(),
                                  style: TextStyle(
                                    color: isSelected ? const Color(0xFF7B4A48) : const Color(0xFFB5A3A0),
                                    fontSize: 12.5,
                                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 45),
                    SizedBox(
                      height: size.height * 0.43,
                      child: filteredPerfumes.isEmpty
                          ? Center(
                        child: Text(
                          languageProvider.translate('no_results'),
                          style: const TextStyle(color: Color(0xFFB89A95), fontStyle: FontStyle.italic),
                        ),
                      )
                          : ListView.builder(
                        controller: _imagesController,
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: filteredPerfumes.length,
                        padding: const EdgeInsets.only(left: 24, right: 24),
                        itemBuilder: (context, index) {
                          final perfume = filteredPerfumes[index];
                          final useDarkCardTheme = index % 2 == 0;

                          return Container(
                            width: cardItemWidth,
                            margin: const EdgeInsets.only(right: 20, top: 2, bottom: 2),
                            child: PremiumCard(
                              perfume: perfume,
                              useDarkTheme: useDarkCardTheme,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PerfumeHeroScreen(perfume: perfume),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 25),
                    SizedBox(
                      height: 100,
                      child: filteredPerfumes.isEmpty
                          ? const SizedBox.shrink()
                          : ListView.builder(
                        controller: _namesController,
                        scrollDirection: Axis.horizontal,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: filteredPerfumes.length,
                        padding: const EdgeInsets.only(left: 24, right: 24),
                        itemBuilder: (context, index) {
                          final perfume = filteredPerfumes[index];
                          final baseRawName = perfume.name.toUpperCase();
                          final List<String> textWords = baseRawName.split(' ');
                          final String formattedMultiLineName = textWords.join('\n');

                          return Container(
                            width: cardItemWidth,
                            margin: const EdgeInsets.only(right: 20),
                            alignment: Alignment.centerLeft,
                            child: Container(
                              width: cardItemWidth * 0.85,
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: const Color(0xFFF4F0EF).withOpacity(0.72),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFFE8D7D3).withOpacity(0.35),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  formattedMultiLineName,
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  style: const TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.6,
                                    color: Color(0xFF6E3138),
                                    fontFamily: 'Serif',
                                    height: 1.15,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 25),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.40),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: const Color(0xFFE8D7D3).withOpacity(0.6)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.tune_rounded, color: Color(0xFF6E3138), size: 18),
                                const SizedBox(width: 8),
                                Text(
                                  languageProvider.translate('boutique_filter').toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF6E3138),
                                    letterSpacing: 1.5,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 18),
                            Text(
                              languageProvider.translate('audience_gender').toUpperCase(),
                              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFFB89A95), letterSpacing: 1.0),
                            ),
                            const SizedBox(height: 8),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
                              child: Row(
                                children: genderOptions.map((gender) {
                                  final isSel = (gender == selectedGenderFilter);
                                  final displayLabel = gender == 'ALL'
                                      ? languageProvider.translate('all')
                                      : languageProvider.translate(gender);

                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedGenderFilter = gender;
                                      });
                                    },
                                    child: AnimatedContainer(
                                      duration: const Duration(milliseconds: 200),
                                      margin: const EdgeInsets.only(right: 8),
                                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: isSel ? const Color(0xFF6E3138) : Colors.white.withOpacity(0.7),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        displayLabel.toUpperCase(),
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: isSel ? FontWeight.w600 : FontWeight.w400,
                                          color: isSel ? Colors.white : const Color(0xFF6E3138),
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                            const SizedBox(height: 18),
                            Text(
                              languageProvider.translate('fragrance_accord').toUpperCase(),
                              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFFB89A95), letterSpacing: 1.0),
                            ),
                            const SizedBox(height: 8),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
                              child: Row(
                                children: flavorOptions.map((flavor) {
                                  final isSel = (flavor == selectedFlavorFilter);
                                  final displayLabel = flavor == 'ALL'
                                      ? languageProvider.translate('all')
                                      : languageProvider.translate(flavor);

                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedFlavorFilter = flavor;
                                      });
                                    },
                                    child: AnimatedContainer(
                                      duration: const Duration(milliseconds: 200),
                                      margin: const EdgeInsets.only(right: 8),
                                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: isSel ? const Color(0xFF8A5A58) : Colors.white.withOpacity(0.7),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        displayLabel.toUpperCase(),
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: isSel ? FontWeight.w600 : FontWeight.w400,
                                          color: isSel ? Colors.white : const Color(0xFF8A5A58),
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 135),
                  ],
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).padding.top + 4,
                left: 12,
                right: 12,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.menu_rounded, color: Color(0xFF98817E), size: 30),
                      onPressed: () => _discoveryScaffoldKey.currentState?.openDrawer(),
                    ),
                    const LanguageToggleAction(),
                  ],
                ),
              ),
              Positioned(
                left: 30,
                right: 30,
                bottom: MediaQuery.of(context).padding.bottom + 24,
                child: LuxeBottomNavBar(
                  onSearchChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
