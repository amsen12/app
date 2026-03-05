import 'package:flutter/material.dart';
import '../models/models.dart';

class AppProvider extends ChangeNotifier {
  // ── Theme ──────────────────────────────────────────────────────────────────
  ThemeMode _themeMode = ThemeMode.light;
  ThemeMode get themeMode => _themeMode;
  bool get isDark => _themeMode == ThemeMode.dark;

  void toggleTheme() {
    _themeMode = isDark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }

  // ── Auth ───────────────────────────────────────────────────────────────────
  User? _user;
  User? get user => _user;
  bool get isAuthenticated => _user != null;

  void setUser(User? user) {
    _user = user;
    notifyListeners();
  }

  void logout() {
    _user = null;
    _activeTab = 'home';
    notifyListeners();
  }

  void updateUserAvailability(bool available) {
    if (_user != null) {
      _user = _user!.copyWith(isAvailable: available);
      notifyListeners();
    }
  }

  // ── Navigation ─────────────────────────────────────────────────────────────
  String _activeTab = 'home';
  String get activeTab => _activeTab;

  void setActiveTab(String tab) {
    _activeTab = tab;
    notifyListeners();
  }

  // ── Technicians ────────────────────────────────────────────────────────────
  final List<Technician> technicians = [
    Technician(id: 't1', name: 'Ahmed Hassan', profession: ServiceType.plumber, rating: 4.9, completedJobs: 234, distance: 1.2, available: true, phone: '+1234567890'),
    Technician(id: 't2', name: 'Omar Salem', profession: ServiceType.electrician, rating: 4.8, completedJobs: 189, distance: 2.5, available: true, phone: '+1234567891'),
    Technician(id: 't3', name: 'Youssef Ali', profession: ServiceType.carpenter, rating: 4.7, completedJobs: 156, distance: 3.1, available: false, phone: '+1234567892'),
    Technician(id: 't4', name: 'Khaled Mohamed', profession: ServiceType.plumber, rating: 4.6, completedJobs: 98, distance: 0.8, available: true, phone: '+1234567893'),
    Technician(id: 't5', name: 'Mahmoud Ibrahim', profession: ServiceType.electrician, rating: 4.5, completedJobs: 145, distance: 4.2, available: true, phone: '+1234567894'),
  ];

  List<Technician> get recommendedTechnicians {
    final available = technicians.where((t) => t.available).toList();
    available.sort((a, b) {
      final scoreA = a.rating * 0.4 + (10 - a.distance) * 0.3 + 0.3;
      final scoreB = b.rating * 0.4 + (10 - b.distance) * 0.3 + 0.3;
      return scoreB.compareTo(scoreA);
    });
    return available.take(3).toList();
  }

