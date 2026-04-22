import 'package:app/features/customer/auth/home_screen/tabs/search_tab/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../models/models.dart';
import '../../../../providers/app_provider.dart';
import '../../../../screens/request_page_screen.dart';

import '../../../../screens/technician_search_screen.dart';
import '../../../../screens/customer_home_screen.dart';
import '../../../../screens/request_form_screen.dart';
import '../../../../screens/request_tracking_screen.dart';
import '../../../../screens/chat_screen.dart';
import '../../../../screens/notifications_screen.dart';
import '../../../../screens/technician_dashboard_screen.dart';
import '../../../../screens/technician_my_requests_screen.dart';
import '../../../../screens/technician_request_details_screen.dart';
import 'tabs/profile_tab/profile_tab.dart';
import '../../../technican/profile_technican/profile_tab.dart';

// ─── Customer Shell ───────────────────────────────────────────────────────────

class CustomerShell extends StatefulWidget {
  static const String routeName = 'customerShell';
  final VoidCallback onLogout;
  const CustomerShell({super.key, required this.onLogout});

  @override
  State<CustomerShell> createState() => _CustomerShellState();
}

class _CustomerShellState extends State<CustomerShell> {
  int _tab = 0;
  String? _viewingRequestId;
  bool _showForm = false;
  bool _showNotifications = false;
  ServiceType? _formInitialService;
  String? _chatRequestId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    // Full-screen overlays
    if (_showNotifications) {
      return NotificationsScreen(onBack: () => setState(() => _showNotifications = false));
    }
    if (_showForm) {
      return RequestFormScreen(
        initialService: _formInitialService,
        onBack: () => setState(() { _showForm = false; _formInitialService = null; }),
        onSubmit: () => setState(() { _showForm = false; _formInitialService = null; _tab = 2; }),
      );
    }
    if (_viewingRequestId != null) {
      return RequestTrackingScreen(
        requestId: _viewingRequestId!,
        onBack: () => setState(() => _viewingRequestId = null),
      );
    }
    if (_chatRequestId != null) {
      final app = context.read<AppProvider>();
      final req = app.requests.firstWhere((r) => r.id == _chatRequestId);
      return ChatScreen(
        requestId: _chatRequestId!,
        otherUserName: req.technicianName ?? 'Technician',
        onBack: () => setState(() => _chatRequestId = null),
      );
    }

    final tabs = [
      CustomerHomeScreen(
        onNewRequest: () => setState(() => _showForm = true),
        onSelectService: (s) => setState(() { _showForm = true; _formInitialService = s; }),
        onViewTechnician: (_) {},
        onViewRequest: (id) => setState(() => _viewingRequestId = id),
        onChat: (id) => setState(() => _chatRequestId = id),
        onNotifications: () => setState(() => _showNotifications = true),
        onChangeTab: (index) => setState(() => _tab = index),
      ),
      const SearchScreen(),
      RequestsPageScreen(
        onSelectRequest: (id) => setState(() => _viewingRequestId = id),
        onChat: (id) => setState(() => _chatRequestId = id),
      ),
      const ProfileTab(),
    ];

    return Scaffold(
      body: tabs[_tab],
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          indicatorColor: theme.colorScheme.primary.withValues(alpha: 0.2),
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold);
            }
            return TextStyle(color: theme.hintColor);
          }),
          iconTheme: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return IconThemeData(color: theme.colorScheme.primary);
            }
            return IconThemeData(color: theme.hintColor);
          }),
        ),
        child: NavigationBar(
          backgroundColor: theme.scaffoldBackgroundColor,
          elevation: 10,
          selectedIndex: _tab,
          onDestinationSelected: (i) => setState(() => _tab = i),
          destinations: [
            NavigationDestination(icon: const Icon(Icons.home_outlined), selectedIcon: const Icon(Icons.home), label: l10n.home),
            NavigationDestination(icon: const Icon(Icons.search_outlined), selectedIcon: const Icon(Icons.search), label: l10n.search),
            NavigationDestination(icon: const Icon(Icons.list_alt_outlined), selectedIcon: const Icon(Icons.list_alt), label: l10n.requests),
            NavigationDestination(icon: const Icon(Icons.person_outline), selectedIcon: const Icon(Icons.person), label: l10n.profile),
          ],
        ),
      ),
    );
  }
}

// ─── Technician Shell ─────────────────────────────────────────────────────────

class TechnicianShell extends StatefulWidget {
  static const String routeName = 'technicianShell';
  final VoidCallback onLogout;
  const TechnicianShell({super.key, required this.onLogout});

  @override
  State<TechnicianShell> createState() => _TechnicianShellState();
}

class _TechnicianShellState extends State<TechnicianShell> {
  int _tab = 0;
  String? _viewingRequestId;
  bool _showNotifications = false;
  String? _chatRequestId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final app = context.read<AppProvider>();
    final theme = Theme.of(context);

    if (_showNotifications) {
      return NotificationsScreen(onBack: () => setState(() => _showNotifications = false));
    }
    if (_chatRequestId != null) {
      final req = app.requests.firstWhere((r) => r.id == _chatRequestId);
      return ChatScreen(
        requestId: _chatRequestId!,
        otherUserName: req.customerName,
        onBack: () => setState(() => _chatRequestId = null),
      );
    }
    if (_viewingRequestId != null) {
      return TechnicianRequestDetailsScreen(
        requestId: _viewingRequestId!,
        onBack: () => setState(() => _viewingRequestId = null),
      );
    }

    final tabs = [
      TechnicianDashboardScreen(
        onViewRequest: (id) => setState(() { _viewingRequestId = id; }),
        onChat: (id) => setState(() => _chatRequestId = id),
        onNotifications: () => setState(() => _showNotifications = true),
      ),
      TechnicianSearchScreen(
        onViewRequest: (id) => setState(() { _viewingRequestId = id; }),
        onAcceptRequest: (id) {
          app.updateRequest(id, status: RequestStatus.inProgress, technicianId: app.user?.id, technicianName: app.user?.name);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.request_accepted)));
        },
      ),
      TechnicianMyRequestsScreen(
        onViewRequest: (id) => setState(() { _viewingRequestId = id; }),
      ),
      const TechnicianProfileTab(),
    ];

    return Scaffold(
      body: tabs[_tab],
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          indicatorColor: theme.colorScheme.primary.withValues(alpha: 0.2),
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold);
            }
            return TextStyle(color: theme.hintColor);
          }),
          iconTheme: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return IconThemeData(color: theme.colorScheme.primary);
            }
            return IconThemeData(color: theme.hintColor);
          }),
        ),
        child: NavigationBar(
          backgroundColor: theme.scaffoldBackgroundColor,
          elevation: 10,
          selectedIndex: _tab,
          onDestinationSelected: (i) => setState(() => _tab = i),
          destinations: [
            NavigationDestination(icon: const Icon(Icons.dashboard_outlined), selectedIcon: const Icon(Icons.dashboard), label: l10n.dashboard),
            NavigationDestination(icon: const Icon(Icons.search_outlined), selectedIcon: const Icon(Icons.search), label: l10n.find),
            NavigationDestination(icon: const Icon(Icons.list_alt_outlined), selectedIcon: const Icon(Icons.list_alt), label: l10n.my_jobs),
            NavigationDestination(icon: const Icon(Icons.person_outline), selectedIcon: const Icon(Icons.person), label: l10n.profile),
          ],
        ),
      ),
    );
  }
}