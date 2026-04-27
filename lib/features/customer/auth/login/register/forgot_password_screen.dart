import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:app/utils/profixStyles.dart';
import 'package:app/utils/profix_colors.dart';
import 'package:app/utils/profix_theme.dart';
import 'package:app/widgets/custom_eleveted_button.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static const String routeName = 'forgotPassword';
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
          'Forgot Password',
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
              SizedBox(height: screenHeight * 0.08),
              
              // Email input field
              Text(
                'Email',
                style: ProfixStyles.bold14black.copyWith(
                  color: isDark ? ProfixColors.white : ProfixColors.black,
                ),
              ),
              const SizedBox(height: 8),
              
              Form(
                key: _formKey,
                child: TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: ProfixStyles.medium16black.copyWith(
                    color: isDark ? ProfixColors.white : ProfixColors.black,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Enter your email address',
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
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Send code button
              CustomElevatedButton(
                text: 'Send Code',
                onButtonClick: _sendCode,
              ),
              
              const SizedBox(height: 16),
              
              // Back to login text
              Center(
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Text.rich(
                    TextSpan(
                      text: "Remember your password? ",
                      style: ProfixStyles.medium16black.copyWith(
                        color: isDark ? ProfixColors.gray2 : ProfixColors.gray,
                      ),
                      children: [
                        TextSpan(
                          text: 'Login',
                          style: ProfixStyles.medium16black.copyWith(
                            color: ProfixColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _sendCode() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _isLoading = false;
      });

      // Navigate to verification screen
      Navigator.of(context).pushNamed(
        '/verifyCode',
        arguments: _emailController.text,
      );
    }
  }
}
