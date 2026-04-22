import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../models/technician_model.dart';
import '../providers/app_provider.dart';
import '../widgets/shared_widgets.dart';
import '../utils/profixStyles.dart';
import '../utils/profix_colors.dart';

class CustomerHomeScreen extends StatelessWidget {
  static const String routeName = 'customerHome';
  final VoidCallback onNewRequest;
  final Function(ServiceType) onSelectService;
  final Function(String) onViewTechnician;
  final Function(String) onViewRequest;
  final Function(String) onChat;
  final VoidCallback onNotifications;
  final Function(int)? onChangeTab;

  const CustomerHomeScreen({
    super.key,
    required this.onNewRequest,
    required this.onSelectService,
    required this.onViewTechnician,
    required this.onViewRequest,
    required this.onChat,
    required this.onNotifications,
    this.onChangeTab,
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
                  SectionHeader(title: 'Recommended for You', actionLabel: 'View All', onAction: () {
                      if (onChangeTab != null) {
                        onChangeTab!(1); // Navigate to Search Tab (index 1)
                      }
                    }),
                  const SizedBox(height: 12),
                  ...app.recommendedTechnicians.map((t) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: TechnicianCard(technician: t, compact: true, onTap: () {
                      // Navigate to ProviderProfileScreen with technician data
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProviderProfileScreen(
                            technician: TechnicianModel(
                              id: t.id,
                              name: t.name,
                              image: 'assets/technician1.jpg',
                              specialty: t.profession.name,
                              rating: t.rating,
                              jobsDone: t.completedJobs,
                              distance: t.distance,
                              isAvailable: t.available,
                            ),
                          ),
                        ),
                      );
                    }),
                  )),

                  // Active Requests
                  if (app.activeRequests.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    SectionHeader(title: 'Active Requests', actionLabel: 'See All', onAction: () {
                      if (onChangeTab != null) {
                        onChangeTab!(2); // Navigate to Requests Tab (index 2)
                      }
                    }),
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
        backgroundColor: ProfixColors.primary,
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
                    backgroundColor: ProfixColors.primary.withValues(alpha: 0.1),
                    child: Text(app.user?.name[0] ?? 'G', style: const TextStyle(fontWeight: FontWeight.bold, color: ProfixColors.primary, fontSize: 18)),
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
              Expanded(child: _statCard(context, '${app.activeRequests.length}', 'Active Requests', ProfixColors.primary)),
              const SizedBox(width: 12),
              Expanded(child: _statCard(context, '${app.completedCount}', 'Completed', Colors.green)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statCard(BuildContext context, String value, String label, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(14)),
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

class ProviderProfileScreen extends StatelessWidget {
  final TechnicianModel technician;

  const ProviderProfileScreen({super.key, required this.technician});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header with back button and profile
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, size: 20),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const Spacer(),
                  Hero(
                    tag: 'technician-${technician.id}',
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey.shade300,
                        image: DecorationImage(
                          image: technician.image.startsWith('assets') 
                              ? AssetImage(technician.image) as ImageProvider
                              : NetworkImage(technician.image) as ImageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name and rating
                    Center(
                      child: Column(
                        children: [
                          Text(
                            technician.name,
                            style: ProfixStyles.getTextStyle(
                              size: ProfixStyles.textXl,
                              weight: FontWeight.bold,
                              color: theme.textTheme.bodyLarge?.color ?? Colors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.star, color: Colors.orange, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                '${technician.rating}',
                                style: ProfixStyles.getTextStyle(
                                  size: ProfixStyles.textSm,
                                  weight: FontWeight.w600,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(Icons.location_on, color: Colors.grey.shade500, size: 16),
                              Text(
                                '${technician.distance} km away',
                                style: ProfixStyles.getTextStyle(
                                  size: ProfixStyles.textSm,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Stats Cards
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            context,
                            'Jobs Completed',
                            '${technician.jobsDone}',
                            Icons.work_outlined,
                            Colors.green,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            context,
                            'Rating',
                            '${technician.rating}',
                            Icons.star,
                            Colors.orange,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            context,
                            'Response Time',
                            '1 hour',
                            Icons.access_time,
                            Colors.blue,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Book Now Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: technician.isAvailable
                            ? () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => NewRequestScreen(technician: technician),
                                  ),
                                );
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: technician.isAvailable 
                            ? ProfixColors.primary 
                            : Colors.grey.shade300,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          technician.isAvailable ? 'Book Now' : 'Currently Busy',
                          style: ProfixStyles.getTextStyle(
                            size: ProfixStyles.textBase,
                            weight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // About Section
                    Text(
                      'About',
                      style: ProfixStyles.getTextStyle(
                        size: ProfixStyles.textLg,
                        weight: FontWeight.bold,
                        color: theme.textTheme.bodyLarge?.color ?? Colors.black,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Professional ${technician.specialty} with ${technician.jobsDone} completed jobs. '
                      'Dedicated to providing quality service and customer satisfaction. '
                      'Available for both residential and commercial projects.',
                      style: ProfixStyles.getTextStyle(
                        size: ProfixStyles.textBase,
                        color: Colors.grey.shade600,
                        height: 1.5,
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Services Section
                    Text(
                      'Services Offered',
                      style: ProfixStyles.getTextStyle(
                        size: ProfixStyles.textLg,
                        weight: FontWeight.bold,
                        color: theme.textTheme.bodyLarge?.color ?? Colors.black,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildServiceCard(context, 'Plumbing Installation', 'Complete pipe installation and repair', Icons.plumbing),
                    _buildServiceCard(context, 'Emergency Repair', '24/7 emergency service available', Icons.emergency),
                    _buildServiceCard(context, 'Maintenance', 'Regular maintenance and inspection', Icons.build),
                    
                    const SizedBox(height: 32),
                    
                    // Reviews Section
                    Text(
                      'Reviews',
                      style: ProfixStyles.getTextStyle(
                        size: ProfixStyles.textLg,
                        weight: FontWeight.bold,
                        color: theme.textTheme.bodyLarge?.color ?? Colors.black,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildReviewCard(context, 'John Doe', 'Great service! Very professional and quick.', 5),
                    _buildReviewCard(context, 'Jane Smith', 'Did an excellent job with our plumbing issue.', 4.5),
                    _buildReviewCard(context, 'Mike Wilson', 'Reliable and affordable. Highly recommend!', 5),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: ProfixStyles.getTextStyle(
                    size: ProfixStyles.textSm,
                    weight: FontWeight.w600,
                    color: Colors.grey.shade600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: ProfixStyles.getTextStyle(
              size: ProfixStyles.textLg,
              weight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard(BuildContext context, String title, String description, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: ProfixColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: ProfixColors.primary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: ProfixStyles.getTextStyle(
                    size: ProfixStyles.textBase,
                    weight: FontWeight.w600,
                    color: Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: ProfixStyles.getTextStyle(
                    size: ProfixStyles.textSm,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(BuildContext context, String name, String review, double rating) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey.shade300,
                child: Icon(Icons.person, color: Colors.grey.shade600),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: ProfixStyles.getTextStyle(
                        size: ProfixStyles.textBase,
                        weight: FontWeight.w600,
                        color: Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black,
                      ),
                    ),
                    Row(
                      children: [
                        ...List.generate(5, (index) {
                          return Icon(
                            index < rating.floor() ? Icons.star : Icons.star_border,
                            color: Colors.orange,
                            size: 14,
                          );
                        }),
                        const SizedBox(width: 8),
                        Text(
                          '$rating',
                          style: ProfixStyles.getTextStyle(
                            size: ProfixStyles.textSm,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            review,
            style: ProfixStyles.getTextStyle(
              size: ProfixStyles.textSm,
              color: Colors.grey.shade700,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

}

class NewRequestScreen extends StatefulWidget {
  final TechnicianModel technician;

  const NewRequestScreen({super.key, required this.technician});

  @override
  State<NewRequestScreen> createState() => _NewRequestScreenState();
}

class _NewRequestScreenState extends State<NewRequestScreen> {
  final _descriptionController = TextEditingController();
  final _dateController = TextEditingController();
  String? _selectedTime;
  bool _isFormValid = false;

  @override
  void dispose() {
    _descriptionController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Update form validity
    _isFormValid = _descriptionController.text.isNotEmpty && 
                   _dateController.text.isNotEmpty && 
                   _selectedTime != null;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Booking with ${widget.technician.name}',
          style: ProfixStyles.textBaseBold,
        ),
        backgroundColor: theme.cardColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Booking with ${widget.technician.name}',
              style: ProfixStyles.getTextStyle(
                size: ProfixStyles.textLg,
                weight: FontWeight.bold,
                color: theme.textTheme.bodyLarge?.color ?? Colors.black,
              ),
            ),
            const SizedBox(height: 24),
            // Form fields
            TextField(
              controller: _descriptionController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'Problem Description',
                hintText: 'Describe the issue you need help with...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: theme.dividerColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: theme.colorScheme.primary),
                ),
                filled: true,
                fillColor: theme.cardColor,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _dateController,
              readOnly: true,
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 30)),
                );
                if (date != null) {
                  _dateController.text = '${date.day}/${date.month}/${date.year}';
                }
              },
              decoration: InputDecoration(
                labelText: 'Preferred Date',
                hintText: 'Select a date',
                suffixIcon: const Icon(Icons.calendar_today),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: theme.dividerColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: theme.colorScheme.primary),
                ),
                filled: true,
                fillColor: theme.cardColor,
              ),
            ),
            const SizedBox(height: 16),
            // Time slot selection
            Text(
              'Preferred Time',
              style: ProfixStyles.textSmRegular.copyWith(color: theme.textTheme.bodyLarge?.color ?? Colors.black),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                '9:00 AM', '10:00 AM', '11:00 AM', '2:00 PM', '3:00 PM', '4:00 PM',
              ].map((time) {
                final isSelected = _selectedTime == time;
                return FilterChip(
                  label: Text(time),
                  selected: isSelected,
                  onSelected: (_) {
                    setState(() {
                      _selectedTime = isSelected ? null : time;
                    });
                  },
                  backgroundColor: isSelected ? theme.colorScheme.primary : null,
                  labelStyle: ProfixStyles.textXsRegular.copyWith(
                    color: isSelected ? Colors.white : theme.textTheme.bodyLarge?.color ?? Colors.black,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 32),
            // Confirm button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isFormValid
                    ? () {
                        // Handle booking confirmation
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Booking request sent to ${widget.technician.name}!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                        Navigator.pop(context);
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isFormValid 
                    ? theme.colorScheme.primary 
                    : Colors.grey.shade300,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Confirm Booking',
                  style: ProfixStyles.getTextStyle(
                    size: ProfixStyles.textBase,
                    weight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
