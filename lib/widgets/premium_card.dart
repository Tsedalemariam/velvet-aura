import 'package:flutter/material.dart';
import '../models/perfume_model.dart';
import '../providers/language_provider.dart';

class PremiumCard extends StatelessWidget {
  final PerfumeModel perfume;
  final VoidCallback onTap;
  final bool useDarkTheme;

  const PremiumCard({
    super.key,
    required this.perfume,
    required this.onTap,
    this.useDarkTheme = false,
  });

  @override
  Widget build(BuildContext context) {
    final provider = LanguageProvider();

    final cardColor = useDarkTheme ? const Color(0xFFB08E8E) : Colors.white;
    final textColor = useDarkTheme ? Colors.white : const Color(0xFF5D4037);
    final subColor = useDarkTheme
        ? Colors.white.withOpacity(0.85)
        : const Color(0xFF8D6E63);

    final String translatedPerfumeName = provider.translate(perfume.name);

    String dynamicVolumeSubtitle = '';
    switch (provider.currentLanguage) {
      case 'am':
        dynamicVolumeSubtitle = '$translatedPerfumeName እሷ 100ML';
        break;
      case 'fr':
        dynamicVolumeSubtitle = '$translatedPerfumeName POUR ELLE 100ML';
        break;
      case 'es':
        dynamicVolumeSubtitle = '$translatedPerfumeName PARA ELLA 100ML';
        break;
      case 'de':
        dynamicVolumeSubtitle = '$translatedPerfumeName FÜR SIE 100ML';
        break;
      case 'it':
        dynamicVolumeSubtitle = '$translatedPerfumeName PER LEI 100ML';
        break;
      case 'ar':
        dynamicVolumeSubtitle = '100ML لها $translatedPerfumeName';
        break;
      default:
        dynamicVolumeSubtitle = '$translatedPerfumeName SHE 100ML';
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 15,
              offset: const Offset(0, 8),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // TOP TITLE
            Text(
              translatedPerfumeName.toUpperCase(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
                color: textColor,
                fontFamily: 'Serif',
              ),
            ),

            // CENTERED PRODUCT IMAGE — wrapped in Hero for tween animation
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SizedBox(
                      width: constraints.maxWidth,
                      height: constraints.maxHeight,
                      child: Center(
                        child: Hero(
                          tag: perfume.id, // matches the tag in PerfumeHeroScreen
                          // Custom flight shuttle: scales the image from card size
                          // up to hero size on push, and back down on pop.
                          flightShuttleBuilder: (
                              BuildContext flightContext,
                              Animation<double> animation,
                              HeroFlightDirection flightDirection,
                              BuildContext fromHeroContext,
                              BuildContext toHeroContext,
                              ) {
                            // Drive a curved scale tween during flight
                            final curved = CurvedAnimation(
                              parent: flightDirection == HeroFlightDirection.push
                                  ? animation
                                  : ReverseAnimation(animation),
                              curve: Curves.easeInOutCubic,
                            );

                            return AnimatedBuilder(
                              animation: curved,
                              builder: (context, child) {
                                // Scale: 1.0 (card) → 1.0 (hero), but we let
                                // Hero handle the rect tween; we add a subtle
                                // overshoot via a bounce-like curve on opacity
                                // and a slight extra scale pop.
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
                                perfume.imageUrl,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(
                                    Icons.shopping_bag_outlined,
                                    color: subColor,
                                    size: 36,
                                  );
                                },
                              ),
                            );
                          },
                          child: OverflowBox(
                            minWidth: 0,
                            maxWidth: constraints.maxWidth * 1.5,
                            minHeight: 0,
                            maxHeight: constraints.maxHeight * 1.35,
                            child: Image.asset(
                              perfume.imageUrl,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.shopping_bag_outlined,
                                  color: subColor,
                                  size: 36,
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // BOTTOM INFO
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  dynamicVolumeSubtitle.toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.3,
                    color: subColor,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${provider.translate('currency')}${perfume.price.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Serif',
                    color: textColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}