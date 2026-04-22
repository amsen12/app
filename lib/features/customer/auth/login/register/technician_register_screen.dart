import 'package:flutter/material.dart';
import 'dart:io'; // نحتاجه للتعامل مع ملف الصورة
import 'package:image_picker/image_picker.dart';
import 'package:app/features/customer/auth/login/register/profission_card.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:app/providers/language_provider.dart';
import 'package:app/utils/profixStyles.dart';
import 'package:app/utils/profix_colors.dart';
import 'package:app/widgets/custom_text_Widget.dart';
import 'package:app/widgets/custom_text_field.dart';
import 'package:app/widgets/custom_uploadImage.dart';
import 'package:provider/provider.dart';
import 'package:app/providers/user_provider.dart';
import 'package:app/core/network/api_client.dart';
import 'package:app/core/services/auth_service.dart';

import '../../home_screen/main_navigator.dart';
import '../../../../auth/data/datasources/auth_remote_data_source.dart';
import '../../../../auth/data/repositories/auth_repository_impl.dart';
import '../../../../auth/domain/repositories/auth_repository.dart';
class TechnicianRegisterScreen extends StatefulWidget {
  static const String routeName = 'technician_register';
  const TechnicianRegisterScreen({super.key});

  @override
  State<TechnicianRegisterScreen> createState() => _TechnicianRegisterScreenState();
}

class _TechnicianRegisterScreenState extends State<TechnicianRegisterScreen> {
  // 1. المتغيرات الخاصة بالمنطق
  final _formKey = GlobalKey<FormState>(); // مفتاح الفورم للـ Validation
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  String _selectedProfession = 'Plumber';
  File? _idImage; // المتغير الذي سيخزن الصورة المختارة
  final ImagePicker _picker = ImagePicker();

  late final AuthRepository _authRepository;
  late final AuthService _authService;

  @override
  void initState() {
    super.initState();
    _authRepository = AuthRepositoryImpl(AuthRemoteDataSource());
    _authService = AuthService();
  }

  // 2. ميثود اختيار الصورة من المعرض
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _idImage = File(pickedFile.path);
      });
    }
  }
  // 3. ميثود الضغط على زر Create Account
  Future<void> _onRegisterPressed() async {
    if (!_formKey.currentState!.validate()) return;

    if (_idImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please upload your National ID photo"),
          backgroundColor: Colors.red,
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
      // ملاحظة: الـ backend الحالي لا يستقبل الـ profession أو صورة الهوية في /auth/register
      final result = await _authRepository.registerTechnician(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        password: _passwordController.text.trim(),
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
          content: Text('Registration successful! Your account is now pending review.'),
          backgroundColor: Colors.green[600],
          duration: const Duration(seconds: 3),
        ),
      );

      Navigator.pushReplacementNamed(context, TechnicianShell.routeName);
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
  bool isObscured = true;
  @override
  Widget build(BuildContext context) {
    var languageProvider=Provider.of<AppLanguageProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title:  Text("Technician Sign Up", style: ProfixStyles.medium18black),
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.build_outlined, size: 40, color: ProfixColors.green),
              ),
              const SizedBox(height: 24),
              CustomTextWidget(text: AppLocalizations.of(context)!.create_account,
                  textStyle: ProfixStyles.bold24black),
              CustomTextWidget(text: "Sign up as a technician", textStyle: ProfixStyles.medium16gray),
              const SizedBox(height: 32),
              CustomTextField(
                controller: _nameController,
                hintText: "Enter your name",
                hintStyle: ProfixStyles.regular14gray,
                prefixIcon: Icon(Icons.person_outline),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Name is required';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _emailController,
                hintText: "Enter your email",
                keyboardType: TextInputType.emailAddress,
                hintStyle: ProfixStyles.regular14gray,
                prefixIcon: Icon(Icons.email_outlined),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Email is required';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _phoneController,
                hintText: "Enter your phone number",
                keyboardType: TextInputType.number,
                 hintStyle: ProfixStyles.regular14gray,
                prefixIcon: Icon(Icons.phone_outlined),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'phone is required';
                  return null;
                },
              ),
              const SizedBox(height: 24),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text("Profession", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ProfessionCard(
                    title: "Plumber",
                    icon: Icons.plumbing,
                    isSelected: _selectedProfession == "Plumber",
                    onTap: () => setState(() => _selectedProfession = "Plumber"),
                  ),
                  ProfessionCard(
                    title: "Electrician",
                    icon: Icons.lightbulb_outline,
                    isSelected: _selectedProfession == "Electrician",
                    onTap: () => setState(() => _selectedProfession = "Electrician"),
                  ),
                  ProfessionCard(
                    title: "Carpenter",
                    icon: Icons.handyman_outlined,
                    isSelected: _selectedProfession == "Carpenter",
                    onTap: () => setState(() => _selectedProfession = "Carpenter"),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "National ID Photo",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              const SizedBox(height: 12),
              IDUploadPicker(
                imageFile: _idImage, // المتغير اللي شايل الصورة في الـ State
                onTap: _pickImage,   // الميثود اللي بتفتح الاستوديو
                onDelete: () {
                  setState(() => _idImage = null); // ميزة إضافية لمسح الصورة
                },
              ),
              const SizedBox(height: 24),
              CustomTextField(
                controller: _passwordController,
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

              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _onRegisterPressed, // استدعاء ميثود التحقق
                  style: ElevatedButton.styleFrom(
                    //
                    backgroundColor: ProfixColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child:  Text(AppLocalizations.of(context)!.create_account, style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "By signing up, your account will be reviewed before approval.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Text(AppLocalizations.of(context)!.already_have_account),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Text('Sign in', style: TextStyle(color: Color(0xFF4A90E2), fontWeight: FontWeight.bold)),
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
}
