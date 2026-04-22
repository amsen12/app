import 'package:app/screens/landing_screen.dart';
import 'package:flutter/material.dart';
import 'package:app/features/customer/auth/home_screen/language_bottom_sheet.dart';
import 'package:app/features/customer/auth/home_screen/tabs/profile_tab/account/address.dart';
import 'package:app/features/customer/auth/home_screen/tabs/profile_tab/account/reviews_page.dart';
import 'package:app/features/customer/auth/home_screen/tabs/profile_tab/account/security_privacy/security_ privacy.dart';
import 'package:app/features/customer/auth/home_screen/tabs/profile_tab/custom_menu_item.dart';
import 'package:app/features/customer/auth/home_screen/tabs/profile_tab/userInfoHeader.dart';
import 'package:app/features/customer/auth/home_screen/tabs/profile_tab/switch_menu_item.dart';
import 'package:app/features/customer/auth/home_screen/tabs/profile_tab/theme_switch.dart';
import 'package:app/features/customer/auth/home_screen/tabs/profile_tab/edit_profile.dart';
import 'package:app/providers/language_provider.dart';
import 'package:app/providers/theme_provider.dart';
import 'package:app/providers/user_provider.dart';
import 'package:app/utils/profix_images.dart';
import 'package:app/widgets/custom_build_logoutButton.dart';
import 'package:provider/provider.dart';
class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});
  static String routeName = "profile";
  @override
  State<ProfileTab> createState() => _ProfileTabState();
}
class _ProfileTabState extends State<ProfileTab> {
  void onEditTap() {
    Navigator.pushNamed(context, EditProfilePage.routeName);
  }

  void showLanguageBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) => const LanguageBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    var languageProvider = Provider.of<AppLanguageProvider>(context);
    var themeProvider = Provider.of<AppThemeProvider>(context);
    var userProvider = Provider.of<UserProvider>(context);
    bool isDark = themeProvider.isDarkTheme();

    // Get dynamic data from provider
    String currentName = userProvider.name ?? 'Customer';
    String currentEmail = userProvider.email ?? '';
    String currentPhone = userProvider.phone ?? '';
    String currentRole = userProvider.isTechnician() ? "Technician" : "Customer";
    String currentImagePath = userProvider.profileImage ?? ProfixImages.routeImage;
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F1729) : const Color(0xFFF8F9FA),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 60),
              UserInfoHeader(
                userName: currentName,
                userRole: currentRole,
                email: currentEmail,
                phone: currentPhone,
                imagePath: currentImagePath,
                rate: userProvider.rate ?? 0.0,
                totalJobs: userProvider.totalJobs ?? 0,
                showRate: userProvider.isTechnician(),
                onEditTap: onEditTap,
              ),
              const SizedBox(height: 30),
              _buildSectionTitle("Account"),
              _buildGroupedContainer(isDark, [
                MenuItem(icon: Icons.location_on_outlined,
                    title: "My Addresses",
                    isDark: isDark,
                onTap: (){
                   Navigator.pushNamed(context, MyAddressesPage.routeName);
                },),
                _buildDivider(isDark),
                MenuItem(icon: Icons.chat_bubble_outline,
                    title: "My Reviews" ,
                    isDark: isDark,
                onTap: (){
                  Navigator.pushNamed(context, MyReviewsPage.routeName);
                },),
                _buildDivider(isDark),
                MenuItem(icon: Icons.security_outlined,
                    title: "Security & Privacy", isDark: isDark,onTap: (){
                  Navigator.pushNamed(context, CustomerSecurityPrivacy.routeName);
                  },)
              ]),
              const SizedBox(height: 24),
              _buildSectionTitle("Preferences"),
              _buildGroupedContainer(isDark, [
                MenuItem(icon:Icons.language,
                      title: "Language",
                      isDark: isDark,
                      trailingText: languageProvider.appLanguage == 'en' ? "English" : "العربية",
                      onTap: showLanguageBottomSheet),

                _buildDivider(isDark),
                ThemeSwitchTile(themeProvider: themeProvider, isDark: isDark
                ),
              ]),
              const SizedBox(height: 24),
              _buildSectionTitle("Notifications"),
              _buildGroupedContainer(isDark, [
                SwitchMenuItem(icon:Icons.notifications_none_outlined,
                  title: 'New Requests',
                  value: true,
                  onChanged: (bool value) {  },
                  isDark: isDark,
                ),
                _buildDivider(isDark),
                SwitchMenuItem(icon: Icons.check_circle_outline_rounded,
                    title: "Status Updates", value: true, onChanged: (val) {}
                    , isDark: isDark),
                _buildDivider(isDark),
                SwitchMenuItem(icon: Icons.mail_outline_rounded,
                    title: "New Messages",
                    value: true, onChanged: (val){}, isDark: isDark)
              ]),
              const SizedBox(height: 24),
              _buildSectionTitle("Help & Support"),
             _buildGroupedContainer(isDark, [
               MenuItem(icon:Icons.help_outline_rounded ,
                 title: "FAQ",
                 isDark: isDark,
                 onTap: (){},
               ),
                _buildDivider(isDark),
               MenuItem(icon: Icons.mail_outline_rounded,
                   title: "Contact Us",
                   onTap: (){},
                   isDark: isDark),
              ]),
               const SizedBox(height: 32),
              LogoutButton(
                onPressed: () {
                   Navigator.of(context).pushReplacementNamed(LandingScreen.routeName);
                },
              ),
              const SizedBox(height: 30),

          ]),
        ),
      )
    );
  }
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 10),
      child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey)),
    );
  }
  Widget _buildGroupedContainer(bool isDark, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A2235) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          if (!isDark) BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, spreadRadius: 5),
        ],
      ),
      child: Column(children: children),
    );
  }
  Widget _buildDivider(bool isDark) {
    return Divider(height: 1, indent: 50, endIndent: 15, color: isDark ? Colors.white10 : Colors.grey[100]);
  }
}
