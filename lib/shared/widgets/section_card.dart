import 'package:calculadora_laboral_mx/core/constants/app_colors.dart';
import 'package:calculadora_laboral_mx/shared/extensions/context_extensions.dart';
import 'package:flutter/material.dart';

class SectionCard extends StatefulWidget {
  const SectionCard({
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.onTap,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  @override
  State<SectionCard> createState() => _SectionCardState();
}

class _SectionCardState extends State<SectionCard> {
  var _pressed = false;

  @override
  Widget build(BuildContext context) {
    final borderColor = context.isDark ? Colors.white10 : AppColors.border;

    return AnimatedScale(
      scale: _pressed ? 0.985 : 1,
      duration: const Duration(milliseconds: 110),
      curve: Curves.easeOut,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: widget.onTap,
          onTapDown: widget.onTap == null
              ? null
              : (_) => setState(() => _pressed = true),
          onTapCancel: widget.onTap == null
              ? null
              : () => setState(() => _pressed = false),
          onTapUp: widget.onTap == null
              ? null
              : (_) => setState(() => _pressed = false),
          child: Container(
            width: double.infinity,
            padding: widget.padding,
            decoration: BoxDecoration(
              border: Border.all(color: borderColor),
              borderRadius: BorderRadius.circular(20),
            ),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
