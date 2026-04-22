
import 'package:app/features/customer/auth/login/login_screen.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:app/widgets/cusstom_text_Button.dart';
import 'package:app/widgets/custom_eleveted_button.dart';
import 'package:app/widgets/custom_text_Widget.dart';
import 'package:app/widgets/custom_text_field.dart';
import 'package:app/utils/profixStyles.dart';
import 'package:app/utils/profix_colors.dart';
import 'package:app/utils/profix_images.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/providers/theme_provider.dart';

import 'package:app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:app/features/auth/domain/repositories/auth_repository.dart';
import 'package:app/core/network/api_client.dart';
import 'package:app/core/services/auth_service.dart';
import 'package:app/providers/user_provider.dart';


import '../../home_screen/main_navigator.dart';

class CustomerRegisterScreen extends StatefulWidget {
 static const  String routeName='registerScreen';
  @override
  State<CustomerRegisterScreen> createState() => _CustomerRegisterScreenState();
}
class _CustomerRegisterScreenState extends State<CustomerRegisterScreen> {
  var nameController=TextEditingController();
  var emailController=TextEditingController();
  var passwordController=TextEditingController();
  var rePasswordController=TextEditingController();
  var phoneController=TextEditingController();
  var formKey = GlobalKey<FormState>();
  bool isObscured = true;

  late final AuthRepository _authRepository;
  late final AuthService _authService;

  @override
  void initState() {
    super.initState();
    _authRepository = AuthRepositoryImpl(AuthRemoteDataSource());
    _authService = AuthService();
  }
  @override
  Widget build(BuildContext context) {
    var height=MediaQuery.of(context).size.height;
    var width=MediaQuery.of(context).size.width;
    var themeProvider = Provider.of<AppThemeProvider>(context);
    bool isDark = themeProvider.isDarkTheme();
    
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F1729) : ProfixColors.white,
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF0F1729) : ProfixColors.white,
        title: Text('Customer Sign Up ',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: isDark ? Colors.white : Colors.black,
          )),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color:  Colors.blue[50] ,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.person_outline, size: 40, color: ProfixColors.blue),
                  ),
                  const SizedBox(height: 24),
                  CustomTextWidget(text: AppLocalizations.of(context)!.create_account,
                      textStyle: ProfixStyles.bold24black),
                  CustomTextWidget(text: "Sign up as a customer", textStyle: ProfixStyles.medium16gray),
                  SizedBox(height: height*0.08,),
                  CustomTextField(
                    controller: nameController,
                    validator: (text){
                      if(text==null|| text.trim().isEmpty){
                        return 'Please enter name';
                      }
                      return null;
                    },
                    hintText: AppLocalizations.of(context)!.name,
                    prefixIcon: Image.asset(ProfixImages.profileTab),
                  ),
                  SizedBox(height: height*0.02,),
                  CustomTextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (text){
                      if(text==null|| text.trim().isEmpty){
                        return 'Please enter email';
                      }
                      final bool emailValid =
                      RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(text);
                      if(!emailValid){
                        return 'Please enter valid email';
                      }
                      return null;
                    },
                    hintText: AppLocalizations.of(context)!.email,
                    prefixIcon: Image.asset(ProfixImages.email),
                  ),
                  SizedBox(height: height*0.02,),
                  CustomTextField(
                    controller: phoneController,
                    keyboardType: TextInputType.number,
                    validator: (text){
                      if(text==null|| text.trim().isEmpty){
                        return 'Please enter phone';
                      }
                      return null;
                    },
                    hintText: AppLocalizations.of(context)!.phone,
                    prefixIcon: Image.asset(ProfixImages.phone),
                  ),
                  SizedBox(height: height*0.02,),
                  CustomTextField(
                    controller: passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    hintText: "Enter your password",
                    // نربط الحالة بالمتغير اللي عرفناه
                    obscureText: isObscured,
                    prefixIcon: Icon(Icons.lock_outline, color: ProfixColors.gray),
                    // نضيف الـ IconButton هنا عشان نغير الحالة لما نضغط عليه
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          isObscured = !isObscured; // اعكس الحالة (لو True تبقى False والعكس)
                        });
                      },
                      icon: Icon(
                        // غير شكل الأيقونة بناءً على الحالة
                        isObscured ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        color: ProfixColors.gray,
                      ),
                    ),
                    validator: (text) {
                      if (text == null || text.trim().isEmpty) return 'Please enter password';
                      return null;
                    },
                  ),
                  SizedBox(height: height*0.02,),
                  CustomTextField(controller: rePasswordController,
                    validator: (text){
                      if(text==null|| text.trim().isEmpty){
                        return 'Please enter password';
                      }
                      if(text.length<6){
                        return 'password should be at least 6';
                      }
                      if(text!=passwordController.text){
                        return "Re-password doesn't match password";
                      }
                      return null;
                    },
                    hintText: AppLocalizations.of(context)!.re_password,
                    obscureText: isObscured,
                    prefixIcon: Icon(Icons.lock_outline, color: ProfixColors.gray),
                    // نضيف الـ IconButton هنا عشان نغير الحالة لما نضغط عليه
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          isObscured = !isObscured; // اعكس الحالة (لو True تبقى False والعكس)
                        });
                      },
                      icon: Icon(
                        // غير شكل الأيقونة بناءً على الحالة
                        isObscured ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        color: ProfixColors.gray,
                      ),
                    ),
                  ),
                  SizedBox(height: height*0.02,),
                  //forget password


                  SizedBox(width: double.infinity,
                      child: CustomElevatedButton(text: AppLocalizations.of(context)!.create_account,onButtonClick:
                        register,)),
                  SizedBox(height: height*0.02,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomTextWidget(text: AppLocalizations.of(context)!.already_have_account,
                          textStyle: ProfixStyles.medium16black),
                      CusstomTextButton(onButtonClicked:(){
                        Navigator.of(context).pushReplacementNamed( LoginScreen.routeName);
                      }
                      ,
                          text:AppLocalizations.of(context)!.login
                      )
                     ],
                  ),
                  SizedBox(height: height*0.02,),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  Future<void> register() async {
    if (formKey.currentState?.validate() != true) return;

    final userProvider = Provider.of<UserProvider>(context, listen: false);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final result = await _authRepository.registerCustomer(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        phone: phoneController.text.trim(),
        password: passwordController.text.trim(),
      );

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

      Navigator.of(context).pop(); // close loader
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Registration successful! Welcome to Profix.'),
          backgroundColor: Colors.green[600],
          duration: const Duration(seconds: 3),
        ),
      );
      
      Navigator.pushReplacementNamed(context, CustomerShell.routeName);
    } catch (e) {
      Navigator.of(context).pop(); // close loader
      
      String errorMessage = 'Registration failed';
      String errorString = e.toString().toLowerCase();
      
      if (errorString.contains('email') || errorString.contains('exists')) {
        errorMessage = 'This email is already registered. Please use a different email or try logging in.';
      } else if (errorString.contains('network') || errorString.contains('connection')) {
        errorMessage = 'Network error. Please check your internet connection and try again.';
      } else if (errorString.contains('password')) {
        errorMessage = 'Password is too weak. Please choose a stronger password.';
      } else if (errorString.contains('phone')) {
        errorMessage = 'Phone number is invalid or already in use.';
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red[600],
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }
}
