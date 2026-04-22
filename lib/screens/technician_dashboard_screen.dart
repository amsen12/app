import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/app_provider.dart';
import '../widgets/shared_widgets.dart';
import '../utils/profix_colors.dart';
import '../utils/profix_theme.dart';
import '../utils/profixStyles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../models/models.dart';
import '../../../../providers/app_provider.dart';
// افترضت وجود هذه الملفات بناءً على الكود السابق
// import '../../../../utils/profix_colors.dart';
// import '../../../../widgets/empty_state.dart';
// import '../../../../widgets/status_badge.dart';
// import '../../../../widgets/request_card.dart';

class TechnicianDashboardScreen extends StatefulWidget {
  final Function(String) onViewRequest;
  final Function(String) onChat;
  final VoidCallback onNotifications;
  const TechnicianDashboardScreen({
    super.key,
    required this.onViewRequest,
    required this.onChat,
    required this.onNotifications
  });

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
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  static const _icons = {
    ServiceType.plumber: '🚰',
    ServiceType.carpenter: '🔨',
    ServiceType.electrician: '💡'
  };

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final theme = Theme.of(context);

    final newReqs = app.requests.where((r) => r.status == RequestStatus.pending).toList();
    final activeReqs = app.requests.where((r) => r.status == RequestStatus.inProgress).toList();
    final completedReqs = app.requests.where((r) => r.status == RequestStatus.completed).toList();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: NestedScrollView(
        headerSliverBuilder: (_, __) => [
          SliverToBoxAdapter(
              child: _buildHeader(context, app, newReqs.length, activeReqs.length, completedReqs.length)
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: _TabBarDelegate(
              TabBar(
                controller: _tabCtrl,
                labelColor: theme.colorScheme.primary,
                unselectedLabelColor: theme.hintColor,
                indicatorColor: theme.colorScheme.primary,
                dividerColor: Colors.transparent, // لجعل الشكل أنظف
                tabs: const [
                  Tab(icon: Icon(Icons.access_time, size: 18), text: 'New'),
                  Tab(icon: Icon(Icons.build, size: 18), text: 'Active'),
                  Tab(icon: Icon(Icons.check_circle, size: 18), text: 'Done'),
                ],
              ),
              backgroundColor: theme.scaffoldBackgroundColor,
            ),
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      color: theme.cardColor, // يتغير حسب الثيم
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
                    backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
                    child: Text(
                        app.user?.name[0].toUpperCase() ?? 'T',
                        style: ProfixStyles.textLgBold.copyWith(color: theme.colorScheme.primary)
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          'Good day',
                          style: ProfixStyles.textXsRegular.copyWith(color: theme.hintColor)
                      ),
                      Text(
                          app.user?.name ?? 'Technician',
                          style: ProfixStyles.textBaseBold
                      ),
                    ],
                  ),
                ],
              ),
              Stack(
                children: [
                  IconButton(
                      icon: Icon(Icons.notifications_outlined, color: theme.iconTheme.color),
                      onPressed: widget.onNotifications
                  ),
                  if (app.unreadNotificationCount > 0)
                    Positioned(
                      right: 6, top: 6,
                      child: Container(
                        width: 18, height: 18,
                        decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                        child: Center(
                            child: Text(
                                '${app.unreadNotificationCount}',
                                style: ProfixStyles.getTextStyle(size: ProfixStyles.textXs - 2, weight: FontWeight.bold, color: Colors.white)
                            )
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              // استخدمت ألوان ثابتة للستاتس لأنها دلالية (أصفر، أزرق، أخضر) لكن بـ Opacity مناسب
              Expanded(child: _statCard('$newCount', 'New', Colors.amber)),
              const SizedBox(width: 10),
              Expanded(child: _statCard('$activeCount', 'Active', theme.colorScheme.primary)),
              const SizedBox(width: 10),
              Expanded(child: _statCard('$completedCount', 'Done', Colors.green)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statCard(String v, String l, Color c) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
          color: c.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20)
      ),
      child: Column(
        children: [
          Text(v, style: ProfixStyles.getTextStyle(size: ProfixStyles.text2xl - 2, weight: FontWeight.bold, color: c)),
          Text(l, style: ProfixStyles.getTextStyle(size: ProfixStyles.textXs - 1, weight: FontWeight.w400, color: theme.hintColor)),
        ],
      ),
    );
  }

  Widget _buildNewList(BuildContext context, AppProvider app, List<ServiceRequest> reqs) {
    final theme = Theme.of(context);
    if (reqs.isEmpty) return const EmptyState(icon: Icons.access_time_outlined, title: 'No new requests');

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: reqs.length,
      itemBuilder: (_, i) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: theme.dividerColor.withValues(alpha: 0.1))
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(_icons[reqs[i].serviceType] ?? '🛠️', style: ProfixStyles.text2xlBold),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(reqs[i].customerName, style: ProfixStyles.textBaseBold),
                          Text(
                              '${reqs[i].serviceType.name[0].toUpperCase()}${reqs[i].serviceType.name.substring(1)} Service',
                              style: ProfixStyles.textXsRegular.copyWith(color: theme.hintColor)
                          ),
                        ],
                      ),
                    ),
                    StatusBadge(status: reqs[i].status),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                    reqs[i].description,
                    style: ProfixStyles.getTextStyle(size: ProfixStyles.textXs + 1, weight: FontWeight.w400, color: theme.textTheme.bodyMedium?.color?.withOpacity(0.8) ?? Colors.grey)
                ),
                const SizedBox(height: 8),
                Row(
                    children: [
                      Icon(Icons.location_on_outlined, size: 14, color: theme.hintColor),
                      const SizedBox(width: 4),
                      Expanded(
                          child: Text(
                              reqs[i].address,
                              style: ProfixStyles.textXsRegular.copyWith(color: theme.hintColor)
                          )
                      )
                    ]
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                        child: OutlinedButton(
                          onPressed: () => app.updateRequest(reqs[i].id, status: RequestStatus.rejected),
                          style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                              side: const BorderSide(color: Colors.red)
                          ),
                          child: const Text('Reject'),
                        )
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                        child: ElevatedButton(
                          onPressed: () => app.updateRequest(
                              reqs[i].id,
                              status: RequestStatus.inProgress,
                              technicianId: app.user?.id,
                              technicianName: app.user?.name
                          ),
                          child: const Text('Accept'),
                        )
                    ),
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
    final theme = Theme.of(context);
    if (reqs.isEmpty) return const EmptyState(icon: Icons.build_outlined, title: 'No active jobs');

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: reqs.length,
      itemBuilder: (_, i) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Text(_icons[reqs[i].serviceType] ?? '🛠️', style: ProfixStyles.text2xlBold),
                  const SizedBox(width: 10),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(reqs[i].customerName, style: ProfixStyles.textBaseBold),
                    Text(
                        reqs[i].description,
                        style: ProfixStyles.textXsRegular.copyWith(color: theme.hintColor),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis
                    ),
                  ])),
                  StatusBadge(status: reqs[i].status),
                ]),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: OutlinedButton(onPressed: () {}, child: const Text('Navigate'))),
                    const SizedBox(width: 8),
                    Expanded(child: OutlinedButton(onPressed: () => widget.onChat(reqs[i].id), child: const Text('Chat'))),
                    const SizedBox(width: 8),
                    Expanded(child: ElevatedButton(
                      onPressed: () => app.updateRequest(reqs[i].id, status: RequestStatus.completed),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
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
  final Color backgroundColor;
  _TabBarDelegate(this.tabBar, {required this.backgroundColor});

  @override double get minExtent => tabBar.preferredSize.height;
  @override double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(_, __, ___) => Container(
      color: backgroundColor,
      child: tabBar
  );

  @override bool shouldRebuild(_TabBarDelegate oldDelegate) {
    return backgroundColor != oldDelegate.backgroundColor;
  }
}