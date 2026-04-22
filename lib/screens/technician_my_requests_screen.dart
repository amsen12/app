import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:intl/intl.dart';

import '../models/models.dart';

import '../providers/app_provider.dart';

import '../widgets/shared_widgets.dart';

import '../utils/profix_colors.dart';



class TechnicianMyRequestsScreen extends StatefulWidget {

  final Function(String) onViewRequest;

  const TechnicianMyRequestsScreen({super.key, required this.onViewRequest});



  @override

  State<TechnicianMyRequestsScreen> createState() => _TechnicianMyRequestsScreenState();

}



class _TechnicianMyRequestsScreenState extends State<TechnicianMyRequestsScreen> with SingleTickerProviderStateMixin {

  late TabController _tabCtrl;



  final _tabs = [

    (Icons.access_time, 'Accepted', [RequestStatus.pending]),

    (Icons.build, 'In Progress', [RequestStatus.inProgress]),

    (Icons.check_circle, 'Completed', [RequestStatus.completed]),

    (Icons.cancel, 'Cancelled', [RequestStatus.rejected]),

  ];



  @override

  void initState() {

    super.initState();

    _tabCtrl = TabController(length: _tabs.length, vsync: this);

  }



  @override

  void dispose() { _tabCtrl.dispose(); super.dispose(); }



  String _maskAddress(String address) {

    final parts = address.split(',');

    if (parts.length > 1) return parts.skip(1).join(',').trim();

    return '${address.split(' ').take(2).join(' ')} area';

  }



  static const _icons = {ServiceType.plumber: '🚰', ServiceType.carpenter: '🔨', ServiceType.electrician: '💡'};



  @override

  Widget build(BuildContext context) {

    final app = context.watch<AppProvider>();

    final myReqs = app.myTechnicianRequests;



    return Scaffold(

      appBar: AppBar(

        title: Column(

          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            const Text('My Requests', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),

            Text('${myReqs.length} total request${myReqs.length != 1 ? 's' : ''}', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),

          ],

        ),

        bottom: TabBar(

          controller: _tabCtrl,

          isScrollable: true,

          labelColor: ProfixColors.primary,

          unselectedLabelColor: Colors.grey,

          indicatorColor: ProfixColors.primary,

          tabs: _tabs.map((t) {

            final count = myReqs.where((r) => t.$3.contains(r.status)).length;

            return Tab(

              child: Row(

                children: [

                  Icon(t.$1, size: 16),

                  const SizedBox(width: 4),

                  Text(t.$2),

                  if (count > 0) ...[

                    const SizedBox(width: 4),

                    Container(

                      width: 18, height: 18,

                      decoration: const BoxDecoration(color: ProfixColors.primary, shape: BoxShape.circle),

                      child: Center(child: Text('$count', style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold))),

                    ),

                  ],

                ],

              ),

            );

          }).toList(),

        ),

      ),

      body: TabBarView(

        controller: _tabCtrl,

        children: _tabs.map((t) {

          final filtered = myReqs.where((r) => t.$3.contains(r.status)).toList();

          if (filtered.isEmpty) return EmptyState(icon: t.$1, title: 'No ${t.$2.toLowerCase()} requests');

          return ListView.builder(

            padding: const EdgeInsets.all(16),

            itemCount: filtered.length,

            itemBuilder: (_, i) {

              final req = filtered[i];

              return Padding(

                padding: const EdgeInsets.only(bottom: 12),

                child: Card(

                  child: InkWell(

                    onTap: () => widget.onViewRequest(req.id),

                    borderRadius: BorderRadius.circular(14),

                    child: Padding(

                      padding: const EdgeInsets.all(16),

                      child: Column(

                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [

                          Row(

                            children: [

                              Text(_icons[req.serviceType]!, style: const TextStyle(fontSize: 24)),

                              const SizedBox(width: 10),

                              Expanded(

                                child: Column(

                                  crossAxisAlignment: CrossAxisAlignment.start,

                                  children: [

                                    Text('${req.serviceType.name[0].toUpperCase()}${req.serviceType.name.substring(1)} Service', style: const TextStyle(fontWeight: FontWeight.bold)),

                                    Text(req.description, style: TextStyle(fontSize: 12, color: Colors.grey.shade600), maxLines: 2, overflow: TextOverflow.ellipsis),

                                  ],

                                ),

                              ),

                              StatusBadge(status: req.status),

                            ],

                          ),

                          const SizedBox(height: 10),

                          Row(

                            children: [

                              Icon(Icons.location_on_outlined, size: 14, color: Colors.grey.shade500),

                              const SizedBox(width: 4),

                              Expanded(child: Text(_maskAddress(req.address), style: TextStyle(fontSize: 12, color: Colors.grey.shade500))),

                              Icon(Icons.calendar_today_outlined, size: 13, color: Colors.grey.shade500),

                              const SizedBox(width: 4),

                              Text(DateFormat('MMM d, h:mm a').format(req.createdAt), style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),

                            ],

                          ),

                          const SizedBox(height: 10),

                          Align(

                            alignment: Alignment.centerRight,

                            child: OutlinedButton(onPressed: () => widget.onViewRequest(req.id), child: const Text('View Details')),

                          ),

                        ],

                      ),

                    ),

                  ),

                ),

              );

            },

          );

        }).toList(),

      ),

    );

  }

}