import 'package:flutter/material.dart';

class ExpandedButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final IconData icon;
  final double iconSize;
  final bool expanded;
  final Color backgroundColor;
  final Color foregroundColor;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final double? width;
  final TextStyle? textStyle;

  const ExpandedButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.icon = Icons.arrow_forward,
    this.iconSize = 16,
    this.expanded = false,
    this.backgroundColor = Colors.green,
    this.foregroundColor = Colors.white,
    this.borderRadius = 12,
    this.padding = const EdgeInsets.symmetric(vertical: 10),
    this.width,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final button = ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: iconSize),
      label: Text(
        text,
        style: textStyle ?? const TextStyle(fontSize: 12),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        padding: padding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        elevation: 0,
        minimumSize: Size(width ?? 0, 40),
      ),
    );

    return expanded
        ? Expanded(child: button)
        : SizedBox(width: width ?? double.infinity, child: button);
  }
}