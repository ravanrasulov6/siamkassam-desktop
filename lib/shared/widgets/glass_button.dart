import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class GlassButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  final Color? color;
  final double borderRadius;

  const GlassButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.color,
    this.borderRadius = 12.0,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(borderRadius),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: color ?? AppColors.primary.withOpacity(0.8),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: AppColors.glassBorder),
            boxShadow: [
              BoxShadow(
                color: (color ?? AppColors.primary).withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: DefaultTextStyle.merge(
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
