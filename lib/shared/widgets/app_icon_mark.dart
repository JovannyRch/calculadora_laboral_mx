import 'package:calculadora_laboral_mx/shared/extensions/context_extensions.dart';
import 'package:flutter/material.dart';

class AppIconMark extends StatelessWidget {
  const AppIconMark({this.size = 48, super.key});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: context.colors.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(size * 0.28),
        border: Border.all(
          color: context.colors.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Icon(
        Icons.balance_rounded,
        size: size * 0.52,
        color: context.colors.primary,
      ),
    );
  }
}
