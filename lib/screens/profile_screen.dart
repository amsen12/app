import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/app_provider.dart';
import '../theme.dart';

class ProfileScreen extends StatelessWidget {
  final VoidCallback onLogout;
  const ProfileScreen({super.key, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final user = app.user;
    final isTech = user?.role == UserRole.technician;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 48, 16, 20),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 38,
                        backgroundColor: AppTheme.primary.withOpacity(0.1),
                        child: Text(user?.name[0] ?? 'U', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppTheme.primary)),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(user?.name ?? 'Guest', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                            Text(user?.role == UserRole.technician ? 'Technician' : 'Customer', style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
                            if (isTech && user?.rating != null) ...[
                              const SizedBox(height: 4),
                              Row(children: [
                                const Icon(Icons.star, size: 14, color: AppTheme.warning),
                                Text(' ${user!.rating} • ${user.completedJobs} jobs', style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
                              ]),
                            ],
                          ],
                        ),
                      ),
                      IconButton(icon: const Icon(Icons.edit_outlined, color: AppTheme.primary), onPressed: () {}),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _contactRow(Icons.mail_outline, user?.email ?? 'Not set'),
                  const SizedBox(height: 6),
                  _contactRow(Icons.phone_outlined, user?.phone ?? 'Not set'),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Technician: Availability
            if (isTech)
              _buildSection(context, children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(user?.isAvailable == true ? Icons.wifi : Icons.wifi_off, color: user?.isAvailable == true ? AppTheme.success : Colors.grey),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Availability', style: TextStyle(fontWeight: FontWeight.w600)),
                            Text(user?.isAvailable == true ? 'Online — receiving requests' : 'Offline', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                          ],
                        ),
                      ),
                      Switch(
                        value: user?.isAvailable ?? true,
                        onChanged: (v) => app.updateUserAvailability(v),
                        activeColor: AppTheme.success,
                      ),
                    ],
                  ),
                ),
              ]),

            const SizedBox(height: 12),

            // Professional section (technician)
            if (isTech) ...[
              _buildSection(context, header: 'Professional', children: [
                _navItem(context, Icons.attach_money, 'Earnings', () {}),
                _navItem(context, Icons.build_outlined, 'Service Categories', () {}),
                _navItem(context, Icons.map_outlined, 'Service Areas', () {}),
                _navItem(context, Icons.verified_outlined, 'Verification', () {}),
                _navItem(context, Icons.star_outline, 'Customer Reviews', () {}, isLast: true),
              ]),
              const SizedBox(height: 12),
            ],

            // Account section
            _buildSection(context, header: 'Account', children: [
              _navItem(context, Icons.location_on_outlined, 'My Addresses', () {}),
              if (!isTech) _navItem(context, Icons.chat_outlined, 'My Reviews', () {}),
              _navItem(context, Icons.shield_outlined, 'Security & Privacy', () {}, isLast: true),
            ]),
            const SizedBox(height: 12),

            // Preferences
            _buildSection(context, header: 'Preferences', children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Icon(app.isDark ? Icons.dark_mode_outlined : Icons.wb_sunny_outlined, color: app.isDark ? AppTheme.primary : AppTheme.warning),
                    const SizedBox(width: 12),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const Text('Theme', style: TextStyle(fontWeight: FontWeight.w600)),
                      Text(app.isDark ? 'Dark mode' : 'Light mode', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                    ])),
                    Switch(value: app.isDark, onChanged: (_) => app.toggleTheme(), activeColor: AppTheme.primary),
                  ],
                ),
              ),
              const Divider(height: 1),
              _navItem(context, Icons.language, 'Language', () {}, trailing: const Text('English', style: TextStyle(color: Colors.grey, fontSize: 13)), isLast: true),
            ]),
            const SizedBox(height: 12),

            // Notifications
            _buildSection(context, header: 'Notifications', children: [
              _switchItem(context, Icons.notifications_outlined, 'New Requests', true),
              const Divider(height: 1),
              _switchItem(context, Icons.check_circle_outline, 'Status Updates', true),
              const Divider(height: 1),
              _switchItem(context, Icons.mail_outline, 'New Messages', true, isLast: true),
            ]),
            const SizedBox(height: 12),

            // Help
            _buildSection(context, header: 'Help & Support', children: [
              _navItem(context, Icons.help_outline, 'FAQ', () {}),
              _navItem(context, Icons.mail_outline, 'Contact Us', () {}, isLast: true),
            ]),
            const SizedBox(height: 12),

            // Logout
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton.icon(
                onPressed: onLogout,
                icon: const Icon(Icons.logout),
                label: const Text('Log Out', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade600),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _contactRow(IconData icon, String text) {
    return Row(children: [
      Icon(icon, size: 16, color: Colors.grey.shade500),
      const SizedBox(width: 8),
      Text(text, style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
    ]);
  }

  Widget _buildSection(BuildContext context, {String? header, required List<Widget> children}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0),
      decoration: BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Colors.grey.shade200), bottom: BorderSide(color: Colors.grey.shade200))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (header != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
              child: Text(header, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            ),
          ...children,
        ],
      ),
    );
  }

  Widget _navItem(BuildContext context, IconData icon, String label, VoidCallback onTap, {Widget? trailing, bool isLast = false}) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Icon(icon, color: AppTheme.primary, size: 20),
                const SizedBox(width: 12),
                Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15))),
                trailing ?? const Icon(Icons.chevron_right, color: Colors.grey),
              ],
            ),
          ),
        ),
        if (!isLast) const Divider(height: 1, indent: 48),
      ],
    );
  }

  Widget _switchItem(BuildContext context, IconData icon, String label, bool value, {bool isLast = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey.shade500, size: 20),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: const TextStyle(fontSize: 15))),
          Switch(value: value, onChanged: (_) {}, activeColor: AppTheme.primary),
        ],
      ),
    );
  }
}