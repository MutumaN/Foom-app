import 'package:flutter/material.dart';

enum ButtonVariant { filled, outlined, text }

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final ButtonVariant? variant;
  final IconData? icon;
  final Color? color;

  const AppButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.variant,
    this.icon,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final buttonVariant = variant ?? (isOutlined ? ButtonVariant.outlined : ButtonVariant.filled);
    
    switch (buttonVariant) {
      case ButtonVariant.outlined:
        return OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: color != null
              ? OutlinedButton.styleFrom(foregroundColor: color)
              : null,
          child: _buildChild(),
        );
      case ButtonVariant.text:
        return TextButton(
          onPressed: isLoading ? null : onPressed,
          style: color != null
              ? TextButton.styleFrom(foregroundColor: color)
              : null,
          child: _buildChild(),
        );
      case ButtonVariant.filled:
      default:
        return ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: color != null
              ? ElevatedButton.styleFrom(backgroundColor: color)
              : null,
          child: _buildChild(),
        );
    }
  }

  Widget _buildChild() {
    if (isLoading) {
      return const SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Text(text),
        ],
      );
    }

    return Text(text);
  }
}

