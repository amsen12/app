import 'dart:io';
import 'package:flutter/material.dart';
import 'package:app/features/customer/auth/login/register/register_screen.dart';
import 'package:app/features/customer/auth/login/register/technician_register_screen.dart';
import 'package:app/features/customer/auth/login/register/forgot_password_screen.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:app/providers/user_provider.dart';
import 'package:app/providers/theme_provider.dart';
import 'package:app/features/technican/profile_technican/profile_tab.dart';

import 'package:app/utils/profixStyles.dart';
import 'package:app/utils/profix_colors.dart';
import 'package:app/utils/profix_theme.dart';
import 'package:provider/provider.dart';

import 'package:app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:app/features/auth/domain/repositories/auth_repository.dart';
import 'package:app/core/network/api_client.dart';
import 'package:app/core/services/auth_service.dart';



import '../../../../screens/landing_screen.dart';
import '../home_screen/main_navigator.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = 'loginScreen';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  bool isObscured = true;
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  late final AuthRepository _authRepository;
  late final AuthService _authService;

  @override
  void initState() {
    super.initState();
    _authRepository = AuthRepositoryImpl(AuthRemoteDataSource());
    _authService = AuthService();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<AppThemeProvider>(context);
    final l10n = AppLocalizations.of(context)!;
    bool isDark = themeProvider.isDarkTheme();

    var height = MediaQuery.of(context).size.height;
    // استقبال النوع المرسل (customer أو technician)
    final String userType = ModalRoute.of(context)?.settings.arguments as String? ?? 'customer';

    return Scaffold(
        backgroundColor: ProfixTheme.getBackgroundColor(isDark),
        appBar: AppBar(
          backgroundColor: ProfixTheme.getBackgroundColor(isDark),
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: ProfixTheme.getTextColor(isDark), size: 20),
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => LandingScreen(
                    onSelectRole: (role) {
                      // Handle role selection if needed
                    },
                  ),
                ),
                (route) => false,
              );
            },
          ),
          title: Text(
            userType == 'customer' ? l10n.customer_login : l10n.technician_login,
            style: ProfixStyles.bold20black.copyWith(
              color: ProfixTheme.getTextColor(isDark),
            ),
          ),
          centerTitle: false,
        ),
        body: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: ProfixColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Icon(
                    userType == 'customer' ? Icons.person : Icons.build,
                    size: 50,
                    color: ProfixColors.primary,
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  l10n.welcome_to_profix,
                  style: ProfixStyles.text3xlBold.copyWith(
                    color: ProfixTheme.getTextColor(isDark),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.your_trusted_platform,
                  textAlign: TextAlign.center,
                  style: ProfixStyles.medium16gray.copyWith(
                    color: ProfixTheme.getMutedTextColor(isDark),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 40),
                Container(
                  decoration: BoxDecoration(
                    color: ProfixTheme.getSurfaceColor(isDark),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: ProfixTheme.getBorderColor(isDark),
                      width: 1,
                    ),
                  ),
                  child: TextField(
                    controller: emailController,
                    focusNode: _emailFocusNode,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    onSubmitted: (value) {
                      FocusScope.of(context).requestFocus(_passwordFocusNode);
                    },
                    decoration: InputDecoration(
                      hintText: l10n.email,
                      hintStyle: ProfixStyles.regular14gray.copyWith(
                        color: ProfixTheme.getMutedTextColor(isDark),
                      ),
                      prefixIcon: Icon(
                        Icons.email_outlined,
                        color: ProfixTheme.getMutedTextColor(isDark),
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    ),
                    style: ProfixStyles.medium16black.copyWith(
                      color: ProfixTheme.getTextColor(isDark),
                    ),
                    enabled: true,
                    readOnly: false,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    color: ProfixTheme.getSurfaceColor(isDark),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: ProfixTheme.getBorderColor(isDark),
                      width: 1,
                    ),
                  ),
                  child: TextField(
                    controller: passwordController,
                    focusNode: _passwordFocusNode,
                    obscureText: isObscured,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (value) {
                      _passwordFocusNode.unfocus();
                    },
                    decoration: InputDecoration(
                      hintText: l10n.password,
                      hintStyle: ProfixStyles.regular14gray.copyWith(
                        color: ProfixTheme.getMutedTextColor(isDark),
                      ),
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        color: ProfixTheme.getMutedTextColor(isDark),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          isObscured ? Icons.visibility_off : Icons.visibility,
                          color: ProfixTheme.getMutedTextColor(isDark),
                        ),
                        onPressed: () {
                          setState(() {
                            isObscured = !isObscured;
                          });
                        },
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    ),
                    style: ProfixStyles.medium16black.copyWith(
                      color: ProfixTheme.getTextColor(isDark),
                    ),
                    enabled: true,
                    readOnly: false,
                  ),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(ForgotPasswordScreen.routeName);
                    },
                    child: Text(
                      l10n.forgot_password,
                      style: ProfixStyles.bold14Primary.copyWith(
                        color: ProfixColors.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    color: ProfixColors.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: login,
                      borderRadius: BorderRadius.circular(12),
                      child: Center(
                        child: Text(
                          l10n.login,
                          style: ProfixStyles.medium16white,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      l10n.dont_have_account,
                      style: ProfixStyles.regular14gray.copyWith(
                        color: ProfixTheme.getMutedTextColor(isDark),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          if (userType == 'customer') {
                            Navigator.of(context).pushNamed(CustomerRegisterScreen.routeName);
                          } else {
                            Navigator.of(context).pushNamed(TechnicianRegisterScreen.routeName);
                          }
                        },
                        child: Text(
                          l10n.create_account,
                          style: ProfixStyles.bold14Primary.copyWith(
                            color: ProfixColors.primary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
    );
  }

  Future<bool> _checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  Future<void> login() async {
    // Basic validation since Form was removed
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter email and password'),
          backgroundColor: Colors.red[600],
        ),
      );
      return;
    }

    final l10n = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    bool hasInternet = await _checkInternetConnection();
    if (!mounted) return;

    if (!hasInternet) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(l10n.no_internet),
          backgroundColor: Colors.red[600],
          duration: const Duration(seconds: 4),
          action: SnackBarAction(
            label: l10n.cancel,
            textColor: Colors.white,
            onPressed: () => messenger.hideCurrentSnackBar(),
          ),
        ),
      );
      return;
    }

    final userProvider = Provider.of<UserProvider>(context, listen: false);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final result = await _authRepository.login(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (!mounted) return;

      final user = result.$1;
      final token = result.$2;

      ApiClient().setAuthToken(token);

      userProvider.setUser(
        id: user.id,
        name: user.name,
        email: user.email,
        role: user.role,
        phone: user.phone,
        profileImage: user.profileImage,
        token: token,
      );

      navigator.pop(); // close loader

      messenger.showSnackBar(
        SnackBar(
          content: Text(l10n.login_successful),
          backgroundColor: Colors.green[600],
          duration: const Duration(seconds: 3),
        ),
      );

      if (userProvider.isTechnician()) {
        navigator.pushReplacementNamed(TechnicianShell.routeName);
      } else {
        navigator.pushReplacementNamed(CustomerShell.routeName);
      }
    } catch (e) {
      if (!mounted) return;
      navigator.pop(); // close loader

      String errorMessage = l10n.error;
      String errorString = e.toString().toLowerCase();

      if (errorString.contains('email') || errorString.contains('password') || errorString.contains('credentials')) {
        errorMessage = l10n.invalid_credentials;
      } else if (errorString.contains('network') || errorString.contains('connection') || errorString.contains('socket')) {
        errorMessage = l10n.network_error;
      } else if (errorString.contains('not found') || errorString.contains('user')) {
        errorMessage = l10n.user_not_found;
      } else if (errorString.contains('blocked') || errorString.contains('suspended')) {
        errorMessage = l10n.account_suspended;
      } else if (errorString.contains('timeout')) {
        errorMessage = l10n.something_went_wrong;
      } else if (errorString.contains('server') || errorString.contains('500')) {
        errorMessage = l10n.something_went_wrong;
      } else {
        errorMessage = l10n.something_went_wrong;
      }

      messenger.showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red[600],
          duration: const Duration(seconds: 5),
          action: SnackBarAction(
            label: l10n.cancel,
            textColor: Colors.white,
            onPressed: () => messenger.hideCurrentSnackBar(),
          ),
        ),
      );
    }
  }


}