  // ── Requests ───────────────────────────────────────────────────────────────
  final List<ServiceRequest> _requests = [
    ServiceRequest(
      id: 'r1', customerId: 'c1', customerName: 'Sarah Johnson', customerPhone: '+1234567800',
      technicianId: 't1', technicianName: 'Ahmed Hassan', serviceType: ServiceType.plumber,
      description: 'Leaking faucet in the kitchen needs repair', address: '123 Main Street, Apt 4B',
      location: LatLng(lat: 40.7128, lng: -74.006), status: RequestStatus.inProgress,
      createdAt: DateTime.now().subtract(const Duration(hours: 1)), updatedAt: DateTime.now(),
    ),
    ServiceRequest(
      id: 'r2', customerId: 'c1', customerName: 'Sarah Johnson', customerPhone: '+1234567800',
      serviceType: ServiceType.electrician, description: 'Install new ceiling fan in bedroom',
      address: '123 Main Street, Apt 4B', location: LatLng(lat: 40.7128, lng: -74.006),
      status: RequestStatus.pending, createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    ServiceRequest(
      id: 'r3', customerId: 'c1', customerName: 'Sarah Johnson', customerPhone: '+1234567800',
      technicianId: 't3', technicianName: 'Youssef Ali', serviceType: ServiceType.carpenter,
      description: 'Fix broken cabinet door', address: '123 Main Street, Apt 4B',
      location: LatLng(lat: 40.7128, lng: -74.006), status: RequestStatus.completed,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 23)),
      rating: 5, review: 'Excellent work! Very professional.',
    ),
  ];

  List<ServiceRequest> get requests => List.unmodifiable(_requests);

  List<ServiceRequest> get activeRequests =>
      _requests.where((r) => r.status == RequestStatus.pending || r.status == RequestStatus.inProgress).toList();

  int get completedCount => _requests.where((r) => r.status == RequestStatus.completed).length;

  List<ServiceRequest> get myTechnicianRequests =>
      _requests.where((r) => r.technicianId == _user?.id).toList();

  void addRequest(ServiceRequest req) {
    _requests.insert(0, req);
    notifyListeners();
  }

  void updateRequest(String id, {
    RequestStatus? status,
    String? technicianId,
    String? technicianName,
    double? rating,
    String? review,
  }) {
    final idx = _requests.indexWhere((r) => r.id == id);
    if (idx != -1) {
      _requests[idx] = _requests[idx].copyWith(
        status: status,
        technicianId: technicianId,
        technicianName: technicianName,
        rating: rating,
        review: review,
      );
      notifyListeners();
    }
  }

  // ── Chat ───────────────────────────────────────────────────────────────────
  final List<ChatMessage> _messages = [
    ChatMessage(id: 'm1', requestId: 'r1', senderId: 't1', senderName: 'Ahmed Hassan', content: 'Hello! I\'m on my way. ETA 15 minutes.', timestamp: DateTime.now().subtract(const Duration(minutes: 30))),
    ChatMessage(id: 'm2', requestId: 'r1', senderId: 'c1', senderName: 'Sarah Johnson', content: 'Great! The building code is 4B.', timestamp: DateTime.now().subtract(const Duration(minutes: 28))),
    ChatMessage(id: 'm3', requestId: 'r1', senderId: 't1', senderName: 'Ahmed Hassan', content: 'Thanks! I\'ve arrived at the building.', timestamp: DateTime.now().subtract(const Duration(minutes: 15))),
  ];

  List<ChatMessage> getMessagesForRequest(String requestId) =>
      _messages.where((m) => m.requestId == requestId).toList();

  void addMessage(ChatMessage msg) {
    _messages.add(msg);
    notifyListeners();
  }

  // ── Notifications ──────────────────────────────────────────────────────────
  final List<AppNotification> _notifications = [
    AppNotification(id: 'n1', title: 'Technician Accepted', body: 'Ahmed Hassan accepted your plumbing request.', relatedRequestId: 'r1', isRead: false, createdAt: DateTime.now().subtract(const Duration(minutes: 20)), role: NotificationRole.customer),
    AppNotification(id: 'n2', title: 'Technician On the Way', body: 'Ahmed Hassan is heading to your location. ETA 15 min.', relatedRequestId: 'r1', isRead: false, createdAt: DateTime.now().subtract(const Duration(minutes: 15)), role: NotificationRole.customer),
    AppNotification(id: 'n3', title: 'Service Completed', body: 'Youssef Ali completed your carpentry request.', relatedRequestId: 'r3', isRead: true, createdAt: DateTime.now().subtract(const Duration(hours: 23)), role: NotificationRole.customer),
    AppNotification(id: 'n4', title: 'New Request Nearby', body: 'A new plumbing request is available 1.2 km from you.', relatedRequestId: 'r2', isRead: false, createdAt: DateTime.now().subtract(const Duration(minutes: 10)), role: NotificationRole.technician),
    AppNotification(id: 'n5', title: 'New Chat Message', body: 'Sarah Johnson sent you a message.', relatedRequestId: 'r1', isRead: false, createdAt: DateTime.now().subtract(const Duration(minutes: 5)), role: NotificationRole.technician),
    AppNotification(id: 'n6', title: 'New Rating Received', body: 'You received a 5-star rating from Sarah Johnson!', relatedRequestId: 'r3', isRead: true, createdAt: DateTime.now().subtract(const Duration(hours: 22)), role: NotificationRole.technician),
  ];

  List<AppNotification> get notifications => List.unmodifiable(_notifications);

  int get unreadNotificationCount {
    final role = _user?.role == UserRole.technician ? NotificationRole.technician : NotificationRole.customer;
    return _notifications.where((n) => n.role == role && !n.isRead).length;
  }

  void markNotificationRead(String id) {
    final idx = _notifications.indexWhere((n) => n.id == id);
    if (idx != -1) {
      _notifications[idx].isRead = true;
      notifyListeners();
    }
  }

  void markAllNotificationsRead() {
    for (final n in _notifications) {
      n.isRead = true;
    }
    notifyListeners();
  }
}