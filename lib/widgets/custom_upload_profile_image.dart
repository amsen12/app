import 'dart:io';
import 'package:flutter/material.dart';

class CustomUploadProfileImage extends StatelessWidget {
  final File? imageFile;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const CustomUploadProfileImage({
    super.key,
    required this.imageFile,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // الدائرة الأساسية للصورة
          GestureDetector(
            onTap: onTap,
            child: CircleAvatar(
              radius: 60,
              backgroundColor: Colors.grey[200],
              backgroundImage: imageFile != null ? FileImage(imageFile!) : null,
              child: imageFile == null
                  ? Icon(Icons.person, size: 70, color: Colors.grey[400])
                  : null,
            ),
          ),

          // أيقونة الكاميرا (تظهر فقط لو مفيش صورة)
          if (imageFile == null)
            Positioned(
              bottom: 0,
              right: 5,
              child: GestureDetector(
                onTap: onTap,
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.blue,
                  child: Icon(Icons.camera_alt, size: 20, color: Colors.white),
                ),
              ),
            ),

          // أيقونة المسح (تظهر فقط لو فيه صورة)
          if (imageFile != null)
            Positioned(
              top: 0,
              right: 0,
              child: GestureDetector(
                onTap: onDelete,
                child: CircleAvatar(
                  radius: 15,
                  backgroundColor: Colors.red,
                  child: Icon(Icons.close, size: 18, color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }
}