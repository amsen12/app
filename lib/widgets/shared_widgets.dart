import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/models.dart';
import '../utils/profix_colors.dart';
import '../utils/profixStyles.dart';

// ─── Status Badge ─────────────────────────────────────────────────────────────

class StatusBadge extends StatelessWidget {
  final RequestStatus status;
  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final (label, icon, bg, fg) = _data();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: fg.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: fg),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: fg)),
        ],
      ),
    );
  }

  (String, IconData, Color, Color) _data() {
    switch (status) {
      case RequestStatus.pending:
        return ('Pending', Icons.access_time, const Color(0xFFFFF7ED), const Color(0xFFD97706));
      case RequestStatus.inProgress:
        return ('In Progress', Icons.build_outlined, const Color(0xFFEFF6FF), const Color(0xFF2563EB));
      case RequestStatus.completed:
        return ('Completed', Icons.check_circle_outline, const Color(0xFFF0FDF4), const Color(0xFF16A34A));
      case RequestStatus.rejected:
        return ('Rejected', Icons.cancel_outlined, const Color(0xFFFEF2F2), const Color(0xFFDC2626));
    }
  }
}

// ─── Service Card ─────────────────────────────────────────────────────────────



class ServiceCard extends StatelessWidget {
  final ServiceType type;
  final VoidCallback onTap;

  const ServiceCard({super.key, required this.type, required this.onTap});

