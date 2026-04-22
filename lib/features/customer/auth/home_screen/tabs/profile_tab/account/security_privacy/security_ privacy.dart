import 'package:flutter/material.dart';
import 'package:app/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class CustomerSecurityPrivacy extends StatelessWidget {
  const CustomerSecurityPrivacy({super.key});
  static String routeName = "SecurityPrivacyPage";
  
  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<AppThemeProvider>(context);
    bool isDark = themeProvider.isDarkTheme();
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F1729) : Colors.white,
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: isDark ? Colors.white : Colors.black, size: 20),
            onPressed: () =>  Navigator.pop(context)
        ),
        title: Text(
          'Security & Privacy',
          style: TextStyle(color: isDark ? Colors.white : const Color(0xFF2D3E50), fontWeight: FontWeight.bold),
        ),
        backgroundColor: isDark ? const Color(0xFF0F1729) : Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(
          children: [
            _buildSecurityOption(
              context: context,
              icon: Icons.lock_outline,
              title: 'Change Password',
              iconColor: Colors.blue,
              onTap: (){
                Navigator.pushNamed(context, "ChangePasswordScreen");
              }
            ),
            const SizedBox(height: 15),
            _buildSecurityOption(
              context: context,
              icon: Icons.description_outlined,
              title: 'Terms & Conditions',
              iconColor: Colors.blue,
              onTap: (){
                Navigator.pushNamed(context, "TermsConditionsPage");
              }
            ),
            const SizedBox(height: 15),
            _buildSecurityOption(
              context: context,
              icon: Icons.shield_outlined,
              title: 'Privacy Policy',
              iconColor: Colors.blue,
              onTap: (){
                Navigator.pushNamed(context, "privacy_policy");
              }
              ),
            const SizedBox(height: 15),
            _buildSecurityOption(
              context: context,
              icon: Icons.delete_outline,
              title: 'Delete Account',
              iconColor: Colors.red,
              textColor: Colors.red,
              onTap: (){
                Navigator.pushNamed(context, "deleteAccount");
              }
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecurityOption({
    required BuildContext context,
    required IconData icon,
    required String title,
    required Color iconColor,
    required VoidCallback onTap,
    Color textColor = const Color(0xFF2D3E50),
  }) {
    var themeProvider = Provider.of<AppThemeProvider>(context);
    bool isDark = themeProvider.isDarkTheme();
    
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A2235) : Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: isDark ? Colors.white10 : Colors.grey.shade200),
      ),
      child: ListTile(
        leading: Icon(icon, color: iconColor),
        title: Text(
          title,
          style: TextStyle(
            color: isDark ? Colors.white : textColor,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
        onTap:onTap
      ),
    );
  }
}
