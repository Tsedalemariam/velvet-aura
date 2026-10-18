import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/perfume_model.dart';
import '../providers/language_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/currency_provider.dart';
import '../widgets/language_toggle_action.dart';
import '../providers/favorites_provider.dart';
import '../providers/theme_provider.dart';
import 'favorites_screen.dart';
import 'cart_screen.dart';

const Map<String, double> kMlMultipliers = {
  '30ml': 0.65,
  '50ml': 1.00,
  '75ml': 1.35,
  '100ml': 1.65,
  '125ml': 1.90,
};

class PerfumeHeroScreen extends StatefulWidget {
  final PerfumeModel perfume;

  const PerfumeHeroScreen({super.key, required this.perfume});

  @override
  State<PerfumeHeroScreen> createState() => _PerfumeHeroScreenState();
}

class _PerfumeHeroScreenState extends State<PerfumeHeroScreen>
    with SingleTickerProviderStateMixin {
  int _activeDotIndex = 0;
  String _selectedMl = '50ml';
  bool _showCurrencyPicker = false;

  late AnimationController _priceAnimController;
  late Animation<double> _priceFadeAnim;

  @override
  void initState() {
    super.initState();
    _priceAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
    _priceFadeAnim = CurvedAnimation(
      parent: _priceAnimController,
      curve: Curves.easeIn,
    );
    _priceAnimController.forward();
  }

  @override
  void dispose() {
    _priceAnimController.dispose();
    super.dispose();
  }

  void _onMlChanged(String ml) {
    setState(() => _selectedMl = ml);
    _priceAnimController.forward(from: 0);
  }

  double _computedPrice(CurrencyProvider currency) {
    final multiplier = kMlMultipliers[_selectedMl] ?? 1.0;
    return currency.convert(widget.perfume.price * multiplier);
  }

  String _formattedPrice(CurrencyProvider currency) {
    final price = _computedPrice(currency);
    if (currency.currencyCode == 'ETB') {
      return '${currency.symbol}${price.toStringAsFixed(0)}';
    }
    return '${currency.symbol}${price.toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final languageProvider = Provider.of<LanguageProvider>(context);
    final currencyProvider = Provider.of<CurrencyProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    final String translatedPerfumeName =
        languageProvider.translate(widget.perfume.name);
    final List<String> images = widget.perfume.imageUrls;

    return Scaffold(
      key: scaffoldKey,
      backgroundColor:
          themeProvider.isDarkMode ? const Color(0xFF1C1A19) : Colors.white,
      drawer: Drawer(
        backgroundColor: themeProvider.isDarkMode
            ? const Color(0xFF2A2625)
            : const Color(0xFFFBF8F6),
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
              leading: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Color(0xFF8D6E63)),
              title: Text(
                languageProvider.translate('back_to_catalog'),
                style: TextStyle(
                    color: themeProvider.isDarkMode
                        ? Colors.white70
                        : const Color(0xFF5D4037)),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading:
                  const Icon(Icons.favorite_rounded, color: Color(0xFF8D6E63)),
              title: Text(
                languageProvider.translate('favourites'),
                style: TextStyle(
                    color: themeProvider.isDarkMode
                        ? Colors.white70
                        : const Color(0xFF5D4037)),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const FavoritesScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.shopping_basket_rounded,
                  color: Color(0xFF8D6E63)),
              title: Text(
                languageProvider.translate('my_cart'),
                style: TextStyle(
                    color: themeProvider.isDarkMode
                        ? Colors.white70
                        : const Color(0xFF5D4037)),
              ),
              trailing: Consumer<CartProvider>(
                builder: (context, cart, _) {
                  return cart.itemCount > 0
                      ? Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: Color(0xFF8A5A58),
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '${cart.itemCount}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      : const SizedBox.shrink();
                },
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CartScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: GestureDetector(
        onTap: () {
          if (_showCurrencyPicker) setState(() => _showCurrencyPicker = false);
        },
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: size.height,
              color: const Color(0xFFB08E8E),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: size.height * 0.15,
              child: Container(
                color: themeProvider.isDarkMode
                    ? const Color(0xFF2A2625)
                    : Colors.white,
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom + 32,
                ),
                alignment: Alignment.bottomCenter,
                child: InkWell(
                  onTap: () {
                    Provider.of<CartProvider>(context, listen: false)
                        .addToBasket(widget.perfume);
                    final mlLabel = _selectedMl;
                    final price = _formattedPrice(currencyProvider);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '${languageProvider.translate(widget.perfume.name)} '
                          '($mlLabel · $price) '
                          '${languageProvider.currentLanguage == 'am' ? 'ወደ ቅርጫት ገብቷል' : 'added to basket.'}',
                        ),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: CustomPaint(
                          painter: CustomBasketPainter(
                              color: themeProvider.isDarkMode
                                  ? Colors.white70
                                  : const Color(0xFF5D4037)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        languageProvider.translate('add_to_basket'),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                          fontSize: 15,
                          color: themeProvider.isDarkMode
                              ? Colors.white70
                              : const Color(0xFF5D4037),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Column(
              children: [
                // ── WHITE CARD (image area) ──────────────────────────────────
                Container(
                  width: double.infinity,
                  height: size.height * 0.63,
                  decoration: BoxDecoration(
                    color: themeProvider.isDarkMode
                        ? const Color(0xFF1C1A19)
                        : Colors.white,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(36),
                      bottomRight: Radius.circular(36),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(36),
                      bottomRight: Radius.circular(36),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                            height: MediaQuery.of(context).padding.top + 60),
                        // ── Perfume name header ──────────────────────────
                        SizedBox(
                          height: 60,
                          child: Stack(
                            alignment: Alignment.center,
                            clipBehavior: Clip.none,
                            children: [
                              Positioned(
                                top: -8,
                                left: 0,
                                right: 0,
                                child: Text(
                                  translatedPerfumeName.toUpperCase(),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  style: TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 3,
                                    fontFamily: 'Serif',
                                    color: themeProvider.isDarkMode
                                        ? Colors.white.withOpacity(0.07)
                                        : const Color(0xFF5D4037)
                                            .withOpacity(0.13),
                                    height: 1.1,
                                  ),
                                ),
                              ),
                              Text(
                                translatedPerfumeName.toUpperCase(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                  color: themeProvider.isDarkMode
                                      ? Colors.white
                                      : const Color(0xFF5D4037),
                                  fontFamily: 'Serif',
                                ),
                              ),
                            ],
                          ),
                        ),
                        // ── Image carousel ───────────────────────────────
                        Expanded(
                          child: GestureDetector(
                            onHorizontalDragEnd: (details) {
                              if (details.primaryVelocity! < -300) {
                                if (_activeDotIndex < images.length - 1) {
                                  setState(() => _activeDotIndex++);
                                }
                              } else if (details.primaryVelocity! > 300) {
                                if (_activeDotIndex > 0) {
                                  setState(() => _activeDotIndex--);
                                }
                              }
                            },
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 350),
                              transitionBuilder: (child, animation) {
                                final isEntering =
                                    child.key == ValueKey(_activeDotIndex);
                                final offsetTween = Tween<Offset>(
                                  begin: Offset(isEntering ? 1.0 : -1.0, 0.0),
                                  end: Offset.zero,
                                );
                                return SlideTransition(
                                  position: offsetTween.animate(animation),
                                  child: child,
                                );
                              },
                              child: Padding(
                                key: ValueKey(_activeDotIndex),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 40.0,
                                  vertical: 12.0,
                                ),
                                // ── Hero wraps the FIRST image only ──────
                                // The tag must match premium_card.dart → perfume.id
                                child: _activeDotIndex == 0
                                    ? Hero(
                                        tag: widget.perfume.id,
                                        // The flight shuttle mirrors the one in
                                        // PremiumCard: scale 0.85 → 1.0 on push,
                                        // 1.0 → 0.85 on pop, via easeInOutCubic.
                                        flightShuttleBuilder: (
                                          BuildContext flightContext,
                                          Animation<double> animation,
                                          HeroFlightDirection flightDirection,
                                          BuildContext fromHeroContext,
                                          BuildContext toHeroContext,
                                        ) {
                                          final curved = CurvedAnimation(
                                            parent: flightDirection ==
                                                    HeroFlightDirection.push
                                                ? animation
                                                : ReverseAnimation(animation),
                                            curve: Curves.easeInOutCubic,
                                          );

                                          return AnimatedBuilder(
                                            animation: curved,
                                            builder: (context, child) {
                                              final scale = Tween<double>(
                                                begin: 0.85,
                                                end: 1.0,
                                              ).evaluate(curved);
                                              return Transform.scale(
                                                scale: scale,
                                                child: child,
                                              );
                                            },
                                            child: Image.asset(
                                              images[0],
                                              fit: BoxFit.contain,
                                              errorBuilder: (_, __, ___) =>
                                                  const Center(
                                                child: Icon(
                                                  Icons
                                                      .image_not_supported_outlined,
                                                  size: 60,
                                                  color: Color(0xFFD7CCC8),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                        child: Image.asset(
                                          images[_activeDotIndex],
                                          fit: BoxFit.contain,
                                          errorBuilder: (_, __, ___) =>
                                              const Center(
                                            child: Icon(
                                              Icons
                                                  .image_not_supported_outlined,
                                              size: 60,
                                              color: Color(0xFFD7CCC8),
                                            ),
                                          ),
                                        ),
                                      )
                                    : Image.asset(
                                        images[_activeDotIndex],
                                        fit: BoxFit.contain,
                                        errorBuilder: (_, __, ___) =>
                                            const Center(
                                          child: Icon(
                                            Icons.image_not_supported_outlined,
                                            size: 60,
                                            color: Color(0xFFD7CCC8),
                                          ),
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        ),
                        // ── Dot indicators ───────────────────────────────
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(images.length, (dotIndex) {
                            final bool isActive = dotIndex == _activeDotIndex;
                            return GestureDetector(
                              onTap: () =>
                                  setState(() => _activeDotIndex = dotIndex),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                height: 6,
                                width: isActive ? 22 : 6,
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 16),
                                decoration: BoxDecoration(
                                  color: isActive
                                      ? const Color(0xFF8D6E63)
                                      : const Color(0xFFD7CCC8),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ),
                // ── MAUVE INFO PANEL ─────────────────────────────────────────
                Container(
                  width: double.infinity,
                  height: size.height * 0.28,
                  decoration: const BoxDecoration(
                    color: Color(0xFFB08E8E),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(36),
                      bottomRight: Radius.circular(36),
                    ),
                  ),
                  padding: const EdgeInsets.fromLTRB(24, 18, 24, 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        translatedPerfumeName.toUpperCase(),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      Text(
                        languageProvider.currentLanguage == 'fr'
                            ? widget.perfume.descriptionFr
                            : languageProvider.currentLanguage == 'am'
                                ? 'ለላቀ የአኗኗር ዘይቤዎ ተብሎ የተዘጋጀ ልዩ የቅንጦት ሽቶ።'
                                : widget.perfume.descriptionEn,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.88),
                          fontSize: 12.5,
                          height: 1.4,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      _MlSelector(
                        selected: _selectedMl,
                        onChanged: _onMlChanged,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          FadeTransition(
                            opacity: _priceFadeAnim,
                            child: Text(
                              _formattedPrice(currencyProvider),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Serif',
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          GestureDetector(
                            onTap: () {
                              setState(() =>
                                  _showCurrencyPicker = !_showCurrencyPicker);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.22),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.5),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    currencyProvider.currencyCode,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Icon(
                                    _showCurrencyPicker
                                        ? Icons.keyboard_arrow_up_rounded
                                        : Icons.keyboard_arrow_down_rounded,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // ── Currency picker overlay ──────────────────────────────────────
            if (_showCurrencyPicker)
              Positioned(
                bottom: size.height * 0.19,
                left: size.width * 0.5 - 85,
                child: GestureDetector(
                  onTap: () {},
                  child: _CurrencyPickerPanel(
                    currentCode: currencyProvider.currencyCode,
                    currencies: currencyProvider.availableCurrencies,
                    onSelected: (code) {
                      currencyProvider.setCurrency(code);
                      _priceAnimController.forward(from: 0);
                      setState(() => _showCurrencyPicker = false);
                    },
                  ),
                ),
              ),
            // ── Top nav bar ─────────────────────────────────────────────────
            Positioned(
              top: MediaQuery.of(context).padding.top + 6,
              left: 8,
              right: 8,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.menu_rounded,
                      color: themeProvider.isDarkMode
                          ? Colors.white70
                          : const Color(0xFF5D4037),
                      size: 30,
                    ),
                    onPressed: () => scaffoldKey.currentState?.openDrawer(),
                  ),
                  Row(
                    children: [
                      Consumer<FavoritesProvider>(
                        builder: (context, favs, _) {
                          final isFav = favs.isFavorite(widget.perfume.id);
                          return IconButton(
                            icon: Icon(
                              isFav
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_border_rounded,
                              color: isFav
                                  ? const Color(0xFF6E3138)
                                  : (themeProvider.isDarkMode
                                      ? Colors.white70
                                      : const Color(0xFF5D4037)),
                              size: 26,
                            ),
                            onPressed: () {
                              favs.toggle(widget.perfume);
                              final bool isNowFav =
                                  favs.isFavorite(widget.perfume.id);
                              String snackbarMessage = '';
                              if (languageProvider.currentLanguage == 'am') {
                                snackbarMessage = isNowFav
                                    ? 'ወደ ምርጫዎች ተጨምሯል::'
                                    : 'ከምርጫዎች ተወግዷል::';
                              } else if (languageProvider.currentLanguage ==
                                  'fr') {
                                snackbarMessage = isNowFav
                                    ? 'Ajouté aux favoris.'
                                    : 'Retiré des favoris.';
                              } else {
                                snackbarMessage = isNowFav
                                    ? 'Added to favourites.'
                                    : 'Removed from favourites.';
                              }
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(snackbarMessage),
                                  duration: const Duration(seconds: 1),
                                ),
                              );
                            },
                          );
                        },
                      ),
                      const SizedBox(width: 4),
                      const LanguageToggleAction(),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MlSelector extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onChanged;

  const _MlSelector({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: kMlMultipliers.keys.map((ml) {
        final isSelected = ml == selected;
        return GestureDetector(
          onTap: () => onChanged(ml),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: isSelected ? Colors.white : Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color:
                    isSelected ? Colors.white : Colors.white.withOpacity(0.35),
                width: 1,
              ),
            ),
            child: Text(
              ml,
              style: TextStyle(
                color: isSelected
                    ? const Color(0xFF8D6E63)
                    : Colors.white.withOpacity(0.85),
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                letterSpacing: 0.3,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class CustomBasketPainter extends CustomPainter {
  final Color color;
  const CustomBasketPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final leftHandle = Offset(size.width * 0.25, size.height * 0.35);
    final rightHandle = Offset(size.width * 0.75, size.height * 0.35);
    final handleRect = Rect.fromPoints(
      Offset(leftHandle.dx, size.height * 0.05),
      Offset(rightHandle.dx, size.height * 0.65),
    );
    canvas.drawArc(handleRect, 3.14, 3.14, false, paint);

    final bodyPath = Path();
    bodyPath.moveTo(size.width * 0.1, size.height * 0.38);
    bodyPath.lineTo(size.width * 0.2, size.height * 0.92);
    bodyPath.lineTo(size.width * 0.8, size.height * 0.92);
    bodyPath.lineTo(size.width * 0.9, size.height * 0.38);
    bodyPath.close();
    canvas.drawPath(bodyPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomBasketPainter oldDelegate) =>
      oldDelegate.color != color;
}

class _CurrencyPickerPanel extends StatelessWidget {
  final String currentCode;
  final List<String> currencies;
  final ValueChanged<String> onSelected;

  const _CurrencyPickerPanel({
    required this.currentCode,
    required this.currencies,
    required this.onSelected,
  });

  static const Map<String, String> _flags = {
    'USD': '🇺🇸',
    'EUR': '🇪🇺',
    'GBP': '🇬🇧',
    'ETB': '🇪🇹',
    'AED': '🇦🇪',
    'SAR': '🇸🇦',
  };

  static const Map<String, String> _labels = {
    'USD': 'US Dollar',
    'EUR': 'Euro',
    'GBP': 'Pound',
    'ETB': 'Birr',
    'AED': 'Dirham',
    'SAR': 'Riyal',
  };

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: 170,
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF6E4A47),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: currencies.map((code) {
            final isActive = code == currentCode;
            return InkWell(
              onTap: () => onSelected(code),
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: isActive
                      ? Colors.white.withOpacity(0.15)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Text(_flags[code] ?? '💱',
                        style: const TextStyle(fontSize: 16)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _labels[code] ?? code,
                        style: TextStyle(
                          color: isActive
                              ? Colors.white
                              : Colors.white.withOpacity(0.75),
                          fontSize: 13,
                          fontWeight:
                              isActive ? FontWeight.w700 : FontWeight.w400,
                        ),
                      ),
                    ),
                    if (isActive)
                      const Icon(Icons.check_rounded,
                          color: Colors.white, size: 15),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
