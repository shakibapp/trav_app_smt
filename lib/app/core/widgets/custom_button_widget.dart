import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_colors.dart';

class CustomButtonWidget extends StatelessWidget {
  const CustomButtonWidget({
    super.key,
    required this.label,
    required this.onPressed,
    this.bgColor,
    this.fgColor,
    this.borderColor,
    this.borderWidth,
    this.radius,
    this.height,
    this.width,
    this.fullWidth = false,
    this.padding,
    this.elevation,
    this.textStyle,
    this.leading,
    this.trailing,
    this.iconGap,
    this.loading = false,
    this.outlined = false,
    this.gradient,
  });

  /// FACTORY SHORTCUTS
  factory CustomButtonWidget.primary({
    Key? key,
    required String label,
    required VoidCallback? onPressed,
    bool loading = false,
    bool fullWidth = true,
  }) => CustomButtonWidget(
    key: key,
    label: label,
    onPressed: onPressed,
    loading: loading,
    fullWidth: fullWidth,
    bgColor: AppColors.authOrange,
    fgColor: AppColors.whiteColor,
  );

  factory CustomButtonWidget.outline({
    Key? key,
    required String label,
    required VoidCallback? onPressed,
    Color? color,
    bool loading = false,
    bool fullWidth = true,
    double? height,
  }) => CustomButtonWidget(
    key: key,
    label: label,
    onPressed: onPressed,
    loading: loading,
    fullWidth: fullWidth,
    outlined: true,
    borderColor: color ?? AppColors.lightGrayishGreen,
    fgColor: color ?? AppColors.lightGrayishGreen,
    height: height,
  );

  /// Core props
  final String label;
  final VoidCallback? onPressed;

  /// Colors & style
  final Color? bgColor; // ignored when [gradient] != null
  final Color? fgColor;
  final Color? borderColor;
  final double? borderWidth;
  final double? radius;
  final double? height;
  final double? width;
  final bool fullWidth;
  final EdgeInsetsGeometry? padding;
  final double? elevation;
  final TextStyle? textStyle;
  final bool outlined;
  final Gradient? gradient;

  /// Extras
  final Widget? leading;
  final Widget? trailing;
  final double? iconGap;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final double resolvedHeight = (height ?? 50.h).clamp(40.h, 64.h);
    final double resolvedRadius = (radius ?? 12.r);
    final Color resolvedBg = (bgColor ?? AppColors.lightGrayishGreen);
    final Color resolvedFg = (fgColor ?? AppColors.whiteColor);
    final Color resolvedBorder = (borderColor ?? resolvedBg);
    final double resolvedBorderW = (borderWidth ?? 1.2);
    final EdgeInsetsGeometry resolvedPadding =
        padding ?? EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h);
    final double gap = (iconGap ?? 8.w);

    // When gradient is provided, we paint it behind an ElevatedButton with transparent bg.
    final bool useGradient = gradient != null;

    final ButtonStyle baseStyle = ElevatedButton.styleFrom(
      elevation: elevation ?? (outlined || useGradient ? 0 : 1),
      backgroundColor: useGradient
          ? Colors.transparent
          : (outlined ? Colors.transparent : resolvedBg),
      foregroundColor: resolvedFg,
      shadowColor: Colors.black.withOpacity(0.15),
      padding: EdgeInsets.zero, // we'll handle padding in child
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(resolvedRadius),
        side: outlined
            ? BorderSide(color: resolvedBorder, width: resolvedBorderW)
            : BorderSide.none,
      ),
    );

    final childContent = _buildContent(
      context,
      fg: outlined ? (fgColor ?? resolvedBorder) : resolvedFg,
      gap: gap,
      resolvedPadding: resolvedPadding,
    );

    Widget button = ElevatedButton(
      onPressed: loading ? null : onPressed,
      style: baseStyle,
      child: Ink(
        // allows ripple over gradient/decoration
        decoration: BoxDecoration(
          color: (useGradient || outlined) ? Colors.transparent : resolvedBg,
          gradient: useGradient ? gradient : null,
          borderRadius: BorderRadius.circular(resolvedRadius),
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: resolvedHeight),
          child: Align(alignment: Alignment.center, child: childContent),
        ),
      ),
    );

    // Wrap with Material if needed for outline ripple contrast
    if (outlined || useGradient) {
      button = Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(resolvedRadius),
        child: button,
      );
    }

    return SizedBox(width: fullWidth ? double.infinity : width, child: button);
  }

  Widget _buildContent(
    BuildContext context, {
    required Color fg,
    required double gap,
    required EdgeInsetsGeometry resolvedPadding,
  }) {
    final TextStyle defaultStyle = TextStyle(
      fontSize: 15.sp,
      fontWeight: FontWeight.w600,
      color: fg,
    );

    final labelText = Text(
      label,
      textAlign: TextAlign.center,
      style: (textStyle ?? defaultStyle),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );

    final Widget inner = loading
        ? SizedBox(
            width: 20.w,
            height: 20.w,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(fg),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (leading != null) ...[leading!, SizedBox(width: gap)],
              Flexible(child: labelText),
              if (trailing != null) ...[SizedBox(width: gap), trailing!],
            ],
          );

    return Padding(padding: resolvedPadding, child: inner);
  }
}
