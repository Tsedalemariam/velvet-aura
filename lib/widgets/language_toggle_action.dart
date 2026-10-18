import 'package:flutter/material.dart';
import '../providers/language_provider.dart';

class LanguageToggleAction extends StatelessWidget {
  const LanguageToggleAction({super.key});

  void _showLuxuryLanguageSheet(
    BuildContext context,
    LanguageProvider provider,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFFFBF8F6),
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(35)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Premium top indicator line
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFEADBDB),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                provider.translate('select_lang'),
                style: const TextStyle(
                  fontFamily: 'Serif',
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A3E3E),
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 16),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: provider.supportedLanguages.length,
                  separatorBuilder: (context, index) => const Divider(
                    color: Color(0xFFF3ECE9),
                    height: 1,
                  ),
                  itemBuilder: (context, index) {
                    final lang = provider.supportedLanguages[index];
                    final isSelected = provider.currentLanguage == lang['code'];

                    return InkWell(
                      onTap: () {
                        provider.setLanguage(lang['code']!);
                        Navigator.pop(context);
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 8,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              lang['name']!,
                              style: TextStyle(
                                fontSize: 16,
                                color: isSelected
                                    ? const Color(0xFF8A6262)
                                    : const Color(0xFF4A3E3E),
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.w400,
                              ),
                            ),
                            if (isSelected)
                              const Icon(
                                Icons.check_circle_rounded,
                                color: Color(0xFF8A6262),
                                size: 22,
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = LanguageProvider();

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: IconButton(
        icon: const Icon(
          Icons.language_outlined,
          size: 24,
          color: Color(0xFF8A6262),
        ),
        onPressed: () => _showLuxuryLanguageSheet(context, provider),
      ),
    );
  }
}
