import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/models.dart';
import '../providers/app_provider.dart';
import '../widgets/shared_widgets.dart';
import '../theme.dart';

class TechnicianSearchScreen extends StatefulWidget {
  final Function(String) onViewRequest;
  final Function(String) onAcceptRequest;
  const TechnicianSearchScreen({super.key, required this.onViewRequest, required this.onAcceptRequest});

  @override
  State<TechnicianSearchScreen> createState() => _TechnicianSearchScreenState();
}

class _TechnicianSearchScreenState extends State<TechnicianSearchScreen> {
  final _searchCtrl = TextEditingController();
  ServiceType? _category;
  double? _maxDistance;
  bool _showFilters = false;
  String _query = '';

  @override
  void dispose() { _searchCtrl.dispose(); super.dispose(); }

  String _maskAddress(String address) {
    final parts = address.split(',');
    if (parts.length > 1) return '${parts.last.trim()} area';
    return 'Nearby area';
  }

  double _pseudoDistance(ServiceRequest req) {
    final hash = req.id.codeUnits.reduce((a, b) => a + b);
    return (hash % 80) / 10 + 0.5;
  }

  List<ServiceRequest> _filter(List<ServiceRequest> all) {
    return all.where((r) {
      if (r.status != RequestStatus.pending) return false;
      if (r.technicianId != null) return false;
      if (_category != null && r.serviceType != _category) return false;
      if (_maxDistance != null && _pseudoDistance(r) > _maxDistance!) return false;
      if (_query.isNotEmpty) {
        final q = _query.toLowerCase();
        if (!r.description.toLowerCase().contains(q) && !r.serviceType.name.contains(q)) return false;
      }
      return true;
    }).toList();
  }

  static const _catData = [
    (null, '🔧', 'All'),
    (ServiceType.plumber, '🚰', 'Plumbing'),
    (ServiceType.electrician, '💡', 'Electricity'),
    (ServiceType.carpenter, '🔨', 'Carpentry'),
  ];

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final filtered = _filter(app.requests);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Requests', style: TextStyle(fontWeight: FontWeight.w600)),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(_showFilters ? 130 : 96),
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
            child: Column(
              children: [
                // Search bar
                TextField(
                  controller: _searchCtrl,
                  onChanged: (v) => setState(() => _query = v),
                  decoration: InputDecoration(
                    hintText: 'Search by description or service...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.tune, color: _showFilters ? AppTheme.primary : Colors.grey),
                      onPressed: () => setState(() => _showFilters = !_showFilters),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // Category chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _catData.map((c) {
                      final isSelected = _category == c.$1;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: GestureDetector(
                          onTap: () => setState(() => _category = c.$1),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: isSelected ? AppTheme.primary : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: isSelected ? AppTheme.primary : Colors.grey.shade300),
                            ),
                            child: Row(
                              children: [
                                Text(c.$2, style: const TextStyle(fontSize: 14)),
                                const SizedBox(width: 4),
                                Text(c.$3, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: isSelected ? Colors.white : Colors.grey.shade700)),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                // Distance filter
                if (_showFilters) ...[
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _distChip(null, 'Any Distance'),
                        _distChip(2, '< 2 km'),
                        _distChip(5, '< 5 km'),
                        _distChip(10, '< 10 km'),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
      body: filtered.isEmpty
          ? const EmptyState(icon: Icons.search_off, title: 'No matching requests', subtitle: 'Try adjusting your filters')
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: filtered.length + 1,
        itemBuilder: (_, i) {
          if (i == 0) return Padding(padding: const EdgeInsets.only(bottom: 12), child: Text('${filtered.length} request${filtered.length != 1 ? 's' : ''} found', style: TextStyle(fontSize: 13, color: Colors.grey.shade500)));
          final req = filtered[i - 1];
          final dist = _pseudoDistance(req);
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_iconFor(req.serviceType), style: const TextStyle(fontSize: 24)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${req.serviceType.name[0].toUpperCase()}${req.serviceType.name.substring(1)} Service', style: const TextStyle(fontWeight: FontWeight.bold)),
                              Row(children: [
                                Icon(Icons.location_on_outlined, size: 12, color: Colors.grey.shade500),
                                Text(' ${_maskAddress(req.address)} · ${dist.toStringAsFixed(1)} km', style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
                              ]),
                            ],
                          ),
                        ),
                        StatusBadge(status: req.status),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(req.description, style: TextStyle(fontSize: 13, color: Colors.grey.shade700), maxLines: 2, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 8),
                    Row(children: [
                      Icon(Icons.access_time, size: 12, color: Colors.grey.shade500),
                      Text(' ${DateFormat('MMM d, h:mm a').format(req.createdAt)}', style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
                    ]),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: OutlinedButton(onPressed: () => widget.onViewRequest(req.id), child: const Text('View Details'))),
                        const SizedBox(width: 12),
                        Expanded(child: ElevatedButton(onPressed: () => widget.onAcceptRequest(req.id), child: const Text('Accept Request'))),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _distChip(double? val, String label) {
    final isSelected = _maxDistance == val;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: () => setState(() => _maxDistance = val),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.primary : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: isSelected ? AppTheme.primary : Colors.grey.shade300),
          ),
          child: Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: isSelected ? Colors.white : Colors.grey.shade600)),
        ),
      ),
    );
  }

  String _iconFor(ServiceType t) {
    switch (t) { case ServiceType.plumber: return '🚰'; case ServiceType.electrician: return '💡'; case ServiceType.carpenter: return '🔨'; }
  }
}