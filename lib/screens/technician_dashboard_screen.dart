import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/app_provider.dart';
import '../widgets/shared_widgets.dart';
import '../theme.dart';

class TechnicianDashboardScreen extends StatefulWidget {
  final Function(String) onViewRequest;
  final Function(String) onChat;
  final VoidCallback onNotifications;
  const TechnicianDashboardScreen({super.key, required this.onViewRequest, required this.onChat, required this.onNotifications});

  @override
  State<TechnicianDashboardScreen> createState() => _TechnicianDashboardScreenState();
}

class _TechnicianDashboardScreenState extends State<TechnicianDashboardScreen> with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() { _tabCtrl.dispose(); super.dispose(); }

  static const _icons = {ServiceType.plumber: '🚰', ServiceType.carpenter: '🔨', ServiceType.electrician: '💡'};

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final newReqs = app.requests.where((r) => r.status == RequestStatus.pending).toList();
    final activeReqs = app.requests.where((r) => r.status == RequestStatus.inProgress).toList();
    final completedReqs = app.requests.where((r) => r.status == RequestStatus.completed).toList();

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (_, __) => [
          SliverToBoxAdapter(child: _buildHeader(context, app, newReqs.length, activeReqs.length, completedReqs.length)),
          SliverPersistentHeader(
            pinned: true,
            delegate: _TabBarDelegate(TabBar(
              controller: _tabCtrl,
              labelColor: AppTheme.primary,
              unselectedLabelColor: Colors.grey,
              indicatorColor: AppTheme.primary,
              tabs: const [
                Tab(icon: Icon(Icons.access_time, size: 18), text: 'New'),
                Tab(icon: Icon(Icons.build, size: 18), text: 'Active'),
                Tab(icon: Icon(Icons.check_circle, size: 18), text: 'Done'),
              ],
            )),
          ),
        ],
        body: TabBarView(
          controller: _tabCtrl,
          children: [
            _buildNewList(context, app, newReqs),
            _buildActiveList(context, app, activeReqs),
            _buildCompletedList(completedReqs),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppProvider app, int newCount, int activeCount, int completedCount) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: AppTheme.success.withOpacity(0.1),
                    child: Text(app.user?.name[0] ?? 'T', style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.success, fontSize: 18)),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Good day', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                      Text(app.user?.name ?? 'Technician', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                ],
              ),
              Stack(
                children: [
                  IconButton(icon: const Icon(Icons.notifications_outlined), onPressed: widget.onNotifications),
                  if (app.unreadNotificationCount > 0)
                    Positioned(
                      right: 6, top: 6,
                      child: Container(
                        width: 18, height: 18,
                        decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                        child: Center(child: Text('${app.unreadNotificationCount}', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold))),
                      ),
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _statCard('$newCount', 'New', AppTheme.warning)),
              const SizedBox(width: 10),
              Expanded(child: _statCard('$activeCount', 'Active', AppTheme.primary)),
              const SizedBox(width: 10),
              Expanded(child: _statCard('$completedCount', 'Done', AppTheme.success)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statCard(String v, String l, Color c) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(color: c.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
    child: Column(
      children: [
        Text(v, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: c)),
        Text(l, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
      ],
    ),
  );

  Widget _buildNewList(BuildContext context, AppProvider app, List<ServiceRequest> reqs) {
    if (reqs.isEmpty) return const EmptyState(icon: Icons.access_time_outlined, title: 'No new requests');
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: reqs.length,
      itemBuilder: (_, i) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(_icons[reqs[i].serviceType]!, style: const TextStyle(fontSize: 28)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(reqs[i].customerName, style: const TextStyle(fontWeight: FontWeight.bold)),
                          Text('${reqs[i].serviceType.name[0].toUpperCase()}${reqs[i].serviceType.name.substring(1)} Service', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                        ],
                      ),
                    ),
                    StatusBadge(status: reqs[i].status),
                  ],
                ),
                const SizedBox(height: 8),
                Text(reqs[i].description, style: TextStyle(color: Colors.grey.shade700, fontSize: 13)),
                const SizedBox(height: 8),
                Row(children: [Icon(Icons.location_on_outlined, size: 14, color: Colors.grey.shade500), const SizedBox(width: 4), Expanded(child: Text(reqs[i].address, style: TextStyle(fontSize: 12, color: Colors.grey.shade500)))]),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: OutlinedButton(
                      onPressed: () => app.updateRequest(reqs[i].id, status: RequestStatus.rejected),
                      style: OutlinedButton.styleFrom(foregroundColor: Colors.red, side: const BorderSide(color: Colors.red)),
                      child: const Text('Reject'),
                    )),
                    const SizedBox(width: 12),
                    Expanded(child: ElevatedButton(
                      onPressed: () => app.updateRequest(reqs[i].id, status: RequestStatus.inProgress, technicianId: app.user?.id, technicianName: app.user?.name),
                      child: const Text('Accept'),
                    )),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActiveList(BuildContext context, AppProvider app, List<ServiceRequest> reqs) {
    if (reqs.isEmpty) return const EmptyState(icon: Icons.build_outlined, title: 'No active jobs');
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: reqs.length,
      itemBuilder: (_, i) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Text(_icons[reqs[i].serviceType]!, style: const TextStyle(fontSize: 28)),
                  const SizedBox(width: 10),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(reqs[i].customerName, style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(reqs[i].description, style: TextStyle(fontSize: 12, color: Colors.grey.shade500), maxLines: 1, overflow: TextOverflow.ellipsis),
                  ])),
                  StatusBadge(status: reqs[i].status),
                ]),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: OutlinedButton(onPressed: () {}, child: const Text('Navigate'))),
                    const SizedBox(width: 8),
                    Expanded(child: OutlinedButton(onPressed: () => widget.onChat(reqs[i].id), child: const Text('Chat'))),
                    const SizedBox(width: 8),
                    Expanded(child: ElevatedButton(
                      onPressed: () => app.updateRequest(reqs[i].id, status: RequestStatus.completed),
                      style: ElevatedButton.styleFrom(backgroundColor: AppTheme.success),
                      child: const Text('Complete'),
                    )),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCompletedList(List<ServiceRequest> reqs) {
    if (reqs.isEmpty) return const EmptyState(icon: Icons.check_circle_outline, title: 'No completed jobs yet');
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: reqs.length,
      itemBuilder: (_, i) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: RequestCard(request: reqs[i], onTap: () => widget.onViewRequest(reqs[i].id)),
      ),
    );
  }
}

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  _TabBarDelegate(this.tabBar);
  @override double get minExtent => tabBar.preferredSize.height;
  @override double get maxExtent => tabBar.preferredSize.height;
  @override Widget build(_, __, ___) => Container(color: Colors.white, child: tabBar);
  @override bool shouldRebuild(_) => false;
}