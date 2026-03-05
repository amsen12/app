import 'package:flutter/material.dart';
import '../models/models.dart';
import '../theme.dart';
// customor or technician

class LandingScreen extends StatelessWidget {
  final Function(UserRole) onSelectRole;
  const LandingScreen({super.key, required this.onSelectRole});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              // Logo
              Container(
                width: 80, height: 80,
                decoration: BoxDecoration(color: AppTheme.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                child: const Icon(Icons.build_circle, size: 48, color: AppTheme.primary),
              ),
              const SizedBox(height: 20),
              const Text('ProFix', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('Your trusted home services platform', style: TextStyle(color: Colors.grey.shade600, fontSize: 16), textAlign: TextAlign.center),
              const Spacer(),
              const Text('Continue as', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
              const SizedBox(height: 20),
              _roleCard(
                context,
                icon: Icons.person_outline,
                title: 'Customer',
                subtitle: 'Find skilled technicians for your home repairs',
                color: AppTheme.primary,
                onTap: () => onSelectRole(UserRole.customer),
              ),
              const SizedBox(height: 12),
              _roleCard(
                context,
                icon: Icons.build_outlined,
                title: 'Technician',
                subtitle: 'Offer your services and earn money',
                color: AppTheme.success,
                onTap: () => onSelectRole(UserRole.technician),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _roleCard(BuildContext context, {required IconData icon, required String title, required String subtitle, required Color color, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(color: color.withOpacity(0.3), width: 2),
          borderRadius: BorderRadius.circular(16),
          color: color.withOpacity(0.04),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: color),
          ],
        ),
      ),
    );
  }
}