import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:app/utils/profixStyles.dart';
import 'package:app/utils/profix_colors.dart';
import 'package:app/utils/profix_theme.dart';
import 'package:app/widgets/custom_eleveted_button.dart';

class VerifyCodeScreen extends StatefulWidget {
  static const String routeName = 'verifyCode';
  final String email;
  const VerifyCodeScreen({super.key, required this.email});

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  final List<TextEditingController> _codeControllers = List.generate(4, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (index) => FocusNode());
  bool _isLoading = false;

  @override
  void dispose() {
    for (var controller in _codeControllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
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
          'Verification Code',
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: screenHeight * 0.06),
              
              // Email text
              Text(
                'Enter the 4-digit code sent to',
                style: ProfixStyles.medium16black.copyWith(
                  color: isDark ? ProfixColors.white : ProfixColors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              
              Text(
                widget.email,
                style: ProfixStyles.bold14black.copyWith(
                  color: ProfixColors.primary,
                ),
                textAlign: TextAlign.center,
              ),
              
              SizedBox(height: screenHeight * 0.08),
              
              // Code input fields
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(4, (index) {
                  return SizedBox(
                    width: 60,
                    height: 60,
                    child: TextFormField(
                      controller: _codeControllers[index],
                      focusNode: _focusNodes[index],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      style: ProfixStyles.bold24black.copyWith(
                        color: isDark ? ProfixColors.white : ProfixColors.black,
                      ),
                      maxLength: 1,
                      decoration: InputDecoration(
                        counterText: '',
                        filled: true,
                        fillColor: isDark ? ProfixColors.darkTheme : ProfixColors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: isDark ? ProfixColors.gray2 : ProfixColors.lightGray,
                            width: 1,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: isDark ? ProfixColors.gray2 : ProfixColors.lightGray,
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: ProfixColors.primary,
                            width: 2,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(1),
                      ],
                      onChanged: (value) {
                        if (value.isNotEmpty && index < 3) {
                          _focusNodes[index].unfocus();
                          _focusNodes[index + 1].requestFocus();
                        }
                      },
                      onFieldSubmitted: (value) {
                        if (value.isNotEmpty && index < 3) {
                          _focusNodes[index + 1].requestFocus();
                        }
                      },
                    ),
                  );
                }),
              ),
              
              SizedBox(height: screenHeight * 0.08),
              
              // Verify button
              CustomElevatedButton(
                text: 'Verify',
                onButtonClick: _verifyCode,
              ),
              
              const SizedBox(height: 16),
              
              // Resend code text
              Center(
                child: GestureDetector(
                  onTap: _resendCode,
                  child: Text.rich(
                    TextSpan(
                      text: "Didn't receive the code? ",
                      style: ProfixStyles.medium16black.copyWith(
                        color: isDark ? ProfixColors.gray2 : ProfixColors.gray,
                      ),
                      children: [
                        TextSpan(
                          text: 'Resend',
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

  void _verifyCode() async {
    final code = _codeControllers.map((controller) => controller.text).join();
    
    if (code.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter the complete verification code'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    // Navigate to reset password screen
    Navigator.of(context).pushNamed(
      '/resetPasswordNew',
      arguments: {
        'email': widget.email,
        'code': code,
      },
    );
  }

  void _resendCode() async {
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
        content: Text('Verification code sent successfully'),
        backgroundColor: Colors.green,
      ),
    );

    // Clear all input fields
    for (var controller in _codeControllers) {
      controller.clear();
    }
    _focusNodes.first.requestFocus();
  }
}
