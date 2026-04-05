import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/providers/app_provider.dart';
import 'package:app/providers/language_provider.dart';
import 'package:app/providers/theme_provider.dart';
import 'package:app/providers/user_provider.dart' as up;
import 'package:app/theme.dart';
import 'package:app/screens/landing_screen.dart';
import 'package:app/features/customer/auth/home_screen/main_navigator.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:app/features/customer/auth/login/login_screen.dart';
import 'package:app/features/customer/auth/login/register/register_screen.dart';
import 'package:app/features/customer/auth/login/register/reset_password.dart';
import 'package:app/features/customer/auth/home_screen/tabs/profile_tab/edit_profile.dart';
import 'package:app/features/customer/auth/home_screen/tabs/profile_tab/profile_tab.dart';
import 'package:app/features/customer/auth/home_screen/tabs/profile_tab/account/address.dart';
import 'package:app/features/customer/auth/home_screen/tabs/profile_tab/account/reviews_page.dart';
import 'package:app/features/technican/profile_technican/profile_tab.dart';
import 'package:app/features/customer/auth/home_screen/tabs/profile_tab/account/security_privacy/terms_conditions.dart';
import 'package:app/features/technican/profile_technican/account/security_privacy/privacy_policy.dart';
import 'package:app/features/customer/auth/home_screen/tabs/profile_tab/account/security_privacy/change_password.dart';
import 'package:app/features/technican/profile_technican/account/security_privacy/delete_account.dart';
import 'package:app/features/technican/profile_technican/edit_profile_page_for_technical.dart';
import 'package:app/features/technican/profile_technican/account/technical_address.dart';
import 'package:app/features/technican/profile_technican/professional/verification.dart';
import 'package:app/features/technican/profile_technican/professional/service_categories_page.dart';
import 'package:app/features/technican/profile_technican/professional/service_areas_page.dart';
import 'package:app/models/models.dart' as models;
import 'package:app/screens/customer_home_screen.dart';

import 'features/customer/auth/login/register/technician_register_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppLanguageProvider()),
        ChangeNotifierProvider(create: (_) => AppThemeProvider()),
        ChangeNotifierProvider(create: (_) => up.UserProvider()),
        ChangeNotifierProvider(create: (_) => AppProvider()),
      ],
      child: const ProFixApp(),
    ),
  );
}

class ProFixApp extends StatelessWidget {
  const ProFixApp({super.key});

  @override
  Widget build(BuildContext context) {
    var languageProvider = Provider.of<AppLanguageProvider>(context);
    var themeProvider = Provider.of<AppThemeProvider>(context);

    return MaterialApp(
      title: 'ProFix',
      debugShowCheckedModeBanner: false,

      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.appTheme,

      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale(languageProvider.appLanguage),

      home: const AppRoot(),



      routes: {
        LoginScreen.routeName: (context) => LoginScreen(),
        CustomerShell.routeName: (context) => CustomerShell(onLogout: () {}),
        TechnicianShell.routeName: (context) => TechnicianShell(onLogout: () {}),
        CustomerRegisterScreen.routeName: (context) =>
         CustomerRegisterScreen(),
        ResetPassword.routeName: (context) =>  ResetPassword(),
        CustomerHomeScreen.routeName: (context) => CustomerHomeScreen(
          onNewRequest: () {},
          onSelectService: (_) {},
          onViewTechnician: (_) {},
          onViewRequest: (_) {},
          onChat: (_) {},
          onNotifications: () {},
        ),
        LandingScreen.routeName: (context) => LandingScreen(onSelectRole: (_) {}),
        EditProfilePage.routeName: (context) => const EditProfilePage(),
        TechnicianProfileTab.routeName: (context) =>
        const TechnicianProfileTab(),
        TechnicianRegisterScreen.routeName: (context) =>
        const TechnicianRegisterScreen(),
        ProfileTab.routeName: (context) => const ProfileTab(),
        MyAddressesPage.routeName: (context) =>  MyAddressesPage(),
        MyReviewsPage.routeName: (context) => const MyReviewsPage(),
        TermsConditionsPage.routeName: (context) => const TermsConditionsPage(),
        PrivacyPolicy.routeName: (context) =>  PrivacyPolicy(),
        ChangePasswordScreen.routeName: (context) =>  ChangePasswordScreen(),
        DeleteAccountScreen.routeName: (context) =>  DeleteAccountScreen(),
        EditProfilePageForTechnical.routeName: (context) =>
        const EditProfilePageForTechnical(),
        TechnicalAddress.routeName: (context) => TechnicalAddress(),
        VerificationScreen.routeName: (context) =>
        const VerificationScreen(),
        ServiceCategoriesPage.routeName: (context) =>
        const ServiceCategoriesPage(),
        ServiceAreasPage.routeName: (context) =>
        const ServiceAreasPage(),
      },
    );
  }
}

class AppRoot extends StatefulWidget {
  const AppRoot({super.key});

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  models.UserRole? _selectedRole;

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();

    // أول حاجة تظهر
    if (_selectedRole == null) {
      return LandingScreen(
        onSelectRole: (role) {
          setState(() {
            _selectedRole = role;
          });
        },
      );
    }

    // لو المستخدم مش مسجل دخول
    if (!app.isAuthenticated) {
      return LoginScreen();
    }

    // Customer
    if (app.user?.role == models.UserRole.customer) {
      return CustomerShell(
        onLogout: () {
          app.logout();
          setState(() => _selectedRole = null);
        },
      );
    }

    // Technician
    return TechnicianShell(
      onLogout: () {
        app.logout();
        setState(() => _selectedRole = null);
      },
    );
  }
}
