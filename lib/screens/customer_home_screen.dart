import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/app_provider.dart';
import '../widgets/shared_widgets.dart';
import '../theme.dart';

class CustomerHomeScreen extends StatelessWidget {
  final VoidCallback onNewRequest;
  final Function(ServiceType) onSelectService;
  final Function(String) onViewTechnician;
  final Function(String) onViewRequest;
  final Function(String) onChat;
  final VoidCallback onNotifications;

  const CustomerHomeScreen({
    super.key,
    required this.onNewRequest,
    required this.onSelectService,
    required this.onViewTechnician,
    required this.onViewRequest,
    required this.onChat,
    required this.onNotifications,
  });

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildHeader(context, app)),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Services
                  const SectionHeader(title: 'Services'),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: ServiceCard(type: ServiceType.plumber, onTap: () => onSelectService(ServiceType.plumber))),
                      const SizedBox(width: 10),
                      Expanded(child: ServiceCard(type: ServiceType.carpenter, onTap: () => onSelectService(ServiceType.carpenter))),
                      const SizedBox(width: 10),
                      Expanded(child: ServiceCard(type: ServiceType.electrician, onTap: () => onSelectService(ServiceType.electrician))),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Recommended
                  SectionHeader(title: 'Recommended for You', actionLabel: 'View All', onAction: () {}),
                  const SizedBox(height: 12),
                  ...app.recommendedTechnicians.map((t) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: TechnicianCard(technician: t, compact: true, onTap: () => onViewTechnician(t.id)),
                  )),

                  // Active Requests
                  if (app.activeRequests.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    SectionHeader(title: 'Active Requests', actionLabel: 'See All', onAction: () {}),
                    const SizedBox(height: 12),
                    ...app.activeRequests.take(2).map((r) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: RequestCard(
                        request: r,
                        onTap: () => onViewRequest(r.id),
                        showChat: r.status == RequestStatus.inProgress,
                        onChatTap: () => onChat(r.id),
                      ),
                    )),
                  ],
                  const SizedBox(height: 80),
                ]),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onNewRequest,
        backgroundColor: AppTheme.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppProvider app) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: AppTheme.primary.withOpacity(0.1),
                    child: Text(app.user?.name[0] ?? 'G', style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primary, fontSize: 18)),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Welcome back', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                      Text(app.user?.name ?? 'Guest', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                ],
              ),
              Stack(
                children: [
                  IconButton(icon: const Icon(Icons.notifications_outlined), onPressed: onNotifications),
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
              Expanded(child: _statCard('${app.activeRequests.length}', 'Active Requests', AppTheme.primary)),
              const SizedBox(width: 12),
              Expanded(child: _statCard('${app.completedCount}', 'Completed', AppTheme.success)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statCard(String value, String label, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(14)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: color)),
          Text(label, style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
        ],
      ),
    );
  }
}