import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:app/utils/profixStyles.dart';
import 'package:app/utils/profix_colors.dart';
import 'package:app/utils/profix_theme.dart';
import 'package:app/widgets/custom_eleveted_button.dart';
import 'package:app/features/customer/auth/login/login_screen.dart';

class ResetPasswordNewScreen extends StatefulWidget {
  static const String routeName = 'resetPasswordNew';
  const ResetPasswordNewScreen({super.key});

  @override
  State<ResetPasswordNewScreen> createState() => _ResetPasswordNewScreenState();
}

class _ResetPasswordNewScreenState extends State<ResetPasswordNewScreen> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isObscured = true;
  bool _isConfirmObscured = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: ProfixTheme.getBackgroundColor(isDark),
      appBar: AppBar(
        backgroundColor: ProfixTheme.getBackgroundColor(isDark),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: isDark ? ProfixColors.white : ProfixColors.black,
            size: 20,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Reset Password',
          style: ProfixStyles.bold20black.copyWith(
            color: isDark ? ProfixColors.white : ProfixColors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight * 0.06),
              
              // New Password field
              Text(
                'New Password',
                style: ProfixStyles.bold14black.copyWith(
                  color: isDark ? ProfixColors.white : ProfixColors.black,
                ),
              ),
              const SizedBox(height: 8),
              
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _isObscured,
                      style: ProfixStyles.medium16black.copyWith(
                        color: isDark ? ProfixColors.white : ProfixColors.black,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Enter your new password',
                        hintStyle: ProfixStyles.medium16black.copyWith(
                          color: ProfixColors.gray2,
                        ),
                        filled: true,
                        fillColor: isDark ? ProfixColors.darkTheme : ProfixColors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: isDark ? ProfixColors.gray2 : ProfixColors.lightGray,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: isDark ? ProfixColors.gray2 : ProfixColors.lightGray,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: ProfixColors.primary,
                            width: 2,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Colors.red,
                            width: 1,
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Colors.red,
                            width: 2,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isObscured ? Icons.visibility_off : Icons.visibility,
                            color: isDark ? ProfixColors.gray2 : ProfixColors.gray,
                          ),
                          onPressed: () {
                            setState(() {
                              _isObscured = !_isObscured;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your new password';
                        }
                        if (value.length < 8) {
                          return 'Password must be at least 8 characters';
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Confirm Password field
                    Text(
                      'Confirm New Password',
                      style: ProfixStyles.bold14black.copyWith(
                        color: isDark ? ProfixColors.white : ProfixColors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: _isConfirmObscured,
                      style: ProfixStyles.medium16black.copyWith(
                        color: isDark ? ProfixColors.white : ProfixColors.black,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Confirm your new password',
                        hintStyle: ProfixStyles.medium16black.copyWith(
                          color: ProfixColors.gray2,
                        ),
                        filled: true,
                        fillColor: isDark ? ProfixColors.darkTheme : ProfixColors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: isDark ? ProfixColors.gray2 : ProfixColors.lightGray,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: isDark ? ProfixColors.gray2 : ProfixColors.lightGray,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: ProfixColors.primary,
                            width: 2,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Colors.red,
                            width: 1,
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Colors.red,
                            width: 2,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isConfirmObscured ? Icons.visibility_off : Icons.visibility,
                            color: isDark ? ProfixColors.gray2 : ProfixColors.gray,
                          ),
                          onPressed: () {
                            setState(() {
                              _isConfirmObscured = !_isConfirmObscured;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your new password';
                        }
                        if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: screenHeight * 0.08),
              
              // Reset Password button
              CustomElevatedButton(
                text: 'Reset Password',
                onButtonClick: _resetPassword,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _resetPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password has been reset successfully. Please log in again.'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );

      // Navigate back to login screen and remove all previous routes
      Navigator.of(context).pushNamedAndRemoveUntil(
        LoginScreen.routeName,
        (route) => false,
      );
    }
  }
}
