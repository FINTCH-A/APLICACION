// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import '../../../config/theme/app_colors.dart';
import '../../../config/theme/app_borders.dart';
import '../../../config/theme/app_shadows.dart';
import '../../../config/theme/text_styles.dart';

enum PremiumButtonVariant {
  primary,
  secondary,
  outline,
  ghost,
  destructive,
  gradient,
}

enum PremiumButtonSize { small, medium, large, xlarge }

class PremiumButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final PremiumButtonVariant variant;
  final PremiumButtonSize size;
  final IconData? icon;
  final bool isLoading;
  final bool isFullWidth;
  final bool isDisabled;

  const PremiumButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.variant = PremiumButtonVariant.primary,
    this.size = PremiumButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = true,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: _getHeight(),
      child: ElevatedButton(
        onPressed: (isDisabled || isLoading) ? null : onPressed,
        style: _getButtonStyle(),
        child: _buildChild(),
      ),
    );
  }

  Widget _buildChild() {
    if (isLoading) {
      return SizedBox(
        height: _getHeight() * 0.5,
        width: _getHeight() * 0.5,
        child: const CircularProgressIndicator(
          strokeWidth: 2,
          color: Colors.white,
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: _getIconSize()),
          const SizedBox(width: 8),
          Text(text, style: _getTextStyle()),
        ],
      );
    }

    return Text(text, style: _getTextStyle());
  }

  ButtonStyle _getButtonStyle() {
    final baseStyle = ElevatedButton.styleFrom(
      elevation: 0,
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: AppBorders.button),
      padding: _getPadding(),
    );

    switch (variant) {
      case PremiumButtonVariant.primary:
        return baseStyle.copyWith(
          backgroundColor: MaterialStateProperty.all(AppColors.primary),
          foregroundColor: MaterialStateProperty.all(Colors.white),
        );

      case PremiumButtonVariant.secondary:
        return baseStyle.copyWith(
          backgroundColor: MaterialStateProperty.all(AppColors.secondary),
          foregroundColor: MaterialStateProperty.all(Colors.white),
        );

      case PremiumButtonVariant.outline:
        return baseStyle.copyWith(
          backgroundColor: MaterialStateProperty.all(Colors.transparent),
          foregroundColor: MaterialStateProperty.all(AppColors.primary),
          side: MaterialStateProperty.all(
            const BorderSide(color: AppColors.primary, width: 1.5),
          ),
        );

      case PremiumButtonVariant.ghost:
        return baseStyle.copyWith(
          backgroundColor: MaterialStateProperty.all(Colors.transparent),
          foregroundColor: MaterialStateProperty.all(AppColors.primary),
          elevation: MaterialStateProperty.all(0),
        );

      case PremiumButtonVariant.destructive:
        return baseStyle.copyWith(
          backgroundColor: MaterialStateProperty.all(AppColors.error),
          foregroundColor: MaterialStateProperty.all(Colors.white),
        );

      case PremiumButtonVariant.gradient:
        return baseStyle.copyWith(
          backgroundColor: MaterialStateProperty.all(Colors.transparent),
          foregroundColor: MaterialStateProperty.all(Colors.white),
          elevation: MaterialStateProperty.all(0),
          shadowColor: MaterialStateProperty.all(Colors.transparent),
        );
    }
  }

  double _getHeight() {
    switch (size) {
      case PremiumButtonSize.small:
        return 40;
      case PremiumButtonSize.medium:
        return 48;
      case PremiumButtonSize.large:
        return 56;
      case PremiumButtonSize.xlarge:
        return 64;
    }
  }

  EdgeInsets _getPadding() {
    switch (size) {
      case PremiumButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
      case PremiumButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 24, vertical: 12);
      case PremiumButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 32, vertical: 16);
      case PremiumButtonSize.xlarge:
        return const EdgeInsets.symmetric(horizontal: 40, vertical: 20);
    }
  }

  double _getIconSize() {
    switch (size) {
      case PremiumButtonSize.small:
        return 16;
      case PremiumButtonSize.medium:
        return 20;
      case PremiumButtonSize.large:
        return 24;
      case PremiumButtonSize.xlarge:
        return 28;
    }
  }

  TextStyle _getTextStyle() {
    switch (size) {
      case PremiumButtonSize.small:
        return TextStyles.labelSmall;
      case PremiumButtonSize.medium:
        return TextStyles.labelMedium;
      case PremiumButtonSize.large:
        return TextStyles.labelLarge;
      case PremiumButtonSize.xlarge:
        return TextStyles.titleSmall;
    }
  }
}
