import 'package:flutter/material.dart';
import '../utils/design_colors.dart';
import '../utils/design_spacing.dart';

class ShareCardGenerator extends StatelessWidget {
  const ShareCardGenerator({super.key});

  @override
  Widget build(BuildContext context) {
    // Scaffold allows us to view this as a separate screen, but normally
    // this could be wrapped in a RepaintBoundary to export an image.
    return Scaffold(
      backgroundColor: DesignColors.getBackground(context),
      appBar: AppBar(
        title: const Text('Share Preview'),
      ),
      body: Center(
        child: AspectRatio(
          aspectRatio: 9 / 16,
          child: Container(
            decoration: BoxDecoration(
              color: DesignColors.greenLightBg,
              borderRadius: BorderRadius.circular(DesignSpacing.radiusCard),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(DesignSpacing.xl),
              child: Column(
                children: [
                  const Text(
                    'CalorieCode',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    '🟢',
                    style: TextStyle(fontSize: 80),
                  ),
                  const SizedBox(height: DesignSpacing.md),
                  const Text(
                    'WORTH IT',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: DesignColors.successGreen,
                    ),
                  ),
                  const SizedBox(height: DesignSpacing.sm),
                  Text(
                    'Fits your fiber goal and daily micronutrient needs perfectly',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: DesignColors.getSuccessGreen(context).withOpacity(0.8),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.all(DesignSpacing.md),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(DesignSpacing.radiusButton),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Skyr High-Protein Yogurt',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: DesignColors.getTextColor(context),
                          ),
                        ),
                        Text(
                          'Danone',
                          style: TextStyle(
                            fontSize: 16,
                            color: DesignColors.getTextSecondaryColor(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: DesignSpacing.md),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: DesignSpacing.md, vertical: DesignSpacing.sm),
                    decoration: BoxDecoration(
                      color: DesignColors.getPrimaryBlue(context),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      '🧬 My Code: KETO-VITAL-24',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Spacer(),
                  const Divider(color: Colors.black12),
                  const SizedBox(height: DesignSpacing.sm),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Scan smarter with',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                          ),
                          Text(
                            'CalorieCode',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: DesignColors.getPrimaryBlue(context),
                            ),
                          ),
                        ],
                      ),
                      const Icon(Icons.qr_code_2, size: 40),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
