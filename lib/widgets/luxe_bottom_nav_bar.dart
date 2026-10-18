import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/language_provider.dart';
import '../screens/cart_screen.dart';

// =========================================================================
// PIXEL-PERFECT CUSTOM VECTOR DRAWINGS FOR UI ICONS
// =========================================================================

class CustomBasketPainter extends CustomPainter {
  final Color color;
  CustomBasketPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // 1. Trapezoid basket base frame
    final basketPath = Path()
      ..moveTo(size.width * 0.16, size.height * 0.40) // Top left
      ..lineTo(size.width * 0.84, size.height * 0.40) // Top right
      ..lineTo(size.width * 0.73, size.height * 0.90) // Bottom right
      ..lineTo(size.width * 0.27, size.height * 0.90) // Bottom left
      ..close();
    canvas.drawPath(basketPath, paint);

    // 2. Angled straight handles
    canvas.drawLine(
      Offset(size.width * 0.36, size.height * 0.40),
      Offset(size.width * 0.45, size.height * 0.12),
      paint,
    );
    canvas.drawLine(
      Offset(size.width * 0.64, size.height * 0.40),
      Offset(size.width * 0.55, size.height * 0.12),
      paint,
    );

    // 3. Crisp inner center '+' sign
    final plusPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round;

    double centerX = size.width * 0.5;
    double centerY = size.height * 0.65;
    double armLength = 3.5;

    canvas.drawLine(Offset(centerX - armLength, centerY), Offset(centerX + armLength, centerY), plusPaint);
    canvas.drawLine(Offset(centerX, centerY - armLength), Offset(centerX, centerY + armLength), plusPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class CustomProfilePainter extends CustomPainter {
  final Color color;
  CustomProfilePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round;

    // 1. Detached head circle
    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.30), 4.2, paint);

    // 2. Horseshoe curve shoulder base
    final shoulderPath = Path()
      ..moveTo(size.width * 0.22, size.height * 0.85)
      ..cubicTo(
        size.width * 0.26, size.height * 0.54,
        size.width * 0.74, size.height * 0.54,
        size.width * 0.78, size.height * 0.85,
      );
    canvas.drawPath(shoulderPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// =========================================================================
// RENDER COMPONENT
// =========================================================================

class LuxeBottomNavBar extends StatelessWidget {
  final ValueChanged<String> onSearchChanged;

  const LuxeBottomNavBar({
    super.key,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Exact text and stroke hex shade from your screenshots
    const Color customAssetMutedColor = Color(0xFFA5847E);

    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        return Container(
          height: 72,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(36),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF5D4037).withOpacity(0.04),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // --- 1. PIXEL EXACT SEARCH BAR PILL ---
              Expanded(
                child: Container(
                  height: 46,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1E3DE), // Exact warm rosy-cream shade from your image crop
                    borderRadius: BorderRadius.circular(23),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.search_rounded,
                        color: customAssetMutedColor,
                        size: 22,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          onChanged: onSearchChanged,
                          textAlignVertical: TextAlignVertical.center,
                          decoration: InputDecoration(
                            hintText: languageProvider.translate('search_hint'), // Fully dynamically localized hint text
                            hintStyle: const TextStyle(
                              color: customAssetMutedColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Serif', // Elegant serif font style matching your exact text label
                            ),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                          style: const TextStyle(
                            color: customAssetMutedColor,
                            fontSize: 16,
                            fontFamily: 'Serif',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 20),

              // --- 2. THE VECTOR ICONS ROW ---
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // --- BASKET WITH PLUS SIGN ---
                  Consumer<CartProvider>(
                    builder: (context, cart, child) {
                      return Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const CartScreen(),
                                ),
                              );
                            },
                            child: SizedBox(
                              width: 32,
                              height: 32,
                              child: CustomPaint(
                                painter: CustomBasketPainter(color: customAssetMutedColor),
                              ),
                            ),
                          ),
                          if (cart.itemCount > 0)
                            Positioned(
                              right: -4,
                              top: -4,
                              child: Container(
                                padding: const EdgeInsets.all(3),
                                decoration: const BoxDecoration(
                                  color: Color(0xFF8A5A58),
                                  shape: BoxShape.circle,
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 15,
                                  minHeight: 15,
                                ),
                                child: Text(
                                  '${cart.itemCount}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 8,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(width: 24),

                  // --- SMOOTH PROFILE ARCH ---
                  GestureDetector(
                    onTap: () {},
                    child: SizedBox(
                      width: 28,
                      height: 28,
                      child: CustomPaint(
                        painter: CustomProfilePainter(color: customAssetMutedColor),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}