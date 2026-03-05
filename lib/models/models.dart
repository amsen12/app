// ─── Enums ────────────────────────────────────────────────────────────────────

enum UserRole { customer, technician }

enum RequestStatus { pending, inProgress, completed, rejected }

enum ServiceType { plumber, carpenter, electrician }

// ─── User ─────────────────────────────────────────────────────────────────────

class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final UserRole role;
  final String? avatar;
  final double? rating;
  final int? completedJobs;
  final ServiceType? profession;
  final bool isAvailable;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    this.avatar,
    this.rating,
    this.completedJobs,
    this.profession,
    this.isAvailable = true,
  });

  User copyWith({
    String? name,
    String? email,
    String? phone,
    bool? isAvailable,
    ServiceType? profession,
  }) {
    return User(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role,
      avatar: avatar,
      rating: rating,
      completedJobs: completedJobs,
      profession: profession ?? this.profession,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }
}

// ─── Technician ───────────────────────────────────────────────────────────────

class Technician {
  final String id;
  final String name;
  final ServiceType profession;
  final double rating;
  final int completedJobs;
  final double distance;
  final bool available;
  final String phone;

  Technician({
    required this.id,
    required this.name,
    required this.profession,
    required this.rating,
    required this.completedJobs,
    required this.distance,
    required this.available,
    required this.phone,
  });
}

// ─── LatLng ───────────────────────────────────────────────────────────────────

class LatLng {
  final double lat;
  final double lng;
  const LatLng({required this.lat, required this.lng});
}

// ─── ServiceRequest ───────────────────────────────────────────────────────────

class ServiceRequest {
  final String id;
  final String customerId;
  final String customerName;
  final String customerPhone;
  final String? technicianId;
  final String? technicianName;
  final ServiceType serviceType;
  final String description;
  final String address;
  final LatLng location;
  RequestStatus status;
  final DateTime createdAt;
  DateTime updatedAt;
  double? rating;
  String? review;

  ServiceRequest({
    required this.id,
    required this.customerId,
    required this.customerName,
    required this.customerPhone,
    this.technicianId,
    this.technicianName,
    required this.serviceType,
    required this.description,
    required this.address,
    required this.location,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.rating,
    this.review,
  });

  ServiceRequest copyWith({
    RequestStatus? status,
    String? technicianId,
    String? technicianName,
    double? rating,
    String? review,
  }) {
    return ServiceRequest(
      id: id,
      customerId: customerId,
      customerName: customerName,
      customerPhone: customerPhone,
      technicianId: technicianId ?? this.technicianId,
      technicianName: technicianName ?? this.technicianName,
      serviceType: serviceType,
      description: description,
      address: address,
      location: location,
      status: status ?? this.status,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
      rating: rating ?? this.rating,
      review: review ?? this.review,
    );
  }
}

// ─── ChatMessage ──────────────────────────────────────────────────────────────

class ChatMessage {
  final String id;
  final String requestId;
  final String senderId;
  final String senderName;
  final String content;
  final DateTime timestamp;
  final bool isLocation;

  ChatMessage({
    required this.id,
    required this.requestId,
    required this.senderId,
    required this.senderName,
    required this.content,
    required this.timestamp,
    this.isLocation = false,
  });
}

// ─── Notification ─────────────────────────────────────────────────────────────

enum NotificationRole { customer, technician }

class AppNotification {
  final String id;
  final String title;
  final String body;
  final String? relatedRequestId;
  bool isRead;
  final DateTime createdAt;
  final NotificationRole role;

  AppNotification({
    required this.id,
    required this.title,
    required this.body,
    this.relatedRequestId,
    required this.isRead,
    required this.createdAt,
    required this.role,
  });
}