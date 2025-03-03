import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    this.label,
    this.onTap,
    this.color,
    this.hintColor = Colors.grey,
    this.borderRadius = 20,
    this.prefixIcon,
    this.suffixIcon,
    this.isLogin = false,
    this.hintText,
    this.labelText,
    this.keyboardType,
    this.isPassword = false,
    this.validator,
    this.readOnly = false,
    this.maxLines = 1,
    this.fontsize = 16,
    this.focusNode,
    this.onChanged,
    this.onSubmitted,
    this.textInputAction,
    this.minLines = 1,
  });

  final TextEditingController controller;
  final Widget? label;
  final VoidCallback? onTap;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Color? color;
  final Color? hintColor;
  final double borderRadius;
  final double fontsize;
  final bool? isLogin;
  final String? hintText;
  final String? labelText;
  final TextInputType? keyboardType;
  final bool readOnly;
  final bool isPassword;
  final String? Function(String?)? validator;
  final int? maxLines;
  final FocusNode? focusNode;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final TextInputAction? textInputAction;
  final int minLines;

  @override
  CustomTextFieldState createState() => CustomTextFieldState();
}

class CustomTextFieldState extends State<CustomTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    // Initialize _obscureText based on whether it's a password field.
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          minLines: widget.minLines,
          textInputAction: widget.textInputAction,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onSubmitted,
          focusNode: widget.focusNode,
          cursorColor: Colors.blue,
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          maxLines: widget.maxLines,
          readOnly: widget.readOnly,
          validator: widget.validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onTapOutside: (event) =>
              FocusManager.instance.primaryFocus?.unfocus(),
          onTap: widget.onTap,
          obscureText: _obscureText,
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: TextStyle(
              color: widget.hintColor,
              fontSize: 12,
              fontWeight: FontWeight.normal,
            ),
            filled: true,
            fillColor: theme.scaffoldBackgroundColor,
            label: widget.label,
            contentPadding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            prefixIcon: widget.prefixIcon,
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: Colors.black,
                    ),
                    onPressed: obscure,
                  )
                : widget.suffixIcon,
            // Add borders with borderSide.
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: BorderSide(
                color: Colors.grey.shade500,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: BorderSide(
                color: Colors.grey.shade500,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: const BorderSide(
                color: Colors.blue,
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: const BorderSide(
                color: Colors.red,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 1.5,
              ),
            ),
          ),
          style: TextStyle(
            fontWeight: FontWeight.normal,
            color: widget.color,
            fontSize: widget.fontsize,
            decoration: TextDecoration.none,
            decorationThickness: 0,
          ),
        ),
      ],
    );
  }

  void obscure() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
}
