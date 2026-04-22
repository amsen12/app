import 'package:flutter/material.dart';
import '../features/customer/auth/login/login_screen.dart';
import '../models/models.dart';
import '../utils/profix_colors.dart';
import '../utils/profix_theme.dart';
import '../utils/profixStyles.dart';
import '../l10n/app_localizations.dart';
import '../widgets/themed_container.dart';
import 'package:flutter/material.dart';
import '../utils/profix_colors.dart';
import '../utils/profix_theme.dart';
class LandingScreen extends StatelessWidget {
  static const String routeName = 'landing';
  final Function(UserRole) onSelectRole;

  const LandingScreen({super.key, required this.onSelectRole});

  @override
  Widget build(BuildContext context) {
    // إرجاع الـ Localization لو محتاجه
    // final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: ProfixTheme.getBackgroundColor(isDark),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              // Logo
              ThemedContainer(
                width: 90,
                height: 90,
                borderRadius: 24,
                boxShadow: [],
                color: ProfixColors.primary.withOpacity(0.1),
                child: const Icon(Icons.build_circle, size: 54, color: ProfixColors.primary),
              ),
              const SizedBox(height: 24),
              Text('ProFix',
                style: TextStyle(
                    fontSize: ProfixStyles.text4xl,
                    fontWeight: FontWeight.bold,
                    color: isDark ? ProfixColors.white : ProfixColors.textMain
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Your trusted home services platform",
                style: TextStyle(color: Colors.grey, fontSize: ProfixStyles.textSm + 1,),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              Text(
                "Continue as",
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: ProfixStyles.textLg,
                    color: isDark ? ProfixColors.white : ProfixColors.textMain
                ),
              ),
              const SizedBox(height: 24),
              // كارت العميل
              _roleCard(
                context,
                icon: Icons.person_outline,
                title: "Customer",
                subtitle: "Find skilled technicians for repairs",
                color: ProfixColors.primary,
                onTap: () {
                  onSelectRole(UserRole.customer); // تنفيذ اختيار الدور
                  Navigator.pushReplacementNamed(
                      context,
                      LoginScreen.routeName,
                      arguments: 'customer'
                  );
                },
              ),
              const SizedBox(height: 16),
              // كارت الفني
              _roleCard(
                context,
                icon: Icons.build_outlined,
                title: "Technician",
                subtitle: "Offer your services and earn money",
                color: ProfixColors.green,
                onTap: () {
                  onSelectRole(UserRole.technician); // تنفيذ اختيار الدور
                  Navigator.pushReplacementNamed(
                      context,
                      LoginScreen.routeName,
                      arguments: 'technician'
                  );
                },
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _roleCard(BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return ThemedContainer(
      onTap: onTap, // دي اللي بتخلي الكارت يشتغل لما تضغط عليه
      padding: const EdgeInsets.all(20),
      color: isDark ? color.withOpacity(0.06) : color.withOpacity(0.08),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: ProfixStyles.textBase + 1,
                    color: isDark ? ProfixColors.white : ProfixColors.textMain,
                  ),
                ),
                const SizedBox(height: 4),
                Text(subtitle,
                  style: TextStyle(
                    fontSize: ProfixStyles.textXs + 1,
                    color: isDark ? ProfixColors.gray2 : ProfixColors.mutedText,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: color.withOpacity(0.4), size: 20),
        ],
      ),
    );
  }
}
