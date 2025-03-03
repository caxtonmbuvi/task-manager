import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.text,
    this.onTap,
    this.color,
    this.textColor = Colors.white,
    this.radius = 22,
    this.isIconButton = false,
    this.isIconStarting = false,
    this.isBorder = false,
    this.widget,
    this.fontSize = 14,
    this.height = 45,
    this.width,
    this.fontWeight = FontWeight.w500,
    this.isLoading = false,
  });
  final String text;
  final VoidCallback? onTap;
  final Color? color;
  final Color? textColor;
  final double radius;
  final bool isIconButton;
  final bool isIconStarting;
  final bool isBorder;
  final Widget? widget;
  final double fontSize;
  final double? height;
  final double? width;
  final FontWeight fontWeight;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final adjustedHeight = height ?? 50.0;

    return  SizedBox(
      height: adjustedHeight,
      width: width,
      child: ElevatedButton(
        onPressed: isLoading ? null : onTap,
        style: ButtonStyle(
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius),
              side: isBorder
                  ?  BorderSide(
                    color: Theme.of(context).dividerColor,
                  )
                  : BorderSide.none,
            ),
          ),
          backgroundColor: WidgetStateProperty.all(
            color ?? Colors.blue,
          ),
          elevation: WidgetStateProperty.all(0),
        ),
        child: isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(textColor ?? Colors.white),
                ),
              )
            : isIconButton
                ? isIconStarting
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          widget!,
                          const SizedBox(width: 10),
                          Text(
                            text,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: textColor,
                                  fontSize: fontSize,
                                  fontWeight: fontWeight,
                                ),
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            text,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: textColor,
                                  fontSize: fontSize,
                                  fontWeight: fontWeight,
                                ),
                          ),
                          const SizedBox(width: 10),
                          widget!,
                        ],
                      )
                : Text(
                    text,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: textColor,
                          fontSize: fontSize,
                          fontWeight: fontWeight,
                        ),
                  ),
      ),
    );
  }
}
