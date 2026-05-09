import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/design_colors.dart';
import '../utils/design_typography.dart';
import '../utils/design_spacing.dart';

class ResultScreen extends StatefulWidget {
  final String barcode;

  const ResultScreen({super.key, required this.barcode});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

// Custom curve for drop-in bounce
class SpringCurve extends Curve {
  const SpringCurve();

  @override
  double transformInternal(double t) {
    // A bouncy spring function
    if (t == 0.0 || t == 1.0) return t;
    return Curves.bounceOut.transform(t);
  }
}

class _ResultScreenState extends State<ResultScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  // Dummy data for design purposes
  final String decisionEmoji = '🟢';
  final String decisionText = 'WORTH IT';
  final String decisionDescription = 'Fits your fiber goal and daily micronutrient needs perfectly';
  final Color decisionBgColor = DesignColors.greenLightBg;
  final Color decisionTextColor = DesignColors.successGreen;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400), // 400ms duration per design
      vsync: this,
    );

    // Custom spring-like bounce curve
    _animation = CurvedAnimation(
      parent: _controller,
      curve: const SpringCurve(),
    );

    // Start animation slightly after the screen appears
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildAlternativeCard(BuildContext context, String title, String brand, String emoji) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignSpacing.radiusCard),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(DesignSpacing.radiusCard),
        onTap: () {
          HapticFeedback.lightImpact();
          // Action to view alternative
        },
        child: Container(
          width: 140,
          padding: const EdgeInsets.all(DesignSpacing.sm),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min, // Fix RenderFlex overflow
            children: [
              Text(emoji, style: const TextStyle(fontSize: 20)),
              const SizedBox(height: 2), // Replaced Spacer
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: DesignColors.getTextColor(context),
                ),
              ),
              Text(
                brand,
                style: TextStyle(
                  fontSize: 10,
                  color: DesignColors.getTextSecondaryColor(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
          tooltip: 'Back',
        ),
        title: const Text('Result'),
        actions: [
          TextButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              Navigator.pop(context);
            },
            child: Text(
              'Scan Again',
              style: TextStyle(
                color: DesignColors.getPrimaryBlue(context),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(DesignSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Slide + Scale animation for drop-in effect
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, 50 * (1 - _animation.value)),
                  child: Transform.scale(
                    scale: 0.8 + (0.2 * _animation.value),
                    child: Opacity(
                      opacity: _animation.value.clamp(0.0, 1.0),
                      child: child,
                    ),
                  ),
                );
              },
              child: Card(
                color: decisionBgColor,
                elevation: 2, // Material 3 elevation 2
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(DesignSpacing.radiusCard),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(DesignSpacing.lg),
                  child: Column(
                    children: [
                      Text(
                        decisionEmoji,
                        style: const TextStyle(fontSize: 64),
                      ),
                      const SizedBox(height: DesignSpacing.sm),
                      Text(
                        decisionText,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: decisionTextColor,
                        ),
                      ),
                      const SizedBox(height: DesignSpacing.sm),
                      Text(
                        decisionDescription,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: DesignColors.getTextSecondaryColor(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: DesignSpacing.lg),
            // Product Info Section
            Text(
              'Skyr High-Protein Yogurt',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: DesignColors.getTextColor(context),
              ),
            ),
            Text(
              'Danone',
              style: TextStyle(
                fontSize: 14,
                color: DesignColors.getTextSecondaryColor(context),
              ),
            ),
            Text(
              '170g (1 cup)',
              style: TextStyle(
                fontSize: 12,
                color: DesignColors.getTextTertiaryColor(context),
              ),
            ),
            const SizedBox(height: DesignSpacing.lg),

            // Key Reasons Section
            Text(
              'Key Reasons',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: DesignColors.getTextColor(context),
              ),
            ),
            const SizedBox(height: DesignSpacing.sm),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.check_circle, color: DesignColors.successGreen, size: 20),
              title: Text(
                'High protein (20g)',
                style: TextStyle(fontSize: 14, color: DesignColors.getTextColor(context)),
              ),
              dense: true,
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.warning, color: DesignColors.warningOrange, size: 20),
              title: Text(
                'Contains dairy (for allergies)',
                style: TextStyle(fontSize: 14, color: DesignColors.getTextColor(context)),
              ),
              dense: true,
            ),

            const SizedBox(height: DesignSpacing.lg),

            // Better Alternatives Section
            Text(
              '🔄 Better matches for your Food Code',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: DesignColors.getTextColor(context),
              ),
            ),
            const SizedBox(height: DesignSpacing.sm),
            SizedBox(
              height: 120, // Height for horizontal scrollable cards
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildAlternativeCard(context, 'Almond Yogurt', 'Silk', '🟢'),
                  const SizedBox(width: DesignSpacing.md),
                  _buildAlternativeCard(context, 'Oat Milk Yogurt', 'Oatly', '🟢'),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(DesignSpacing.md),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: DesignSpacing.xxl, // 48pt
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: DesignColors.getPrimaryBlue(context),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(DesignSpacing.radiusButton),
                      ),
                    ),
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      // Share functionality
                    },
                    icon: const Icon(Icons.ios_share),
                    label: const Text('Share', style: DesignTypography.button),
                  ),
                ),
              ),
              const SizedBox(width: DesignSpacing.md),
              Expanded(
                flex: 1,
                child: SizedBox(
                  height: DesignSpacing.xxl, // 48pt
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: DesignColors.getLightGray(context),
                      foregroundColor: DesignColors.getTextColor(context),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(DesignSpacing.radiusButton),
                      ),
                    ),
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      // Save functionality
                    },
                    icon: const Icon(Icons.bookmark_border),
                    label: const Text('Save', style: DesignTypography.button),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