  @override
  Widget build(BuildContext context) {
    // 1. التحقق من حالة الثيم
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    // 2. تحديد البيانات والألوان بناءً على النوع وحالة الثيم (نفس ألوان الصورة)
    final Map<String, dynamic> config = _getServiceConfig(type, isDark);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        decoration: BoxDecoration(
          color: config['bg'],
          borderRadius: BorderRadius.circular(20), // زوايا دائرية أكثر مثل الصور
          border: isDark ? Border.all(color: Colors.white.withValues(alpha: 0.05)) : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // أيقونة الخدمة داخل خلفية دائرية صغيرة
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: config['iconBg'],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                config['icon'],
                color: Colors.white,
                size: 26,
              ),
            ),
            const SizedBox(height: 12),
            // اسم الخدمة
            Text(
              config['label'],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            // وصف الخدمة
            Text(
              config['desc'],
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                color: isDark ? Colors.white70 : Colors.grey.shade600,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ميثود لجلب إعدادات الألوان والأيقونات بناءً على الصورة
  Map<String, dynamic> _getServiceConfig(ServiceType type, bool isDark) {
    switch (type) {
      case ServiceType.plumber:
        return {
          'icon': Icons.plumbing,
          'label': 'Plumber',
          'desc': 'Pipes, leaks\n& fixtures',
          'bg': isDark ? const Color(0xFF1E3A5F) : const Color(0xFFEFF6FF), // اللون الأزرق اللي طلبتيه
          'iconBg': const Color(0xFF38B6FF),
        };
      case ServiceType.carpenter:
        return {
          'icon': Icons.handyman,
          'label': 'Carpenter',
          'desc': 'Wood &\nfurniture',
          'bg': isDark ? const Color(0xFF2D2D2D) : const Color(0xFFFFFBEB), // رمادي غامق في الدارك
          'iconBg': const Color(0xFF8D6E63),
        };
      case ServiceType.electrician:
        return {
          'icon': Icons.lightbulb,
          'label': 'Electrician',
          'desc': 'Wiring &\ninstallations',
          'bg': isDark ? const Color(0xFF2D2D2D) : const Color(0xFFFEFCE8),
          'iconBg': const Color(0xFFFFCA28),
        };
    }
  }
}

// ─── Technician Card ──────────────────────────────────────────────────────────

class TechnicianCard extends StatelessWidget {
  final Technician technician;
  final VoidCallback? onTap;
  final bool compact;
  const TechnicianCard({super.key, required this.technician, this.onTap, this.compact = false});

  static const _profLabels = {
    ServiceType.plumber: '🚰 Plumber',
    ServiceType.carpenter: '🔨 Carpenter',
    ServiceType.electrician: '💡 Electrician',
  };

  @override
  Widget build(BuildContext context) {
    if (compact) return _buildCompact(context);
    return _buildFull(context);
  }

  Widget _buildCompact(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              _avatar(40),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(technician.name, style: ProfixStyles.textSmBold),
                        const SizedBox(width: 6),
                        if (technician.available)
                          Container(width: 8, height: 8, decoration: const BoxDecoration(color: ProfixColors.green, shape: BoxShape.circle)),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(Icons.star, size: 12, color: ProfixColors.amber),
                        Text(' ${technician.rating}', style: ProfixStyles.textXsRegular),
                        Text(' • ${technician.distance} km', style: ProfixStyles.textXsRegular.copyWith(color: Colors.grey.shade500)),
                      ],
                    ),
                  ],
                ),
              ),
              Text(_profLabels[technician.profession]!, style: ProfixStyles.textXsRegular),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFull(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _avatar(56),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(technician.name, style: ProfixStyles.textBaseBold),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: technician.available ? ProfixColors.green.withValues(alpha: 0.1) : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            technician.available ? 'Available' : 'Busy',
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: technician.available ? ProfixColors.green : Colors.grey),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(_profLabels[technician.profession]!, style: ProfixStyles.getTextStyle(size: ProfixStyles.textXs + 1, weight: FontWeight.w400, color: Colors.grey.shade600)),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.star, size: 14, color: ProfixColors.amber),
                        Text(' ${technician.rating}', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                        const SizedBox(width: 10),
                        Icon(Icons.check_circle_outline, size: 14, color: Colors.grey.shade500),
                        Text(' ${technician.completedJobs} jobs', style: TextStyle(fontSize: 13, color: Colors.grey.shade500)),
                        const SizedBox(width: 10),
                        Icon(Icons.location_on_outlined, size: 14, color: Colors.grey.shade500),
                        Text(' ${technician.distance} km', style: TextStyle(fontSize: 13, color: Colors.grey.shade500)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _avatar(double size) {
    return CircleAvatar(
      radius: size / 2,
      backgroundColor: ProfixColors.primary.withValues(alpha: 0.1),
      child: Text(
        technician.name[0],
        style: TextStyle(fontSize: size * 0.4, fontWeight: FontWeight.bold, color: ProfixColors.primary),
      ),
    );
  }
}

// ─── Request Card ─────────────────────────────────────────────────────────────

class RequestCard extends StatelessWidget {
  final ServiceRequest request;
  final VoidCallback onTap;
  final bool showChat;
  final VoidCallback? onChatTap;
  const RequestCard({super.key, required this.request, required this.onTap, this.showChat = false, this.onChatTap});

  static const _icons = {ServiceType.plumber: '🚰', ServiceType.carpenter: '🔨', ServiceType.electrician: '💡'};
  static const _names = {ServiceType.plumber: 'Plumber', ServiceType.carpenter: 'Carpenter', ServiceType.electrician: 'Electrician'};

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_icons[request.serviceType]!, style: ProfixStyles.text2xlBold),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_names[request.serviceType]!, style: ProfixStyles.textBaseBold),
                            if (request.technicianName != null)
                              Text('by ${request.technicianName}', style: ProfixStyles.textXsRegular.copyWith(color: Colors.grey.shade500)),
                          ],
                        ),
                      ),
                      StatusBadge(status: request.status),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(request.description, style: ProfixStyles.textSmRegular.copyWith(color: Colors.blue.shade700), maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined, size: 14, color: Colors.grey.shade500),
                      const SizedBox(width: 4),
                      Expanded(child: Text(request.address, style: TextStyle(fontSize: 12, color: Colors.grey.shade500))),
                      Icon(Icons.calendar_today_outlined, size: 13, color: Colors.grey.shade500),
                      const SizedBox(width: 4),
                      Text(DateFormat('MMM d, h:mm a').format(request.createdAt), style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                    ],
                  ),
                ],
              ),
            ),
            if (showChat) ...[
              Divider(height: 1, color: Colors.grey.shade100),
              InkWell(
                onTap: onChatTap,
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(14)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      Icon(Icons.chat_bubble_outline, size: 16, color: ProfixColors.primary),
                      const SizedBox(width: 8),
                      Text('Chat with Technician', style: TextStyle(fontSize: 14, color: ProfixColors.lightBlue, fontWeight: FontWeight.w500)),
                      const Spacer(),
                      Icon(Icons.chevron_right, size: 18, color: Colors.grey.shade400),
                    ],
                  ),
                ),
              ),
            ] else
              const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }
}

// ─── Section Header ───────────────────────────────────────────────────────────

class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Color? titleColor; // تأكدت من تعريف النوع كـ Color

  const SectionHeader({
    super.key,
    this.titleColor,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    // 1. التحقق من حالة الدارك مود
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            // 2. إذا لم يتم تمرير لون يدوي، يختار اللون بناءً على الثيم
            color: titleColor ?? (isDark ? Colors.white : Colors.black),
          ),
        ),
        if (actionLabel != null)
          Flexible(
            child: TextButton( // أزلنا .icon ليكون التنسيق مرناً أكثر مثل الصور
              onPressed: onAction,
              style: TextButton.styleFrom(
                foregroundColor: ProfixColors.lightBlue,
                padding: EdgeInsets.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    actionLabel!,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.chevron_right, size: 18),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

// ─── Empty State ──────────────────────────────────────────────────────────────

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  const EmptyState({super.key, required this.icon, required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 56, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(title, style: TextStyle(fontSize: 16, color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
            if (subtitle != null) ...[
              const SizedBox(height: 6),
              Text(subtitle!, style: ProfixStyles.getTextStyle(size: ProfixStyles.textXs + 1, weight: FontWeight.w400, color: Colors.grey.shade400), textAlign: TextAlign.center)
            ],
          ],
        ),
      ),
    );
  }
}