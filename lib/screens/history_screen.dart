import 'package:flutter/material.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  String _filter = 'All';

  Future<void> _onRefresh() async {
    // Simulate refresh delay
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SearchBar(
              hintText: 'Search products...',
              leading: const Icon(Icons.search),
              elevation: WidgetStateProperty.all(1.0),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  FilterChip(
                    label: const Text('All'),
                    selected: _filter == 'All',
                    onSelected: (val) => setState(() => _filter = 'All'),
                  ),
                  const SizedBox(width: 8),
                  FilterChip(
                    label: const Text('🟢 Green'),
                    selected: _filter == 'Green',
                    onSelected: (val) => setState(() => _filter = 'Green'),
                  ),
                  const SizedBox(width: 8),
                  FilterChip(
                    label: const Text('🟡 Yellow'),
                    selected: _filter == 'Yellow',
                    onSelected: (val) => setState(() => _filter = 'Yellow'),
                  ),
                  const SizedBox(width: 8),
                  FilterChip(
                    label: const Text('🔴 Red'),
                    selected: _filter == 'Red',
                    onSelected: (val) => setState(() => _filter = 'Red'),
                  ),
                  const SizedBox(width: 16),
                ],
              ),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _onRefresh,
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  // Simulate grouping
                  if (index == 0) {
                    return const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text('Today', style: TextStyle(fontWeight: FontWeight.bold)),
                    );
                  }
                  if (index == 5) {
                    return const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text('Yesterday', style: TextStyle(fontWeight: FontWeight.bold)),
                    );
                  }
                  return ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.green,
                      child: Text('🟢', style: TextStyle(fontSize: 18)),
                    ),
                    title: Text('Sample Product $index'),
                    subtitle: const Text('Mediterranean Code'),
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
}
