import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/app_provider.dart';
import '../widgets/shared_widgets.dart';
import '../theme.dart';

class RequestsPageScreen extends StatefulWidget {
  final Function(String) onSelectRequest;
  final Function(String) onChat;
  const RequestsPageScreen({super.key, required this.onSelectRequest, required this.onChat});

  @override
  State<RequestsPageScreen> createState() => _RequestsPageScreenState();
}

class _RequestsPageScreenState extends State<RequestsPageScreen> {
  RequestStatus? _selectedStatus;

  final _filters = <String, RequestStatus?>{
    'All': null, 'Pending': RequestStatus.pending, 'In Progress': RequestStatus.inProgress,
    'Completed': RequestStatus.completed, 'Rejected': RequestStatus.rejected,
  };

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final filtered = _selectedStatus == null ? app.requests : app.requests.where((r) => r.status == _selectedStatus).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Requests', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Container(
            color: Colors.white,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Row(
                children: _filters.entries.map((e) {
                  final isSelected = _selectedStatus == e.value;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedStatus = e.value),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
                        decoration: BoxDecoration(
                          color: isSelected ? AppTheme.primary : const Color(0xFFE8EDF2),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Text(e.key, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: isSelected ? Colors.white : Colors.grey.shade600)),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
      body: filtered.isEmpty
          ? EmptyState(
        icon: Icons.list_alt_outlined,
        title: 'No requests found',
        subtitle: _selectedStatus == null ? 'Create a new request to get started' : 'Try selecting a different status',
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: filtered.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text('${filtered.length} request${filtered.length != 1 ? 's' : ''}', style: TextStyle(fontSize: 13, color: Colors.grey.shade500)),
            );
          }
          final req = filtered[index - 1];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: RequestCard(
              request: req,
              onTap: () => widget.onSelectRequest(req.id),
              showChat: req.status == RequestStatus.inProgress,
              onChatTap: () => widget.onChat(req.id),
            ),
          );
        },
      ),
    );
  }
}