import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class GlassInput extends StatelessWidget {
  final TextEditingController? controller;
  final String labelText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final IconData? prefixIcon;

  const GlassInput({
    super.key,
    required this.labelText,
    this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.glassWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: const TextStyle(color: AppColors.textPrimary),
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(color: AppColors.textSecondary),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          prefixIcon: prefixIcon != null 
            ? Icon(prefixIcon, color: AppColors.textSecondary) 
            : null,
        ),
      ),
    );
  }
}
