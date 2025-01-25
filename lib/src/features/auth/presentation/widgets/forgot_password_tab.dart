import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unn_grading/src/core/utils/response_state.dart';
import 'package:unn_grading/src/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:unn_grading/src/features/auth/presentation/widgets/new_password_tab.dart';

const _heightSpacing = SizedBox(height: 11);

class ForgotPasswordWidget extends StatefulWidget {
  const ForgotPasswordWidget({super.key});

  @override
  State<ForgotPasswordWidget> createState() => _ForgotPasswordWidgetState();
}

class _ForgotPasswordWidgetState extends State<ForgotPasswordWidget> {
  final emailTEC = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailTEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthResetPasswordState) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const SetNewPasswordWidget(),
          ));
        }
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                ),
              ),
              _heightSpacing,
              _heightSpacing,
              Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: emailTEC,
                      decoration: const InputDecoration(
                        hintText: 'Enter your Email',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) return 'Your Email is required';
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              _heightSpacing,
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'We will send you a password-reset OTP.\nUse this to reset your password.',
                  style: TextStyle(fontSize: 10),
                ),
              ),
              _heightSpacing,
              _heightSpacing,
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  return ElevatedButton(
                    child: state.status is RequestLoading
                        ? const SizedBox.square(
                            dimension: 16,
                            child: Center(
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          )
                        : const Text('Send OTP'),
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        context.read<AuthBloc>().add(AuthSendPasswprdReset(
                              email: emailTEC.text,
                            ));
                      }
                    },
                  );
                },
              ),
              _heightSpacing,
              const Text('or', textAlign: TextAlign.center),
              _heightSpacing,
              TextButton.icon(
                icon: const Icon(Icons.arrow_back),
                label: const Text('Go Back'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
