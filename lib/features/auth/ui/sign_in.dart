import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:task_manager/features/auth/cubit/auth_cubit.dart';
import 'package:task_manager/features/auth/cubit/auth_state.dart';
import 'package:task_manager/features/auth/ui/sign_up.dart';
import 'package:task_manager/utils/routes/routes.dart';
import 'package:task_manager/utils/snackbar/snackbar.dart';
import 'package:task_manager/utils/widgets/custom_button.dart';
import 'package:task_manager/utils/widgets/custom_textfield.dart';
import 'package:task_manager/utils/widgets/themed_page.dart';

class SignIn extends StatelessWidget {
  SignIn({super.key});

  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return ThemedPage(
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: listener,
        builder: (context, state) {
          return ListView(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.05,
            ),
            children: [
              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: screenHeight * 0.1),
                    Center(
                      child: Text(
                        'Sign In',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                            ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.1),
                    CustomTextField(
                      controller: emailController,
                      hintText: 'Enter email',
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: Icon(Icons.email,
                          color: Theme.of(context).dividerColor),
                      validator: emailValidator,
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    CustomTextField(
                      controller: passwordController,
                      hintText: 'Enter your password',
                      isPassword: true,
                      prefixIcon: Icon(Icons.password,
                          color: Theme.of(context).dividerColor),
                      validator: passwordValidator,
                    ),
                    SizedBox(height: screenHeight * 0.1),
                    BlocBuilder<AuthCubit, AuthState>(
                      builder: (context, state) {
                        return CustomButton(
                          text: 'Login',
                          isLoading: state.authStatus.isLoading,
                          onTap: () => submit(
                            context: context,
                            email: emailController.text,
                            password: passwordController.text,
                          ),
                        );
                      },
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    CustomButton(
                      width: double.maxFinite,
                      text: 'Sign up with Google',
                      isBorder: true,
                      color: Colors.transparent,
                      textColor: Theme.of(context).dividerColor,
                      isIconButton: true,
                      widget: SvgPicture.asset(
                        'assets/icons/google.svg',
                        width: 24,
                      ),
                      isIconStarting: true,
                      onTap: () => context.read<AuthCubit>().signInWithGoogle(),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Center(
                      child: RichText(
                        text: TextSpan(
                          text: "Don't have an account? ",
                          style: Theme.of(context).textTheme.bodyMedium,
                          children: [
                            TextSpan(
                              text: 'Sign Up here',
                              style: const TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.normal,
                                fontSize: 12,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => Navigator.push(
                                      context,
                                      MaterialPageRoute<SignUp>(
                                        builder: (context) => SignUp(),
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void listener(BuildContext context, AuthState state) {
    if (state.authStatus.succeeded) {
      syncTaksks(context, state);
    } else if (state.authStatus.failed) {
      showTopSnackBar(
        context,
        state.authStatus.failureMessage!,
        isSuccess: false,
      );
    }
  }

  void syncTaksks(BuildContext context, AuthState state) async {
    if (state.user != null) {
      if (context.mounted) {
        Navigator.pushReplacementNamed(context, Routes.landing);
      }
    }
  }

  void submit(
      {required BuildContext context,
      required String email,
      required String password}) {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthCubit>().login(email: email, password: password);
    }
  }

  String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please add an Email';
    }

    // Regular expression for validating an email address.
    final RegExp emailRegex = RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }

    return null;
  }

  String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    // Example check: password must be at least 6 characters long.
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    // You can add additional complexity checks here (uppercase, numbers, symbols, etc.)
    return null;
  }
}
