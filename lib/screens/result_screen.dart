import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/product.dart';
import '../models/decision.dart';
import '../models/scan_history_entry.dart';
import '../providers/food_code_provider.dart';
import '../providers/scan_history_provider.dart';
import '../services/evaluation_service.dart';
import '../utils/design_colors.dart';
import '../utils/design_typography.dart';
import '../utils/design_spacing.dart';

class ResultScreen extends StatefulWidget {
  final String barcode;
  final Product product;

  const ResultScreen({super.key, required this.barcode, required this.product});

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
  late GradeResult _gradeResult;
  bool _isEvaluating = true;

  @override
  void initState() {
    super.initState();
    _evaluate();

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

  void _evaluate() {
    final foodCode = Provider.of<FoodCodeProvider>(context, listen: false).activeFoodCode;
    if (foodCode != null) {
      final evaluator = EvaluationService();
      _gradeResult = evaluator.evaluateProduct(widget.product, foodCode);
    } else {
      _gradeResult = GradeResult(
        decision: DecisionResult.yellow,
        color: Colors.amber,
        reason: 'Yellow: No Food Code selected.',
      );
    }
    setState(() {
      _isEvaluating = false;
    });
  }

  Future<void> _saveToHistory() async {
    final foodCodeId = Provider.of<FoodCodeProvider>(context, listen: false).activeFoodCode?.id ?? 'unknown';

    final entry = ScanHistoryEntry(
      id: const Uuid().v4(),
      barcode: widget.barcode,
      productName: widget.product.name,
      scannedAt: DateTime.now(),
      decision: _gradeResult.decision,
      mode: DecisionMode.buy,
      foodCodeId: foodCodeId,
      wasSaved: true,
    );

    try {
      await Provider.of<ScanHistoryProvider>(context, listen: false).addScan(entry);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Saved to history!')),
        );
        Navigator.pop(context); // Go back to scan
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving to history: $e')),
        );
      }
    }
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

  String _getEmoji(DecisionResult result) {
    switch (result) {
      case DecisionResult.green:
        return '✓';
      case DecisionResult.yellow:
        return '⚠️';
      case DecisionResult.red:
        return '✗';
    }
  }

  String _getText(DecisionResult result) {
    switch (result) {
      case DecisionResult.green:
        return 'COMPLIANT';
      case DecisionResult.yellow:
        return 'CAUTION';
      case DecisionResult.red:
        return 'AVOID';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isEvaluating) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

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
                color: _gradeResult.color.withOpacity(0.2),
                elevation: 2, // Material 3 elevation 2
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(DesignSpacing.radiusCard),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(DesignSpacing.lg),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _gradeResult.color,
                        ),
                        child: Text(
                          _getEmoji(_gradeResult.decision),
                          style: const TextStyle(fontSize: 48, color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: DesignSpacing.sm),
                      Text(
                        _getText(_gradeResult.decision),
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: _gradeResult.color,
                        ),
                      ),
                      const SizedBox(height: DesignSpacing.sm),
                      Text(
                        _gradeResult.reason,
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
              widget.product.name ?? 'Unknown Product',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: DesignColors.getTextColor(context),
              ),
            ),
            Text(
              widget.product.brand ?? 'Unknown Brand',
              style: TextStyle(
                fontSize: 14,
                color: DesignColors.getTextSecondaryColor(context),
              ),
            ),
            if (widget.product.nutrition?.servingSize != null)
              Text(
                widget.product.nutrition!.servingSize!,
                style: TextStyle(
                  fontSize: 12,
                  color: DesignColors.getTextTertiaryColor(context),
                ),
              ),
            const SizedBox(height: DesignSpacing.lg),

            // Macros
            Text(
              'Nutrition Facts',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: DesignColors.getTextColor(context),
              ),
            ),
            const SizedBox(height: DesignSpacing.sm),
            if (widget.product.nutrition != null) ...[
              Text('Calories: ${widget.product.nutrition!.caloriePerServing ?? widget.product.nutrition!.caloriesPer100g ?? '?'}'),
              Text('Protein: ${widget.product.nutrition!.protein ?? '?'}g'),
              Text('Carbs: ${widget.product.nutrition!.carbs ?? '?'}g'),
              Text('Fat: ${widget.product.nutrition!.fat ?? '?'}g'),
              Text('Sugar: ${widget.product.nutrition!.sugar ?? '?'}g'),
            ] else
              const Text('Nutrition data unavailable.'),

            const SizedBox(height: DesignSpacing.lg),

            // Ingredients
            Text(
              'Ingredients',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: DesignColors.getTextColor(context),
              ),
            ),
            const SizedBox(height: DesignSpacing.sm),
            Text(
              widget.product.ingredients?.join(', ') ?? 'Ingredients data unavailable.',
              style: TextStyle(fontSize: 12, color: DesignColors.getTextColor(context)),
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
                      _saveToHistory();
                    },
                    icon: const Icon(Icons.check),
                    label: const Text('Add to History', style: DesignTypography.button),
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
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.qr_code_scanner),
                    label: const Text('Scan Another', style: DesignTypography.button),
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
