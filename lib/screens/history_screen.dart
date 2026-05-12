import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/design_colors.dart';
import '../utils/design_spacing.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', '🟢', '🟡', '🔴'];

  Future<void> _handleRefresh() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Scans'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: DesignSpacing.md, vertical: DesignSpacing.sm),
            child: SearchBar(
              hintText: 'Search product name...',
              leading: const Icon(Icons.search),
              padding: const MaterialStatePropertyAll<EdgeInsets>(
                EdgeInsets.symmetric(horizontal: DesignSpacing.md),
              ),
              onTap: () {
                // Focus search logic
              },
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Stats Banner
          InkWell(
            onTap: () {
              HapticFeedback.lightImpact();
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(DesignSpacing.md),
              color: DesignColors.getPrimaryBlue(context).withOpacity(0.1),
              child: Row(
                children: [
                  const Text('📊', style: TextStyle(fontSize: 24)),
                  const SizedBox(width: DesignSpacing.sm),
                  Text(
                    'Your adherence this week: ',
                    style: TextStyle(
                      color: DesignColors.getTextColor(context),
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    '78%',
                    style: TextStyle(
                      color: DesignColors.getPrimaryBlue(context),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.chevron_right,
                    color: DesignColors.getPrimaryBlue(context),
                  ),
                ],
              ),
            ),
          ),

          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
                horizontal: DesignSpacing.md, vertical: DesignSpacing.sm),
            child: Row(
              children: _filters.map((filter) {
                return Padding(
                  padding: const EdgeInsets.only(right: DesignSpacing.sm),
                  child: FilterChip(
                    label: Text(filter),
                    selected: _selectedFilter == filter,
                    selectedColor: DesignColors.getPrimaryBlue(context).withOpacity(0.2),
                    checkmarkColor: DesignColors.getPrimaryBlue(context),
                    onSelected: (selected) {
                      HapticFeedback.lightImpact();
                      setState(() {
                        _selectedFilter = filter;
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _handleRefresh,
              child: ListView.builder(
                itemCount: 15,
                itemBuilder: (context, index) {
                  // Simulate grouping by date
                  if (index == 0) {
                    return _buildDateHeader('Today');
                  } else if (index == 4) {
                    return _buildDateHeader('Yesterday');
                  } else if (index == 8) {
                    return _buildDateHeader('Last 7 days');
                  }

                  final decision = index % 3 == 0
                      ? '🔴'
                      : index % 2 == 0
                          ? '🟡'
                          : '🟢';

                  // Basic filtering simulation
                  if (_selectedFilter != 'All' && decision != _selectedFilter) {
                    return const SizedBox.shrink();
                  }

                  return Dismissible(
                    key: Key('item_$index'),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: DesignSpacing.lg),
                      color: DesignColors.dangerRed,
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed: (direction) {
                      // Handle delete
                    },
                    child: InkWell(
                      onTap: () {
                        HapticFeedback.lightImpact();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: DesignSpacing.md, vertical: DesignSpacing.sm),
                        child: Row(
                          children: [
                            // Thumbnail
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: DesignColors.getLightGray(context),
                                borderRadius: BorderRadius.circular(DesignSpacing.radiusButton),
                              ),
                              child: Icon(
                                Icons.image,
                                color: DesignColors.getTextTertiaryColor(context),
                              ),
                            ),
                            const SizedBox(width: DesignSpacing.md),
                            // Details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Scanned Product $index',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: DesignColors.getTextColor(context),
                                    ),
                                  ),
                                  Text(
                                    'Brand Name',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: DesignColors.getTextSecondaryColor(context),
                                    ),
                                  ),
                                  Text(
                                    '${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: DesignColors.getTextTertiaryColor(context),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Decision
                            Text(decision, style: const TextStyle(fontSize: 24)),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          DesignSpacing.md, DesignSpacing.lg, DesignSpacing.md, DesignSpacing.sm),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: DesignColors.getTextSecondaryColor(context),
        ),
      ),
    );
  }
}
