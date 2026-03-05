import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/app_provider.dart';
import 'theme.dart';
import 'models/models.dart';
import 'screens/landing_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/main_navigator.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppProvider(),
      child: const ProFixApp(),
    ),
  );
}

class ProFixApp extends StatelessWidget {
  const ProFixApp({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    return MaterialApp(
      title: 'ProFix',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: app.themeMode,
      home: const AppRoot(),
    );
  }
}

class AppRoot extends StatefulWidget {
  const AppRoot({super.key});

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  UserRole? _selectedRole;

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();

    // 1. Not authenticated → show landing or auth
    if (!app.isAuthenticated) {
      if (_selectedRole == null) {
        return LandingScreen(onSelectRole: (role) => setState(() => _selectedRole = role));
      }
      return AuthScreen(
        role: _selectedRole!,
        onBack: () => setState(() => _selectedRole = null),
        onSuccess: () => setState(() {}),
      );
    }

    // 2. Authenticated as customer
    if (app.user?.role == UserRole.customer) {
      return CustomerShell(onLogout: () { app.logout(); setState(() => _selectedRole = null); });
    }

    // 3. Authenticated as technician
    return TechnicianShell(onLogout: () { app.logout(); setState(() => _selectedRole = null); });
  }
}