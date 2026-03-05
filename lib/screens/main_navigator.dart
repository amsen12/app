import 'package:app/screens/request_page_screen.dart';
import 'package:app/screens/technician_search_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/app_provider.dart';
import '../theme.dart';
import 'customer_home_screen.dart';
import 'requests_page_screen.dart';
import 'request_form_screen.dart';
import 'request_tracking_screen.dart';
import 'chat_screen.dart';
import 'profile_screen.dart';
import 'notifications_screen.dart';
import 'technician_dashboard_screen.dart';

import 'technician_my_requests_screen.dart';
import 'technician_request_details_screen.dart';

// ─── Customer Shell ───────────────────────────────────────────────────────────

class CustomerShell extends StatefulWidget {
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
      ),
      const Center(child: Text('Search – Coming Soon')),
      RequestsPageScreen(
        onSelectRequest: (id) => setState(() => _viewingRequestId = id),
        onChat: (id) => setState(() => _chatRequestId = id),
      ),
      ProfileScreen(onLogout: widget.onLogout),
    ];

    return Scaffold(
      body: tabs[_tab],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (i) => setState(() => _tab = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.search_outlined), selectedIcon: Icon(Icons.search), label: 'Search'),
          NavigationDestination(icon: Icon(Icons.list_alt_outlined), selectedIcon: Icon(Icons.list_alt), label: 'Requests'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

// ─── Technician Shell ─────────────────────────────────────────────────────────

class TechnicianShell extends StatefulWidget {
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
  bool _viewingFromSearch = false;

  @override
  Widget build(BuildContext context) {
    final app = context.read<AppProvider>();

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
      return _viewingFromSearch
          ? TechnicianRequestDetailsScreen(
        requestId: _viewingRequestId!,
        onBack: () => setState(() => _viewingRequestId = null),
      )
          : TechnicianRequestDetailsScreen(
        requestId: _viewingRequestId!,
        onBack: () => setState(() => _viewingRequestId = null),
      );
    }

    final tabs = [
      TechnicianDashboardScreen(
        onViewRequest: (id) => setState(() { _viewingRequestId = id; _viewingFromSearch = false; }),
        onChat: (id) => setState(() => _chatRequestId = id),
        onNotifications: () => setState(() => _showNotifications = true),
      ),
      TechnicianSearchScreen(
        onViewRequest: (id) => setState(() { _viewingRequestId = id; _viewingFromSearch = true; }),
        onAcceptRequest: (id) {
          app.updateRequest(id, status: RequestStatus.inProgress, technicianId: app.user?.id, technicianName: app.user?.name);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Request accepted!')));
        },
      ),
      TechnicianMyRequestsScreen(
        onViewRequest: (id) => setState(() { _viewingRequestId = id; _viewingFromSearch = false; }),
      ),
      ProfileScreen(onLogout: widget.onLogout),
    ];

    return Scaffold(
      body: tabs[_tab],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (i) => setState(() => _tab = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard), label: 'Dashboard'),
          NavigationDestination(icon: Icon(Icons.search_outlined), selectedIcon: Icon(Icons.search), label: 'Find'),
          NavigationDestination(icon: Icon(Icons.list_alt_outlined), selectedIcon: Icon(Icons.list_alt), label: 'My Jobs'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}