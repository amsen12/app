import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/models.dart';
import '../providers/app_provider.dart';
import '../widgets/shared_widgets.dart';
import '../utils/profix_colors.dart';
import '../utils/profix_theme.dart';
import '../utils/profixStyles.dart';
import 'chat_screen.dart';

class RequestTrackingScreen extends StatefulWidget {
  final String requestId;
  final VoidCallback onBack;
  const RequestTrackingScreen({super.key, required this.requestId, required this.onBack});

  @override
  State<RequestTrackingScreen> createState() => _RequestTrackingScreenState();
}

class _RequestTrackingScreenState extends State<RequestTrackingScreen> {
  double _rating = 0;
  final _reviewCtrl = TextEditingController();
  bool _isSubmittingReview = false;

  static const _icons = {ServiceType.plumber: '🚰', ServiceType.carpenter: '🔨', ServiceType.electrician: '💡'};
  static const _names = {ServiceType.plumber: 'Plumber', ServiceType.carpenter: 'Carpenter', ServiceType.electrician: 'Electrician'};

  @override
  void dispose() { _reviewCtrl.dispose(); super.dispose(); }

  Future<void> _submitReview(AppProvider app) async {
    if (_rating == 0) return;
    setState(() => _isSubmittingReview = true);
    await Future.delayed(const Duration(seconds: 1));
    app.updateRequest(widget.requestId, rating: _rating, review: _reviewCtrl.text);
    setState(() => _isSubmittingReview = false);
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final request = app.requests.firstWhere((r) => r.id == widget.requestId);
    final technician = app.technicians.cast<Technician?>().firstWhere((t) => t?.id == request.technicianId, orElse: () => null);

    final steps = [
      (RequestStatus.pending, 'Request Submitted', Icons.access_time_outlined),
      (RequestStatus.inProgress, 'Technician Assigned', Icons.check_circle_outline),
      (RequestStatus.completed, 'Job Completed', Icons.star_outline),
    ];
    final currentIdx = steps.indexWhere((s) => s.$1 == request.status);

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
            // Service Info
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(_icons[request.serviceType]!, style: ProfixStyles.text4xlBold),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${_names[request.serviceType]} Service', style: ProfixStyles.textBaseBold),
                              Text(DateFormat('MMM d, yyyy • h:mm a').format(request.createdAt), style: ProfixStyles.textXsRegular.copyWith(color: Colors.grey.shade500)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 20),
                    Text(request.description, style: TextStyle(color: Colors.grey.shade700)),
                    const SizedBox(height: 8),
                    Row(children: [
                      Icon(Icons.location_on_outlined, size: 14, color: Colors.grey.shade500),
                      const SizedBox(width: 4),
                      Expanded(child: Text(request.address, style: ProfixStyles.textXsRegular.copyWith(color: Colors.grey.shade500))),
                    ]),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Status Timeline
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Status Timeline', style: ProfixStyles.textBaseBold),
                    const SizedBox(height: 16),
                    ...steps.asMap().entries.map((entry) {
                      final i = entry.key;
                      final (_, label, icon) = entry.value;
                      final isCompleted = i < currentIdx || request.status == RequestStatus.completed;
                      final isActive = i == currentIdx && request.status != RequestStatus.rejected;
                      final isPending = i > currentIdx;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Row(
                          children: [
                            Container(
                              width: 36, height: 36,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isCompleted ? ProfixColors.green : isActive ? ProfixColors.primary : Colors.grey.shade200,
                              ),
                              child: Icon(icon, size: 18, color: isPending ? Colors.grey : Colors.white),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(label, style: TextStyle(fontWeight: FontWeight.w600, color: isPending ? Colors.grey : Colors.black87)),
                                if (isActive && request.status == RequestStatus.inProgress)
                                  Text('In progress...', style: ProfixStyles.getTextStyle(size: ProfixStyles.textXs - 1, weight: FontWeight.w400, color: Colors.grey.shade500)),
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Technician Card
            if (technician != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Assigned Technician', style: ProfixStyles.textBaseBold),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 28,
                            backgroundColor: ProfixColors.primary.withOpacity(0.1),
                            child: Text(technician.name[0], style: ProfixStyles.getTextStyle(size: ProfixStyles.textXl, weight: FontWeight.bold, color: ProfixColors.primary)),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(technician.name, style: ProfixStyles.getTextStyle(size: ProfixStyles.textSm + 1, weight: FontWeight.bold)),
                                Row(children: [
                                  const Icon(Icons.star, size: 14, color: ProfixColors.amber),
                                  Text(' ${technician.rating} • ${technician.completedJobs} jobs', style: ProfixStyles.getTextStyle(size: ProfixStyles.textXs + 1, weight: FontWeight.w400, color: Colors.grey.shade500)),
                                ]),
                              ],
                            ),
                          ),
                        ],
                      ),
                      if (request.status == RequestStatus.inProgress) ...[
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(child: OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.phone), label: const Text('Call'))),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ChatScreen(requestId: request.id, otherUserName: technician.name))),
                                icon: const Icon(Icons.chat),
                                label: const Text('Chat'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),

            // Rating
            if (request.status == RequestStatus.completed && request.rating == null) ...[
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text('Rate Your Experience', style: ProfixStyles.textBaseBold),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(5, (i) => IconButton(
                          onPressed: () => setState(() => _rating = i + 1.0),
                          icon: Icon(i < _rating ? Icons.star : Icons.star_border, color: ProfixColors.amber, size: 32),
                        )),
                      ),
                      const SizedBox(height: 8),
                      TextField(controller: _reviewCtrl, maxLines: 3, decoration: const InputDecoration(hintText: 'Share your experience (optional)')),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: _rating == 0 || _isSubmittingReview ? null : () => _submitReview(app),
                        child: Text(_isSubmittingReview ? 'Submitting...' : 'Submit Review'),
                      ),
                    ],
                  ),
                ),
              ),
            ],

            // Review submitted
            if (request.rating != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: ProfixColors.green.withOpacity(0.08), borderRadius: BorderRadius.circular(14), border: Border.all(color: ProfixColors.green.withOpacity(0.3))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(children: [Icon(Icons.check_circle, color: ProfixColors.green, size: 18), SizedBox(width: 8), Text('Review Submitted', style: TextStyle(fontWeight: FontWeight.bold))]),
                    const SizedBox(height: 8),
                    Row(children: List.generate(5, (i) => Icon(i < (request.rating ?? 0) ? Icons.star : Icons.star_border, color: ProfixColors.amber, size: 18))),
                    if (request.review != null && request.review!.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text('"${request.review}"', style: ProfixStyles.getTextStyle(size: ProfixStyles.textXs + 1, weight: FontWeight.w400, color: Colors.grey.shade600).copyWith(fontStyle: FontStyle.italic)),
                    ],
                  ],
                ),
              ),
            ],
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}