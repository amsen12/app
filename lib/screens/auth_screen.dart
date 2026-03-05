import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/app_provider.dart';
import '../theme.dart';

class AuthScreen extends StatefulWidget {
  final UserRole role;
  final VoidCallback onBack;
  final VoidCallback onSuccess;

  const AuthScreen({super.key, required this.role, required this.onBack, required this.onSuccess});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLogin = true;
  bool _showPassword = false;
  bool _isLoading = false;
  bool _showPendingReview = false;

  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  ServiceType _profession = ServiceType.plumber;
  bool _hasIdPhoto = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));

    if (!_isLogin && widget.role == UserRole.technician) {
      setState(() { _isLoading = false; _showPendingReview = true; });
      return;
    }

    if (!mounted) return;
    context.read<AppProvider>().setUser(User(
      id: widget.role == UserRole.customer ? 'c1' : 't1',
      name: _nameCtrl.text.isEmpty ? (widget.role == UserRole.customer ? 'Sarah Johnson' : 'Ahmed Hassan') : _nameCtrl.text,
      email: _emailCtrl.text.isEmpty ? 'demo@example.com' : _emailCtrl.text,
      phone: _phoneCtrl.text.isEmpty ? '+1234567890' : _phoneCtrl.text,
      role: widget.role,
      rating: widget.role == UserRole.technician ? 4.8 : null,
      completedJobs: widget.role == UserRole.technician ? 156 : null,
      profession: widget.role == UserRole.technician ? _profession : null,
    ));

    setState(() => _isLoading = false);
    widget.onSuccess();
  }

  @override
  Widget build(BuildContext context) {
    if (_showPendingReview) return _buildPendingReview();

    final isTechnician = widget.role == UserRole.technician;
    final primaryColor = isTechnician ? AppTheme.success : AppTheme.primary;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  IconButton(icon: const Icon(Icons.arrow_back), onPressed: widget.onBack),
                  Text(
                    '${isTechnician ? 'Technician' : 'Customer'} ${_isLogin ? 'Login' : 'Sign Up'}',
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // Icon
                    Container(
                      width: 80, height: 80,
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(isTechnician ? Icons.build : Icons.person, size: 40, color: primaryColor),
                    ),
                    const SizedBox(height: 24),
                    Text(_isLogin ? 'Welcome Back!' : 'Create Account', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(
                      _isLogin ? 'Sign in to continue' : 'Sign up as ${isTechnician ? 'a technician' : 'a customer'}',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    const SizedBox(height: 32),

                    // Form fields
                    if (!_isLogin) ...[
                      _buildField(controller: _nameCtrl, label: 'Full Name', hint: 'Enter your name', icon: Icons.person_outline),
                      const SizedBox(height: 16),
                    ],
                    _buildField(controller: _emailCtrl, label: 'Email', hint: 'Enter your email', icon: Icons.mail_outline, keyboardType: TextInputType.emailAddress),
                    const SizedBox(height: 16),
                    if (!_isLogin) ...[
                      _buildField(controller: _phoneCtrl, label: 'Phone Number', hint: 'Enter your phone', icon: Icons.phone_outlined, keyboardType: TextInputType.phone),
                      const SizedBox(height: 16),
                    ],
                    if (!_isLogin && isTechnician) ...[
                      _buildProfessionPicker(),
                      const SizedBox(height: 16),
                      _buildIdUpload(),
                      const SizedBox(height: 16),
                    ],
                    _buildPasswordField(),
                    if (_isLogin) ...[
                      const SizedBox(height: 8),
                      Align(alignment: Alignment.centerRight, child: TextButton(onPressed: () {}, child: Text('Forgot Password?', style: TextStyle(color: primaryColor)))),
                    ],
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _isLoading || (!_isLogin && isTechnician && !_hasIdPhoto) ? null : _handleSubmit,
                      style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
                      child: _isLoading
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : Text(_isLogin ? 'Sign In' : 'Create Account', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    ),
                    if (!_isLogin && isTechnician) ...[
                      const SizedBox(height: 12),
                      Text('By signing up, your account will be reviewed before approval.', style: TextStyle(fontSize: 12, color: Colors.grey.shade500), textAlign: TextAlign.center),
                    ],
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(_isLogin ? "Don't have an account? " : 'Already have an account? ', style: TextStyle(color: Colors.grey.shade600)),
                        GestureDetector(
                          onTap: () => setState(() => _isLogin = !_isLogin),
                          child: Text(_isLogin ? 'Sign Up' : 'Sign In', style: TextStyle(color: primaryColor, fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField({required TextEditingController controller, required String label, required String hint, required IconData icon, TextInputType? keyboardType}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        const SizedBox(height: 6),
        TextField(controller: controller, keyboardType: keyboardType, decoration: InputDecoration(prefixIcon: Icon(icon), hintText: hint)),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Password', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        const SizedBox(height: 6),
        TextField(
          controller: _passwordCtrl,
          obscureText: !_showPassword,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.lock_outline),
            hintText: 'Enter your password',
            suffixIcon: IconButton(
              icon: Icon(_showPassword ? Icons.visibility_off : Icons.visibility),
              onPressed: () => setState(() => _showPassword = !_showPassword),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfessionPicker() {
    final profs = [
      (ServiceType.plumber, '🚰', 'Plumber'),
      (ServiceType.electrician, '💡', 'Electrician'),
      (ServiceType.carpenter, '🔨', 'Carpenter'),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Profession', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        const SizedBox(height: 8),
        Row(
          children: profs.map((p) {
            final isSelected = _profession == p.$1;
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () => setState(() => _profession = p.$1),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: isSelected ? AppTheme.primary : Colors.grey.shade300, width: 2),
                      borderRadius: BorderRadius.circular(12),
                      color: isSelected ? AppTheme.primary.withOpacity(0.1) : null,
                    ),
                    child: Column(
                      children: [
                        Text(p.$2, style: const TextStyle(fontSize: 22)),
                        const SizedBox(height: 4),
                        Text(p.$3, style: const TextStyle(fontSize: 11)),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildIdUpload() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('National ID Photo', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => setState(() => _hasIdPhoto = true),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border.all(color: _hasIdPhoto ? AppTheme.success : Colors.grey.shade300, style: BorderStyle.solid, width: 2),
              borderRadius: BorderRadius.circular(12),
              color: _hasIdPhoto ? AppTheme.success.withOpacity(0.05) : null,
            ),
            child: Column(
              children: [
                Icon(_hasIdPhoto ? Icons.check_circle : Icons.upload_outlined, size: 32, color: _hasIdPhoto ? AppTheme.success : Colors.grey),
                const SizedBox(height: 8),
                Text(_hasIdPhoto ? 'ID Photo Added ✓' : 'Tap to upload your National ID', style: TextStyle(color: _hasIdPhoto ? AppTheme.success : Colors.grey.shade600, fontSize: 13)),
                if (!_hasIdPhoto) Text('JPG, PNG or PDF (Max 5MB)', style: TextStyle(fontSize: 11, color: Colors.grey.shade400)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPendingReview() {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  IconButton(icon: const Icon(Icons.arrow_back), onPressed: widget.onBack),
                  const Text('Registration Submitted', style: TextStyle(fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 96, height: 96,
                        decoration: BoxDecoration(color: AppTheme.warning.withOpacity(0.1), shape: BoxShape.circle),
                        child: const Icon(Icons.access_time, size: 48, color: AppTheme.warning),
                      ),
                      const SizedBox(height: 24),
                      const Text('Thank You for Your Submission!', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                      const SizedBox(height: 12),
                      Text('Your information is under review. You will receive an email once your account is approved.', style: TextStyle(color: Colors.grey.shade600, height: 1.5), textAlign: TextAlign.center),
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(12)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(children: [Icon(Icons.check_circle, color: AppTheme.success, size: 18), SizedBox(width: 8), Text('What happens next?', style: TextStyle(fontWeight: FontWeight.w600))]),
                            const SizedBox(height: 8),
                            ...['Our team will verify your documents', 'Review typically takes 1-2 business days', "You'll receive an email with the result"]
                                .map((s) => Padding(padding: const EdgeInsets.only(top: 4), child: Text('• $s', style: TextStyle(fontSize: 13, color: Colors.grey.shade600)))),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      OutlinedButton(onPressed: widget.onBack, child: const Text('Back to Home')),
                    ],
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