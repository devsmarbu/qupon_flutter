import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class NeubrutalistButton extends StatefulWidget {
  final String text;
  final Color backgroundColor;
  final bool isLoading;
  final VoidCallback? onTap;
  final Widget? leading;
  final Color textColor;
  final Color borderColor;
  final Color shadowColor;
  final double height;
  final double borderRadius;
  final double borderWidth;
  final double shadowHeight;
  final Offset? shadowOffset;

  const NeubrutalistButton({
    super.key,
    required this.text,
    required this.backgroundColor,
    this.isLoading = false,
    required this.onTap,
    this.leading,
    this.textColor = AppColors.black,
    this.borderColor = AppColors.black,
    this.shadowColor = AppColors.black,
    this.height = 56.0,
    this.borderRadius = 28.0,
    this.borderWidth = 2.0,
    this.shadowHeight = 5.0,
    this.shadowOffset,
  });

  @override
  State<NeubrutalistButton> createState() => _NeubrutalistButtonState();
}

class _NeubrutalistButtonState extends State<NeubrutalistButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isButtonEnabled = widget.onTap != null && !widget.isLoading;

    return GestureDetector(
      onTapDown: isButtonEnabled ? (_) => setState(() => _isPressed = true) : null,
      onTapUp: isButtonEnabled ? (_) => setState(() => _isPressed = false) : null,
      onTapCancel: isButtonEnabled ? () => setState(() => _isPressed = false) : null,
      onTap: isButtonEnabled ? widget.onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 60),
        width: double.infinity,
        height: widget.height,
        transform: _isPressed 
            ? Matrix4.translationValues(0, widget.shadowHeight, 0)
            : Matrix4.translationValues(0, 0, 0),
        decoration: BoxDecoration(
          color: isButtonEnabled ? widget.backgroundColor : widget.backgroundColor.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(widget.borderRadius),
          border: Border.all(color: widget.borderColor, width: widget.borderWidth),
          boxShadow: _isPressed || !isButtonEnabled
              ? []
              : [
                  BoxShadow(
                    color: widget.shadowColor,
                    offset: widget.shadowOffset ?? Offset(0, widget.shadowHeight),
                    blurRadius: 0,
                    spreadRadius: 0,
                  ),
                ],
        ),
        child: Center(
          child: widget.isLoading
              ? SizedBox(
                  width: widget.height * 0.35,
                  height: widget.height * 0.35,
                  child: CircularProgressIndicator(
                    color: widget.textColor,
                    strokeWidth: 2.5,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.leading != null) ...[
                      widget.leading!,
                      const SizedBox(width: 8),
                    ],
                    Text(
                      widget.text,
                      style: TextStyle(
                        color: widget.textColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
