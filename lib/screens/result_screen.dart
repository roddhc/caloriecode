import 'package:flutter/material.dart';
import 'package:caloriecode/models/decision.dart';

class ResultScreen extends StatefulWidget {
  final String barcode;

  const ResultScreen({super.key, required this.barcode});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _dropAnimation;

  // Placeholder Decision for UI demonstration
  final Decision _mockDecision = Decision(
    productBarcode: '123456789',
    result: DecisionResult.green,
    explanation: 'Compliant with Mediterranean guidelines.',
    reasons: [
      'Low Sugar (2g per serving)',
      'No Banned Ingredients',
      'Whole Grain confirmed'
    ],
    confidence: 0.9,
    foodCodeId: 'mock_code',
    createdAt: DateTime.now(),
    mode: DecisionMode.buy,
  );

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _dropAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.bounceOut,
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Color _getDecisionColor() {
    switch (_mockDecision.result) {
      case DecisionResult.green:
        return Colors.green;
      case DecisionResult.yellow:
        return Colors.amber;
      case DecisionResult.red:
        return Colors.red;
    }
  }

  String _getDecisionEmoji() {
    switch (_mockDecision.result) {
      case DecisionResult.green:
        return '🟢';
      case DecisionResult.yellow:
        return '🟡';
      case DecisionResult.red:
        return '🔴';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Result'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
              ScaleTransition(
                scale: _dropAnimation,
                child: Card(
                  color: _getDecisionColor().withValues(alpha: 0.1),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: _getDecisionColor(), width: 2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        Text(
                          _getDecisionEmoji(),
                          style: const TextStyle(fontSize: 48),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _mockDecision.result.name.toUpperCase(),
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: _getDecisionColor(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _mockDecision.explanation,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Product: Sample Brand Oats',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text('Barcode: ${widget.barcode}'),
              const SizedBox(height: 24),
              const Text(
                'Key Reasons:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ..._mockDecision.reasons.map((reason) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle, color: _getDecisionColor()),
                        const SizedBox(width: 8),
                        Expanded(child: Text(reason)),
                      ],
                    ),
                  )),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.share),
                      label: const Text('Share'),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.bookmark_border),
                      label: const Text('Save'),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
                FilledButton(
                  onPressed: () => Navigator.pop(context),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(56),
                  ),
                  child: const Text('Scan Again'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
