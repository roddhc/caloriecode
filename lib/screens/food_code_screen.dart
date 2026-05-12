import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/design_colors.dart';
import '../utils/design_spacing.dart';

class FoodCodeScreen extends StatefulWidget {
  const FoodCodeScreen({super.key});

  @override
  State<FoodCodeScreen> createState() => _FoodCodeScreenState();
}

class _FoodCodeScreenState extends State<FoodCodeScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Finish setup
      HapticFeedback.lightImpact();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Food Code activated!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diet Setup'),
        leading: _currentPage > 0
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
              )
            : null,
      ),
      body: Column(
        children: [
          // Linear Progress Indicator
          LinearProgressIndicator(
            value: (_currentPage + 1) / 3,
            backgroundColor: DesignColors.getLightGray(context),
            valueColor: AlwaysStoppedAnimation<Color>(
                DesignColors.getPrimaryBlue(context)),
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(), // Disable swipe
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              children: [
                _buildScreen5a(),
                _buildScreen5b(),
                _buildScreen5c(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(DesignSpacing.md),
          child: SizedBox(
            width: double.infinity,
            height: DesignSpacing.xxl, // 48pt touch target
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: DesignColors.getPrimaryBlue(context),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(DesignSpacing.radiusButton),
                ),
              ),
              onPressed: _nextPage,
              child: Text(
                _currentPage == 2 ? 'Start Using Code' : 'Continue',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Screen 5a: Choose Template
  Widget _buildScreen5a() {
    final templates = [
      {'name': 'Mediterranean', 'desc': 'Heart healthy, rich in olive oil and fish', 'icon': Icons.water_drop, 'color': Colors.orange},
      {'name': 'Low Sugar', 'desc': 'Reduce sugar intake, avoid spikes', 'icon': Icons.bloodtype, 'color': Colors.red},
      {'name': 'PCOS-Friendly', 'desc': 'Balance hormones with low GI foods', 'icon': Icons.female, 'color': Colors.blue},
      {'name': 'Diabetic Safe', 'desc': 'Steady glucose control', 'icon': Icons.medical_services, 'color': Colors.green},
      {'name': 'Whole30', 'desc': 'Reset your metabolism', 'icon': Icons.restaurant, 'color': Colors.purple},
      {'name': 'Low-FODMAP', 'desc': 'Gentle on digestion', 'icon': Icons.spa, 'color': Colors.yellow.shade700},
      {'name': 'Pregnancy-Safe', 'desc': 'Nutrients for two', 'icon': Icons.child_care, 'color': Colors.pink},
      {'name': 'Custom', 'desc': 'Build from scratch', 'icon': Icons.settings, 'color': Colors.grey},
    ];

    return ListView(
      padding: const EdgeInsets.all(DesignSpacing.md),
      children: [
        Text(
          'Which diet fits you best?',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: DesignColors.getTextColor(context),
          ),
        ),
        const SizedBox(height: DesignSpacing.lg),
        ...templates.map((t) => _buildTemplateCard(t)).toList(),
      ],
    );
  }

  int _selectedTemplateIndex = 0;

  Widget _buildTemplateCard(Map<String, dynamic> template) {
    int index = [
      'Mediterranean', 'Low Sugar', 'PCOS-Friendly', 'Diabetic Safe',
      'Whole30', 'Low-FODMAP', 'Pregnancy-Safe', 'Custom'
    ].indexOf(template['name']);

    bool isSelected = _selectedTemplateIndex == index;

    return Padding(
      padding: const EdgeInsets.only(bottom: DesignSpacing.sm),
      child: Card(
        elevation: isSelected ? 2 : 0,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: isSelected
                ? DesignColors.getPrimaryBlue(context)
                : DesignColors.getLightGray(context),
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(DesignSpacing.radiusCard),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(DesignSpacing.radiusCard),
          onTap: () {
            HapticFeedback.lightImpact();
            setState(() {
              _selectedTemplateIndex = index;
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(DesignSpacing.md),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(DesignSpacing.sm),
                  decoration: BoxDecoration(
                    color: (template['color'] as Color).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(template['icon'] as IconData, color: template['color'] as Color),
                ),
                const SizedBox(width: DesignSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        template['name'] as String,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: DesignColors.getTextColor(context),
                        ),
                      ),
                      Text(
                        template['desc'] as String,
                        style: TextStyle(
                          fontSize: 12,
                          color: DesignColors.getTextSecondaryColor(context),
                        ),
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  Icon(Icons.check_circle, color: DesignColors.getPrimaryBlue(context)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  double _sugarValue = 15;
  double _sodiumValue = 600;
  bool _banSeedOils = false;
  bool _banArtificialSweeteners = false;
  bool _banHFCS = false;

  // Screen 5b: Customize Rules
  Widget _buildScreen5b() {
    return ListView(
      padding: const EdgeInsets.all(DesignSpacing.md),
      children: [
        Text(
          'Customize Rules',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: DesignColors.getTextColor(context),
          ),
        ),
        const SizedBox(height: DesignSpacing.lg),

        Text(
          'Max Sugar per serving: ${_sugarValue.round()}g',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        Slider(
          value: _sugarValue,
          min: 0,
          max: 50,
          divisions: 50,
          activeColor: DesignColors.getPrimaryBlue(context),
          onChanged: (value) {
            setState(() {
              _sugarValue = value;
            });
          },
        ),
        const SizedBox(height: DesignSpacing.md),

        Text(
          'Max Sodium per serving: ${_sodiumValue.round()}mg',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        Slider(
          value: _sodiumValue,
          min: 0,
          max: 1000,
          divisions: 20,
          activeColor: DesignColors.getPrimaryBlue(context),
          onChanged: (value) {
            setState(() {
              _sodiumValue = value;
            });
          },
        ),
        const SizedBox(height: DesignSpacing.lg),

        const Text(
          'Ingredient Bans',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: DesignSpacing.sm),
        CheckboxListTile(
          title: const Text('Seed oils'),
          value: _banSeedOils,
          activeColor: DesignColors.getPrimaryBlue(context),
          onChanged: (value) {
            setState(() {
              _banSeedOils = value ?? false;
            });
          },
        ),
        CheckboxListTile(
          title: const Text('Artificial sweeteners'),
          value: _banArtificialSweeteners,
          activeColor: DesignColors.getPrimaryBlue(context),
          onChanged: (value) {
            setState(() {
              _banArtificialSweeteners = value ?? false;
            });
          },
        ),
        CheckboxListTile(
          title: const Text('High fructose corn syrup'),
          value: _banHFCS,
          activeColor: DesignColors.getPrimaryBlue(context),
          onChanged: (value) {
            setState(() {
              _banHFCS = value ?? false;
            });
          },
        ),
      ],
    );
  }

  // Screen 5c: Name Your Code
  Widget _buildScreen5c() {
    return Padding(
      padding: const EdgeInsets.all(DesignSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Name Your Code',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: DesignColors.getTextColor(context),
            ),
          ),
          const SizedBox(height: DesignSpacing.sm),
          Text(
            'Give your diet a name to make it yours.',
            style: TextStyle(
              fontSize: 16,
              color: DesignColors.getTextSecondaryColor(context),
            ),
          ),
          const SizedBox(height: DesignSpacing.lg),
          TextField(
            decoration: InputDecoration(
              labelText: 'Enter code name',
              hintText: 'e.g., Cut Mode, KETO-VITAL-24',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(DesignSpacing.radiusButton),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(DesignSpacing.radiusButton),
                borderSide: BorderSide(
                  color: DesignColors.getPrimaryBlue(context),
                  width: 2,
                ),
              ),
            ),
          ),
          const SizedBox(height: DesignSpacing.md),
          TextField(
            maxLines: 3,
            decoration: InputDecoration(
              labelText: 'Optional description',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(DesignSpacing.radiusButton),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(DesignSpacing.radiusButton),
                borderSide: BorderSide(
                  color: DesignColors.getPrimaryBlue(context),
                  width: 2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
