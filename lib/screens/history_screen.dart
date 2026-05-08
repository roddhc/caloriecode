import 'package:flutter/material.dart';

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
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: SearchBar(
              hintText: 'Search product name...',
              leading: const Icon(Icons.search),
              padding: const MaterialStatePropertyAll<EdgeInsets>(
                EdgeInsets.symmetric(horizontal: 16.0),
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: _filters.map((filter) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FilterChip(
                    label: Text(filter),
                    selected: _selectedFilter == filter,
                    onSelected: (selected) {
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
                itemCount: 10,
                itemBuilder: (context, index) {
                  // Simulate grouping by date
                  if (index == 0) {
                    return _buildDateHeader('Today');
                  } else if (index == 3) {
                    return _buildDateHeader('Yesterday');
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

                  return ListTile(
                    leading: Text(decision, style: const TextStyle(fontSize: 24)),
                    title: Text('Scanned Item $index'),
                    subtitle: Text('Brand Name • ${DateTime.now().hour}:${DateTime.now().minute}'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // Navigate to detail
                    },
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
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }
}
