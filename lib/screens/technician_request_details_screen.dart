import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/models.dart';
import '../providers/app_provider.dart';
import '../widgets/shared_widgets.dart';
import '../theme.dart';
import 'chat_screen.dart';

class TechnicianRequestDetailsScreen extends StatefulWidget {
  final String requestId;
  final VoidCallback onBack;
  const TechnicianRequestDetailsScreen({super.key, required this.requestId, required this.onBack});

  @override
  State<TechnicianRequestDetailsScreen> createState() => _TechnicianRequestDetailsScreenState();
}

class _TechnicianRequestDetailsScreenState extends State<TechnicianRequestDetailsScreen> {
  bool _showChat = false;

  static const _emojiMap = {ServiceType.plumber: '🚰', ServiceType.electrician: '💡', ServiceType.carpenter: '🔨'};

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final request = app.requests.firstWhere((r) => r.id == widget.requestId);
    final messages = app.getMessagesForRequest(widget.requestId);
    final isAccepted = request.status == RequestStatus.inProgress || request.status == RequestStatus.completed || request.status == RequestStatus.rejected;
    final chatEnabled = request.status == RequestStatus.inProgress;
    final chatReadOnly = request.status == RequestStatus.completed || request.status == RequestStatus.rejected;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: widget.onBack),
        title: const Text('Request Details', style: TextStyle(fontWeight: FontWeight.w600)),
        actions: [Padding(padding: const EdgeInsets.only(right: 16), child: StatusBadge(status: request.status))],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Service info
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Text(_emojiMap[request.serviceType]!, style: const TextStyle(fontSize: 32)),
                      const SizedBox(width: 12),
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('${request.serviceType.name[0].toUpperCase()}${request.serviceType.name.substring(1)} Service', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        Text('Request #${request.id}', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                      ]),
                    ]),
                    const Divider(height: 20),
                    _infoRow('Problem Description', request.description),
                    const SizedBox(height: 10),
                    Row(children: [
                      Icon(Icons.location_on_outlined, size: 16, color: Colors.grey.shade500),
                      const SizedBox(width: 6),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('LOCATION', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.grey.shade500)),
                        Text(request.address, style: const TextStyle(fontSize: 14)),
                      ])),
                    ]),
                    const SizedBox(height: 10),
                    Row(children: [
                      Icon(Icons.calendar_today_outlined, size: 16, color: Colors.grey.shade500),
                      const SizedBox(width: 6),
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('DATE & TIME', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.grey.shade500)),
                        Text(DateFormat('MMMM d, yyyy – h:mm a').format(request.createdAt), style: const TextStyle(fontSize: 14)),
                      ]),
                    ]),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Customer info
            if (isAccepted)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(children: [Icon(Icons.person_outline, size: 18), SizedBox(width: 8), Text('Customer Information', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15))]),
                      const SizedBox(height: 12),
                      Row(children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: AppTheme.primary.withOpacity(0.1),
                          child: Text(request.customerName[0], style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primary)),
                        ),
                        const SizedBox(width: 12),
                        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(request.customerName, style: const TextStyle(fontWeight: FontWeight.bold)),
                          Row(children: [Icon(Icons.phone_outlined, size: 14, color: Colors.grey.shade500), const SizedBox(width: 4), Text(request.customerPhone, style: TextStyle(fontSize: 13, color: Colors.grey.shade600))]),
                        ]),
                      ]),
                    ],
                  ),
                ),
              )
            else
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(12)),
                child: Row(children: [
                  Icon(Icons.lock_outline, color: Colors.grey.shade500),
                  const SizedBox(width: 10),
                  Expanded(child: Text('Customer contact details will be visible after accepting the request.', style: TextStyle(fontSize: 13, color: Colors.grey.shade600))),
                ]),
              ),
            const SizedBox(height: 12),

            // Actions
            if (request.status == RequestStatus.pending)
              ElevatedButton.icon(
                onPressed: () => app.updateRequest(widget.requestId, status: RequestStatus.inProgress),
                icon: const Icon(Icons.build),
                label: const Text('Start Work', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
            if (request.status == RequestStatus.inProgress) ...[
              Row(
                children: [
                  Expanded(child: OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.location_on), label: const Text('Navigate'))),
                  const SizedBox(width: 12),
                  Expanded(child: ElevatedButton.icon(
                    onPressed: () => app.updateRequest(widget.requestId, status: RequestStatus.completed),
                    icon: const Icon(Icons.check_circle),
                    label: const Text('Complete'),
                    style: ElevatedButton.styleFrom(backgroundColor: AppTheme.success),
                  )),
                ],
              ),
            ],
            const SizedBox(height: 12),

            // Chat
            Card(
              child: Column(
                children: [
                  InkWell(
                    onTap: () => setState(() => _showChat = !_showChat),
                    borderRadius: BorderRadius.vertical(top: const Radius.circular(14), bottom: Radius.circular(_showChat ? 0 : 14)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          const Icon(Icons.chat_bubble_outline, color: AppTheme.primary),
                          const SizedBox(width: 10),
                          const Text('Chat with Customer', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                          if (messages.isNotEmpty) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(color: AppTheme.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                              child: Text('${messages.length}', style: const TextStyle(fontSize: 12, color: AppTheme.primary, fontWeight: FontWeight.w600)),
                            ),
                          ],
                          const Spacer(),
                          Text(_showChat ? 'Hide' : 'Show', style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
                        ],
                      ),
                    ),
                  ),
                  if (_showChat)
                    Container(
                      decoration: const BoxDecoration(border: Border(top: BorderSide(color: Color(0xFFF0F0F0)))),
                      child: chatEnabled
                          ? ListTile(
                        leading: const Icon(Icons.open_in_new, color: AppTheme.primary),
                        title: const Text('Open Chat', style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.w600)),
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ChatScreen(requestId: widget.requestId, otherUserName: request.customerName))),
                      )
                          : !chatReadOnly
                          ? Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(children: [
                          Icon(Icons.lock_outline, size: 32, color: Colors.grey.shade400),
                          const SizedBox(height: 8),
                          Text('Chat is available after the request is accepted and work begins.', style: TextStyle(fontSize: 13, color: Colors.grey.shade500), textAlign: TextAlign.center),
                        ]),
                      )
                          : Padding(
                        padding: const EdgeInsets.all(14),
                        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                          Icon(Icons.lock_outline, size: 14, color: Colors.grey.shade400),
                          const SizedBox(width: 4),
                          Text('Chat is read-only. This request has been ${request.status.name}.', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                        ]),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(), style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.grey.shade500, letterSpacing: 0.5)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}