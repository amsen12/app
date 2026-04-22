import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/app_provider.dart';
import '../utils/profix_colors.dart';
import '../utils/profix_theme.dart';
import '../utils/profixStyles.dart';

class RequestFormScreen extends StatefulWidget {
  final ServiceType? initialService;
  final VoidCallback onBack;
  final VoidCallback onSubmit;
  const RequestFormScreen({super.key, this.initialService, required this.onBack, required this.onSubmit});

  @override
  State<RequestFormScreen> createState() => _RequestFormScreenState();
}

class _RequestFormScreenState extends State<RequestFormScreen> {
  ServiceType? _selectedService;
  final _descCtrl = TextEditingController();
  bool _locationSelected = false;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _selectedService = widget.initialService;
  }

  @override
  void dispose() { _descCtrl.dispose(); super.dispose(); }

  Future<void> _handleSubmit() async {
    if (_selectedService == null || _descCtrl.text.isEmpty || !_locationSelected) return;
    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;

    final app = context.read<AppProvider>();
    app.addRequest(ServiceRequest(
      id: 'r${DateTime.now().millisecondsSinceEpoch}',
      customerId: app.user?.id ?? 'c1',
      customerName: app.user?.name ?? 'Customer',
      customerPhone: app.user?.phone ?? '+1234567890',
      serviceType: _selectedService!,
      description: _descCtrl.text,
      address: '123 Main Street, Apt 4B',
      location: const LatLng(lat: 40.7128, lng: -74.006),
      status: RequestStatus.pending,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ));

    setState(() => _isSubmitting = false);
    widget.onSubmit();
  }

  @override
  Widget build(BuildContext context) {
    final canSubmit = _selectedService != null && _descCtrl.text.isNotEmpty && _locationSelected && !_isSubmitting;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: widget.onBack),
        title: const Text('New Request', style: TextStyle(fontWeight: FontWeight.w600)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Select Service', style: ProfixStyles.getTextStyle(size: ProfixStyles.textSm + 1, weight: FontWeight.w600)),
            const SizedBox(height: 12),
            Row(
              children: [
                _serviceOption(ServiceType.plumber, '🚰', 'Plumber'),
                const SizedBox(width: 8),
                _serviceOption(ServiceType.carpenter, '🔨', 'Carpenter'),
                const SizedBox(width: 8),
                _serviceOption(ServiceType.electrician, '💡', 'Electrician'),
              ],
            ),
            const SizedBox(height: 24),
            Text('Describe the Problem', style: ProfixStyles.getTextStyle(size: ProfixStyles.textSm + 1, weight: FontWeight.w600)),
            const SizedBox(height: 8),
            TextField(
              controller: _descCtrl,
              maxLines: 4,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(hintText: 'What needs to be fixed? Please provide details...'),
            ),
            const SizedBox(height: 24),
            Text('Service Location', style: ProfixStyles.getTextStyle(size: ProfixStyles.textSm + 1, weight: FontWeight.w600)),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => setState(() => _locationSelected = true),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: _locationSelected ? ProfixColors.primary : Colors.grey.shade300, width: _locationSelected ? 2 : 1),
                  borderRadius: BorderRadius.circular(12),
                  color: _locationSelected ? ProfixColors.primary.withOpacity(0.05) : null,
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: ProfixColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                      child: const Icon(Icons.location_on, color: ProfixColors.primary),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_locationSelected ? 'Location Selected' : 'Select Location', style: ProfixStyles.textBaseBold),
                          Text(_locationSelected ? '123 Main Street, Apt 4B' : 'Tap to choose on map', style: ProfixStyles.textXsRegular.copyWith(color: Colors.grey.shade500)),
                        ],
                      ),
                    ),
                    Icon(_locationSelected ? Icons.check_circle : Icons.keyboard_arrow_down, color: _locationSelected ? ProfixColors.green : Colors.grey),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 120),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton.icon(
            onPressed: canSubmit ? _handleSubmit : null,
            icon: _isSubmitting
                ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Icon(Icons.send),
            label: Text(_isSubmitting ? 'Submitting...' : 'Submit Request', style: ProfixStyles.textBaseBold),
          ),
        ),
      ),
    );
  }

  Widget _serviceOption(ServiceType type, String icon, String label) {
    final isSelected = _selectedService == type;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedService = type),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            border: Border.all(color: isSelected ? ProfixColors.primary : Colors.grey.shade300, width: 2),
            borderRadius: BorderRadius.circular(12),
            color: isSelected ? ProfixColors.primary.withOpacity(0.08) : Colors.white,
          ),
          child: Column(
            children: [
              Text(icon, style: ProfixStyles.text2xlBold),
              const SizedBox(height: 6),
              Text(label, style: ProfixStyles.getTextStyle(size: ProfixStyles.textXs, weight: FontWeight.w600, color: isSelected ? ProfixColors.primary : Colors.grey.shade700)),
            ],
          ),
        ),
      ),
    );
  }
}