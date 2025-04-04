import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/features/auth/cubit/auth_cubit.dart';
import 'package:task_manager/features/auth/cubit/auth_state.dart';
import 'package:task_manager/features/auth/ui/sign_in.dart';
import 'package:task_manager/utils/cubits/terms_cubit.dart';
import 'package:task_manager/utils/routes/routes.dart';
import 'package:task_manager/utils/snackbar/snackbar.dart';
import 'package:task_manager/utils/widgets/custom_button.dart';
import 'package:task_manager/utils/widgets/custom_textfield.dart';
import 'package:task_manager/utils/widgets/themed_page.dart';

class SignUp extends StatelessWidget {
  SignUp({super.key});

  final _formKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final confirmPasswordController = TextEditingController();

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
                  SizedBox(height: screenHeight * 0.05),
                  Center(
                    child: Text(
                      'Sign Up',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  CustomTextField(
                    controller: emailController,
                    hintText: 'Enter your email',
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon:  Icon(Icons.email, color: Theme.of(context).dividerColor,),
                    validator: emailValidator,
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  CustomTextField(
                    controller: passwordController,
                    hintText: 'Enter your password',
                    isPassword: true,
                    prefixIcon:  Icon(Icons.password, color: Theme.of(context).dividerColor,),
                    validator: passwordValidator,
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  CustomTextField(
                    controller: confirmPasswordController,
                    hintText: 'Confirm your password',
                    isPassword: true,
                    prefixIcon:  Icon(
                      Icons.password,
                      color: Theme.of(context).dividerColor,
                    ),
                    validator: (value) => confirmPasswordValidator(passwordController.text, confirmPasswordController.text),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  BlocBuilder<TermsCubit, bool>(
                    builder: (context, agreeToTerms) {
                      return Padding(
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () => context.read<TermsCubit>().toggle(),
                              child: Container(
                                height: 20,
                                width: 20,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: agreeToTerms
                                        ? Colors.blue
                                        : Colors.grey,
                                  ),
                                  color: agreeToTerms
                                      ? Colors.blue
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: agreeToTerms
                                    ? const Icon(
                                        Icons.check,
                                        size: 16,
                                        color: Colors.white,
                                      )
                                    : null,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  text: 'I agree to the ',
                                  style: DefaultTextStyle.of(context)
                                      .style
                                      .copyWith(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 12,
                                      ),
                                  children: [
                                    TextSpan(
                                      text: 'Terms and Conditions',
                                      style: const TextStyle(
                                        color: Colors.blue,
                                        decoration: TextDecoration.underline,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 12,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {},
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  SizedBox(height: screenHeight * 0.05),
                  BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) {
                      return CustomButton(
                        text: 'Create Account',
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
                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: 'Already have an account? ',
                        style: Theme.of(context).textTheme.bodyMedium,
                        children: [
                          TextSpan(
                            text: 'Sign In here',
                            style: const TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.normal,
                              fontSize: 12,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => Navigator.push(
                                    context,
                                    MaterialPageRoute<SignIn>(
                                      builder: (context) => SignIn(),
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.1),
                ],
              ),
            ),
          ],
        );
      },
    ));
  }

  void listener(BuildContext context, AuthState state) {
    if (state.authStatus.succeeded) {
      showTopSnackBar(
        context,
        'Account successfully created, Sign in to continue',
        isSuccess: true,
      );
      Navigator.pushReplacementNamed(context, Routes.signIn);
    }else if(state.authStatus.failed){
      showTopSnackBar(
        context,
        state.authStatus.failureMessage!,
        isSuccess: false,
      );
    }
  }

  void submit(
      {required BuildContext context,
      required String email,
      required String password}) {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthCubit>().register(email: email, password: password);
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

// Confirm Password Validator
  String? confirmPasswordValidator(String? password, String? confirmPassword) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return 'Please confirm your password';
    }
    else if (password != confirmPassword) {
      return 'Passwords do not match';
    }
    return null;
  }
}
