// ignore_for_file: file_names

import 'package:flutter/material.dart';
import '../../core/app_cores.dart';

class PlusButton extends StatelessWidget {
  final VoidCallback onPressed;

  const PlusButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppCores.buttonBackground,
          boxShadow: [
            BoxShadow(
              color: AppCores.buttonBackground.withAlpha(60),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(
          Icons.add,
          color: AppCores.buttonText,
          size: 28,
        ),
      ),
    );
  }
}
